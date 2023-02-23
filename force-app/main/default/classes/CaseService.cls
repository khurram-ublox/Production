/**
* @description General functionality to work with cases
*
* @author eru
* @copyright PARX
*/
public with sharing class CaseService
{
    
    @AuraEnabled
    public static Case getOriginalCase(Id caseId)
    {
        if ( String.isBlank(caseId) )
        {
            return null;
        }
        String query = SoqlUtils.buildQuery('Case');
        query += ' WHERE Id = :caseId';
        List<Case> cases = (List<Case>)Database.query(query);
        if ( !cases.isEmpty() )
        {
            return cases[0];
        }
        return null;
    }
    
    @AuraEnabled
    public static String getOriginalCaseRecordType(Id caseId)
    {
        if ( String.isBlank(caseId) )
        {
            return null;
        }
        List<RecordType> recordTypes = [SELECT Id, Name FROM RecordType WHERE Id = '012D0000000BarO'];
        if ( !recordTypes.isEmpty() )
        {
            return recordTypes[0].Name;
        }
        return null;
    }
    
    @AuraEnabled
    public static Case getOriginalCaseForNewSubCase(Id caseId)
    {
        if ( String.isBlank(caseId) )
        {
            return null;
        }
        List<Case> cases = [SELECT Product__c,CaseNumber, ContactId, Id, AccountId, ParentId, Type, Status, Origin,
                            Subject, Priority, Opportunity__c, Bug_Reference__c, Technology__c
                            FROM Case WHERE Id = :caseId];
        if ( !cases.isEmpty() )
        {
            return cases[0];
        }
        return null;
    }
    
    @AuraEnabled
    public static List<CaseComment> getCaseComments(Id caseId)
    {
        List<CaseComment> caseComments = [SELECT CommentBody, CreatedById, CreatedBy.Name, CreatedDate FROM CaseComment WHERE ParentId = :caseId ORDER BY CreatedDate Desc];
        return caseComments;
    }
    
    @AuraEnabled
    public static List<EmailMessage> getCaseEmails(Id caseId)
    {
        List<EmailMessage> caseEmails = [SELECT Subject, MessageDate, toLabel(Status), ToAddress, FromAddress, Incoming FROM EmailMessage WHERE ParentId = :caseId ORDER BY CreatedDate Desc];
        return caseEmails;
    }
    
    @AuraEnabled
    public static List<Attachment> getCaseAttachments(Id caseId) {
        List<Attachment> caseAttachments = [SELECT Id, Name, ParentId FROM Attachment WHERE ParentId = :caseId ORDER BY CreatedDate Desc];
        return caseAttachments;
    }
    
    @AuraEnabled
    public static List<Attachment> getCaseEmailAttachments(Id caseId)
    {
        List<EmailMessage> caseEmails = [SELECT Id FROM EmailMessage WHERE ParentId = :caseId ORDER BY CreatedDate Desc];
        List<Attachment> caseAttachments = [SELECT Id, Name, ParentId, BodyLength, CreatedDate, CreatedById, CreatedBy.Name  FROM Attachment WHERE ParentId IN :caseEmails ORDER BY CreatedDate Desc];
        return caseAttachments;
    }
    
    @AuraEnabled
    public static List<Attachment> getRMAattachments(Id RMAId)
    {
        system.debug('RMA IDs-->>'+ RMAId);
        //List<EmailMessage> caseEmails = [SELECT Id FROM EmailMessage WHERE ParentId = :caseId ORDER BY CreatedDate Desc];
        List<Attachment> AttachmentsRMA = [SELECT Id, Name, ParentId, BodyLength, CreatedDate, CreatedById, CreatedBy.Name  FROM Attachment WHERE ParentId = :RMAId ORDER BY CreatedDate Desc];
        system.debug('AttachmentsRMA--->>'+AttachmentsRMA);
        return AttachmentsRMA;
    }
    //to retrive files and notes attached with RMA
    @AuraEnabled
    public static List<ContentDocument> getRMAfiles(Id RMAId)
    {
        Set<Id> contentDocIds = new Set<Id>();

        system.debug('RMA IDs-->>'+ RMAId);
        //getting set of ids of the files associated with RMA
        List<ContentDocumentLink> contentDocLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId in ( SELECT Id FROM RMA__c WHERE Id = :RMAId) ];
        for(ContentDocumentLink contentDocLink : contentDocLinks) {
            contentDocIds.add(contentDocLink.ContentDocumentId);
        }
        List<Id> contentDocIdList = new List<Id>(contentDocIds);
        system.debug('Files IDs-->>'+ contentDocIdList);
        //query to get content document
        List<ContentDocument> filesRMA = [SELECT Id, Title, OwnerId, ParentId, ContentSize, CreatedDate, CreatedById, CreatedBy.Name FROM ContentDocument
                                            WHERE ID =: contentDocIdList];
        system.debug('Files--->>'+filesRMA);
        return filesRMA;
    }
    
    @AuraEnabled
    public static User getCurrentUser()
    {
        Id currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT Name FROM User WHERE Id = :currentUserId];
        return currentUser;
    }
    
    @AuraEnabled
    public static Id splitCase(Id originalCaseId, Case newCase, String selectedCommentsIds, String selectedEmailsIds, String selectedAttachmentsIds)
    {
        System.debug(LoggingLevel.WARN, 'OriginalCaseId: ' + originalCaseId);
        System.debug(LoggingLevel.WARN, 'newCase: ' + newCase);
        System.debug(LoggingLevel.WARN, 'selectedCommentsIds: ' + selectedCommentsIds);
        System.debug(LoggingLevel.WARN, 'selectedEmailsIds: ' + selectedEmailsIds);
        try
        {
            if ( newCase != null )
            {
                newCase.SplitedFrom__c = newCase.Id;
                newCase.Id = null;
                newCase.IsEscalated = false;
                newCase.Bug_Reference__c = '';
                insert newCase;
            }
            System.debug('selectedAttachmentsIds : ' + selectedAttachmentsIds);
            cloneCaseComments(selectedCommentsIds, newCase.Id);
            cloneCaseEmail(selectedEmailsIds, newCase, originalCaseId);
            cloneCaseAttachment(selectedAttachmentsIds, newCase.Id);
            return newCase.Id;
        }
        catch ( Exception ex )
        {
            System.debug(LoggingLevel.ERROR, ex.getMessage() + '\t' + ex.getStackTraceString());
            return null;
        }
    }
    
    @AuraEnabled
    public static Id newSubCase(Id originalCaseId, Case newCase, String selectedAttachmentsIds)
    {
        try
        {
            if ( newCase != null )
            {
                newCase.Id = null;
                newCase.RecordTypeId = '012D0000000BarO';
                newCase.ParentId = originalCaseId;
                insert newCase;
            }
            System.debug('selectedAttachmentsIds : ' + selectedAttachmentsIds);
            cloneCaseAttachment(selectedAttachmentsIds, newCase.Id);
            return newCase.Id;
        }
        catch ( Exception ex )
        {
            System.debug(LoggingLevel.ERROR, ex.getMessage() + '\t' + ex.getStackTraceString());
            return null;
        }
    }
    
    private static void cloneCaseComments(String selectedCommentsIds, Id caseId)
    {
        if ( String.isNotBlank(selectedCommentsIds) )
        {
            List<String> commentIds = selectedCommentsIds.split(',');
            String query = SoqlUtils.buildQuery('CaseComment');
            query += ' WHERE Id IN :commentIds';
            List<CaseComment> originalComments = (List<CaseComment>)Database.query(query);
            List<CaseComment> clonnedComments = originalComments.deepClone(false);
            for ( CaseComment comment : clonnedComments )
            {
                comment.ParentId = caseId;
            }
            insert clonnedComments;
        }
    }
    
    private static void cloneCaseEmail(String selectedEmailsIds, Case newCase, String originalCaseId)
    {
        if ( String.isNotBlank(selectedEmailsIds) )
        {
            List<String> emailsIds = selectedEmailsIds.split(',');
            String query = SoqlUtils.buildQuery('EmailMessage');
            query += ' WHERE Id IN :emailsIds';
            List<EmailMessage> originalEmails = (List<EmailMessage>)Database.query(query);
            List<EmailMessage> clonnedEmails = originalEmails.deepClone(false);
            for ( EmailMessage email : clonnedEmails )
            {
                email.ParentId = newCase.Id;
            }
            replaceThreadId(clonnedEmails, originalCaseId, newCase);
            insert clonnedEmails;
            cloneEmailsAttachments(emailsIds, originalEmails, clonnedEmails);
        }
    }
    
    private static void cloneEmailsAttachments(List<String> emailsIds, List<EmailMessage> originalEmails, List<EmailMessage> clonnedEmails) {
        List<Attachment> listAtt = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE ParentId IN :emailsIds];
        Map<Id, List<Attachment>> mapEmail = new Map<Id, List<Attachment>>();
        
        for (Id emailId : emailsIds) {
            List<Attachment> tempList = new List<Attachment>();
            for (Attachment att : listAtt) {
                if (att.ParentId == emailId) {
                    tempList.add(att);
                }
            }
            mapEmail.put(emailId, tempList);
        }
        
        List<Attachment> cloneAttachments = new List<Attachment>();
        for (Integer i = 0; i < originalEmails.size(); i++) {
            List<Attachment> tempAttachments = mapEmail.get(originalEmails[i].Id);
            if(!tempAttachments.isEmpty()) {
                for(Attachment att : tempAttachments) {
                    Attachment newAtt = new Attachment(Name = att.name, Body = att.body, ParentId = clonnedEmails[i].Id);
                    cloneAttachments.add(newAtt);
                }
            }
        }
        insert cloneAttachments;
    }
    
    private static void cloneCaseAttachment(String selectedAttachmentsIds, Id caseId)
    {
        if (String.isNotBlank(selectedAttachmentsIds))
        {
            List<String> attachIds = selectedAttachmentsIds.split(',');
            List<Attachment> oldAttachments = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE Id IN :attachIds];
            List<Attachment> cloneAttachments = new List<Attachment>();
            for(Attachment att : oldAttachments) {
                Attachment newAtt = new Attachment(Name = att.name, Body = att.body, ParentId = caseId);
                cloneAttachments.add(newAtt);
            }
            insert cloneAttachments;
        }
    }
    
    private static void replaceThreadId(List<EmailMessage> messages, String oldCaseId, Case newCase)
    {
        String oldThreadId = getThreadId(oldCaseId);
        String newThreadId = getThreadId(newCase.Id);
        for ( EmailMessage message : messages )
        {
            if ( String.isNotBlank(message.Subject) && message.Subject.contains(oldThreadId) )
            {
                message.Subject.replace(oldThreadId, newThreadId);
                System.debug('Replaced threadId in Subject');
            }
            if ( String.isNotBlank(message.TextBody) && message.TextBody.contains(oldThreadId) )
            {
                message.TextBody.replace(oldThreadId, newThreadId);
                System.debug('Replaced threadId in TextBody');
            }
            if ( String.isNotBlank(message.HtmlBody) && message.HtmlBody.contains(oldThreadId) )
            {
                message.HtmlBody.replace(oldThreadId, newThreadId);
                System.debug('Replaced threadId in HtmlBody');
            }
        }
    }
    
    @testVisible
    private static String getThreadId(String caseId)
    {
        return '[ ref:_'  + UserInfo.getOrganizationId().left(5) + UserInfo.getOrganizationId().mid(10,5) + '._'  + caseId.left(5)  + caseId.mid(10,5) + ':ref ]';
    }
    //Id caseId
    @AuraEnabled
    public static List<Case> getRelatedCases(Id caseId)
    {
        system.debug('CaseId from Apex-->>'+caseId);
        List<Case> relatedCases = [SELECT Id,CaseNumber,Subject,type,priority,status FROM Case WHERE ParentId =: CaseId ORDER BY CreatedDate Desc];
        return relatedCases;
    }
    
    @AuraEnabled
    public static void saveAttachmentsToSubCase(String caseId, String selectedAttachmentsId)
    {
        
        system.debug('Case Id--->>'+caseId);
        system.debug('selectedAttachmentsId--->>'+selectedAttachmentsId);
        if (String.isNotBlank(selectedAttachmentsId))
        {
            List<String> attachIds = selectedAttachmentsId.split(',');
            List<String> caseIds = caseId.split(',');
            
            Set<String> duplicateAttachmentNames = new Set<String>();
            for(Attachment tempAttach :  [SELECT name,parentId from attachment WHERE parentId IN :caseIds ]){
                duplicateAttachmentNames.add(tempAttach.Name+tempAttach.parentId);
            }
            List<Attachment> oldAttachments = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE Id IN :attachIds];
            List<Attachment> cloneAttachments = new List<Attachment>();
            for(Attachment att : oldAttachments) {
                for(String tempcaseId : caseIds){
                    if(!duplicateAttachmentNames.contains(Att.Name+tempcaseId)){
                        Attachment newAtt = new Attachment(Name = att.name, Body = att.body, ParentId = tempcaseId);
                        cloneAttachments.add(newAtt);
                    }else{
                        Attachment newAtt = new Attachment(Name = att.name, Body = att.body, ParentId = tempcaseId);
                        cloneAttachments.add(newAtt);
                    }
                }
            }
            insert cloneAttachments;
        }else{
            system.debug('no attachment is selected');
            
        }
        
    }    

    @AuraEnabled
    public static void saveFilesToSubCase(String caseId, String selectedFileIds)
    {
        
        system.debug('Case Id--->>'+caseId);
        system.debug('selectedFilesId--->>'+selectedFileIds);
        List<String> fileIds = selectedFileIds.split(',');
        List<ContentDocumentLink> ContentDocLinks = [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId 
        IN ( SELECT Id FROM Case  WHERE Id = :caseId) ];
        system.debug('ContentDocLinks--->>'+ContentDocLinks);
        Map<Id,String> ContentIdVSContentDocListMap = new Map<Id, String>();
        Map<Id,Id> duplicateDocListMap = new Map<Id, Id>();
        // if (String.isNotBlank(selectedFilesId))
        if(fileIds.size() > 0){
        for(ContentDocumentLink cdl : ContentDocLinks){
                duplicateDocListMap.put(cdl.ContentDocumentId, cdl.ContentDocumentId);

        }
    }   
        if(fileIds.size() > 0){
            for(String cdl : fileIds){
                ContentIdVSContentDocListMap.put(cdl, caseId);
            }
        }

        system.debug('ContentIdVSContentDocListMap--->>'+ContentIdVSContentDocListMap);

            List<ContentDocumentLink> cloneFilesLink = new List<ContentDocumentLink>();
            for(String fileId : fileIds) {
                    if(!duplicateDocListMap.containsKey(fileId)){
                        ContentDocumentLink newAtt = new ContentDocumentLink(ContentDocumentId = fileId, LinkedEntityId = ContentIdVSContentDocListMap.get(fileId));
                        cloneFilesLink.add(newAtt);
                    // }else{
                    //     Attachment newAtt = new Attachment(Name = file.name, Body = file.body, ParentId = tempcaseId);
                    //     cloneAttachments.add(newAtt);
                    // }
            }
            system.debug('cloneFilesLink--->>'+cloneFilesLink);
            if(cloneFilesLink.size() > 0){insert cloneFilesLink;}
            }
            
        }
}
public class AttachmentToFileConverterHelper {
    public static void convertAttachmentToFile(Map<Id,sObject> attachmentIdMap,String objectAPI){
        Savepoint sp = Database.setSavepoint(); 
        Set<Id> attachmentIdsSet = new Set<Id>();
        try{
        
            if(!String.isEmpty(objectAPI))
            {
                for(Attachment attach: (List<Attachment>)attachmentIdMap.values()){
                    if(attach.ParentId.getSObjectType().getDescribe().getName().equalsIgnoreCase(objectAPI))
                    {
                        attachmentIdsSet.add(attach.id);
                    }
                }
            }
            
            if(attachmentIdsSet.size()>0)
            {
                List<Attachment> lstAttachment = [SELECT Id, ParentId, Name,Description, CreatedById,
                                                  CreatedDate, LastModifiedById, LastModifiedDate, 
                                                  OwnerId, isPrivate, Body 
                                                  FROM Attachment where 
                                                  Id IN: attachmentIdsSet ];
                
                    Map<String,String> fileNameAttachmentIdMap = new Map<String,String>();
                    Map<Id, Attachment> mapIdAttachment = new Map<Id, Attachment>();
                    for(Attachment attach: lstAttachment){
                        if(!String.isEmpty(objectAPI) && !attach.ParentId.getSObjectType().getDescribe().getName().equalsIgnoreCase(objectAPI))
                        {
                            continue;
                        }
                        mapIdAttachment.put(attach.Id, attach);
                        fileNameAttachmentIdMap.put(attach.name,attach.id);
                    }
                    
                    SalesToolFiles__c salesToolSetting = SalesToolFiles__c.getInstance();
                    String stfolderName = salesToolSetting.Library_Folder_Name__c;
                        
                    if(mapIdAttachment.keySet().size()>0){
                        List<ContentWorkspace> wsList = [SELECT Id, RootContentFolderId FROM ContentWorkspace WHERE Name =: stfolderName ];
                    
                        if(wsList.size()>0)
                        {
                            List<ContentVersion> mapActIdLstCV = createContentVersionAttachment(mapIdAttachment,fileNameAttachmentIdMap);
                        
                            List<ContentDocumentLink> lstCVDL = updateContentDocLink(mapActIdLstCV,wsList[0].id);
                        
                            deleteAttachments(mapIdAttachment.keySet(),objectAPI);
                        }else
                        {
                            throw new ConversionException(System.Label.SalesToolFolderNotPresent+stfolderName);
                        }
                    }
              }
        }Catch(Exception ex){
            Database.rollback(sp);
            throw ex;
        }
    }
    
    public static List<ContentVersion> createContentVersionAttachment(Map<Id, Attachment> mapAttachment,
                                                                     Map<String,String> fileNameAttachmentIdMap){
                                                                         
        Savepoint sp = Database.setSavepoint();                                                        
        List<ContentVersion> newFileVersionList = new List<ContentVersion>();
        Map<String,String> allExternalIdContentDocument = new Map<String,String>();
        for(ContentVersion cvObj : [select id,ContentDocumentId,ExternalId__c from ContentVersion where ExternalId__c =:fileNameAttachmentIdMap.keySet()]){
            if(cvObj.ExternalId__c!=null)
                allExternalIdContentDocument.put(cvObj.ExternalId__c,cvObj.ContentDocumentId);
        }
        for(Id attachmentId : mapAttachment.keySet()){
            string attName = mapAttachment.get(attachmentId).name;
            string extId = attName.length() > 255 ? attName.substring(0,255):attName;
            
            ContentVersion newFileVersion = new ContentVersion(
                versionData              = mapAttachment.get(attachmentId).body,
                title                    = attName,
                description              = mapAttachment.get(attachmentId).description,
                pathOnClient             = '/' + attName,
                ExternalId__c            =  extId ,
                IsMajorVersion = true
            );
            if(!allExternalIdContentDocument.containsKey(extId))
            {
                newFileVersion.firstPublishLocationId   = mapAttachment.get(attachmentId).parentId;                    
            }
            if(allExternalIdContentDocument.containsKey(newFileVersion.ExternalId__c))
            {
                newFileVersion.ContentDocumentId = allExternalIdContentDocument.get(newFileVersion.ExternalId__c);
            }
            newFileVersionList.add(newFileVersion);                   
            
        }
        try{
            Database.DMLOptions dmlOptions = new Database.DMLOptions();
            dmlOptions.OptAllOrNone = false;
            
            List<Database.SaveResult> saveResultRecords = Database.insert(newFileVersionList, dmlOptions);
            For(Database.SaveResult sr : saveResultRecords){
                if(sr.isSuccess()){
                    
                }else if(!sr.isSuccess()){
                    String errMsg = '';
                    for( Database.Error err : sr.getErrors()){
                        errMsg = + err.getMessage();
                    }
                    throw new ConversionException('Error while insert-->'+errMsg);
                }
            }
            return newFileVersionList;
        }catch(Exception ex){
            Database.rollback(sp);
            throw ex;
        }
    }
    
    public static List<ContentDocumentLink> updateContentDocLink(List<ContentVersion>  contentVerList,Id folderId){
        Set<String> cvSet = new Set<String>();
        for(ContentVersion cvObj : contentVerList){
            cvSet.add(cvObj.Id);                        
        }
        List<ContentVersion> cvLst = [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN: cvSet ];
        Set<String> ContentDocumentIdSet = new Set<String>();
        for(ContentVersion cvObj : cvLst){
            ContentDocumentIdSet.add(cvObj.ContentDocumentId);            
        }
        Map<String,ContentDocumentLink> alreadyPresentCdLink = new Map<String,ContentDocumentLink>(); 
        for(ContentDocumentLink cdLink : [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN: ContentDocumentIdSet AND LinkedEntityId =: folderId ])
        {
            alreadyPresentCdLink.put(cdLink.ContentDocumentId,cdLink);
        }
        List<ContentDocumentLink> cdlLst = new List<ContentDocumentLink>();
        for(ContentVersion cv: cvLst){
            if(!alreadyPresentCdLink.containsKey(cv.ContentDocumentId)){
                ContentDocumentLink cdl     = new ContentDocumentLink(); 
                cdl.ContentDocumentId       = cv.ContentDocumentId; 
                cdl.LinkedEntityId          = folderId; 
                cdl.ShareType               = 'I'; 
                cdlLst.add(cdl);
            }
        }
        if(cdlLst.size()>0)
            insert cdlLst;
        return cdlLst;
    }
    
    @future
    static void deleteAttachments(Set<Id> attachmentsId,String objectAPI) {
        List<Attachment> allAttachments = [select id,ParentId from attachment where id IN: attachmentsId ];
        List<Attachment> allAttachmentsToDelete = new List<Attachment>();
        for(Attachment attach : allAttachments){
            if(attach.ParentId.getSObjectType().getDescribe().getName().equalsIgnoreCase(objectAPI))
            {
                allAttachmentsToDelete.add(attach);
            }
        }
        delete allAttachmentsToDelete;
    }
    
    public class ConversionException extends Exception {}
}
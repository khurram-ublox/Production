public with sharing class CustomFileRelatedListService {
    @AuraEnabled
    public static List<ContentVersion> getFilteredContentDetails(String recordId,String searchStr) {
        String escapeSearchStr = '';
        List<ContentVersion> contentVersionList = new List<ContentVersion>();
        if(!String.isEmpty(searchStr))
        {
            escapeSearchStr = String.escapeSingleQuotes(searchStr);
        }
        
        List<User_File__c> uFileList = null;
        String loggedInUserId = UserInfo.getUserId();
        if(!String.isEmpty(recordId)){
            // This is for extra security check for Community users , has not used dynamic query to remove SQL injection possibilities
            
            if(UserInfo.getUserType() == 'Standard')
            {
                uFileList = [select id,OwnerId from User_File__c where id =: recordId WITH SECURITY_ENFORCED ];
            }else{
                uFileList = [select id,OwnerId from User_File__c where OwnerId =:loggedInUserId AND id =: recordId WITH SECURITY_ENFORCED ];
            }
            if(uFileList == null || uFileList.size() == 0)
            {
                return contentVersionList;
            }
            List<ContentDocumentLink> contentDocumentList = [SELECT ContentDocumentId, LinkedEntityId 
                                                                FROM   ContentDocumentLink 
                                                                WHERE  LinkedEntityId =: recordId];
            Set<Id> contentDocumentIds = new Set<Id>();
                
            for(ContentDocumentLink cdl : contentDocumentList){
                contentDocumentIds.add(cdl.ContentDocumentId);
            }
            if(!String.isEmpty(escapeSearchStr))
            {
                
                List<List<sObject>> searchObjList = [FIND :escapeSearchStr RETURNING 
                                                            ContentVersion(id,ContentDocumentId,VersionData, FileType, Title, FileExtension,TagCSV,
                                                                ContentDocument.CreatedBy.Name, ContentDocument.ContentSize,
                                                                CreatedDate, ContentDocument.FileType
                                                             WHERE ContentDocumentId in :contentDocumentIds AND IsLatest = TRUE)
                                                            ];    
                for(List<sObject> sObjList : searchObjList){
                    for(sObject sObj : sObjList){
                        ContentVersion cvObj = (ContentVersion) sObj;
                        contentVersionList.add(cvObj);
                    }
                }
                 
            }else
            {
                for(ContentVersion cv : [SELECT Id, VersionData, FileType, Title, FileExtension,TagCSV,
                                                    ContentDocument.CreatedBy.Name, ContentDocument.ContentSize,
                                                    CreatedDate, ContentDocumentId, ContentDocument.FileType
                                                    FROM   ContentVersion 
                                                    WHERE  ContentDocumentId IN : contentDocumentIds AND IsLatest = TRUE]){
                    contentVersionList.add(cv);
                }
                
            }
        }
        return contentVersionList;
    }
}
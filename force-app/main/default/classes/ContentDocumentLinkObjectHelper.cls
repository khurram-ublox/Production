public Class ContentDocumentLinkObjectHelper{
    public static string USERFILE_API_NAME = 'User_File__c';
    public static string USERGROUP_API_NAME = 'User_Group__c';
    public static string COMMUNITY_USER_FILE_UPLOAD_ERROR_MSG = Label.CommunityUserFileUploadMsg;
    public static string USER_WITH_GROUP_ERROR_MSG = Label.UserAssociatedToGroupMsg;
    // Used to check whether delete UserFile associated files coming from Other Records like deleting from UserGroupItem.
    public static boolean isCalledFromParentRecord = false;
    
    //Restrict user to upload files for UserFile
    public static void restrictCommunityUserToUploadFileOnUserFile(Map<String,List<ContentDocumentLink>> contentLinkMap)
    {
        if(contentLinkMap!=null && contentLinkMap.size()>0)
        {
            Map<String,List<String>> userCDocMap = new Map<String,List<String>>();
            for(ContentDocument cDoc : [SELECT Id,CreatedById,LastModifiedById,OwnerId FROM ContentDocument where ID IN: contentLinkMap.keySet()])
            {
                String userId = cDoc.CreatedById;
                if(!userCDocMap.containsKey(userId))
                {
                    userCDocMap.put(userId,new List<String>());                        
                }
                userCDocMap.get(userId).add(cDoc.Id);
            }
            
            for(User cUser : [SELECT Id,UserType,ContactId FROM User where ID IN: userCDocMap.keySet() AND ContactId != NULL AND UserType = 'CspLitePortal'])
            {
                for(String cDocId : userCDocMap.get(cUser.Id)){
                    for(ContentDocumentLink cdLink : contentLinkMap.get(cDocId)){
                        cdLink.addError(COMMUNITY_USER_FILE_UPLOAD_ERROR_MSG);
                    }
                }
            }
        }
    }  
    
    //Add Content to UserFiles
    public static void linkContentToUserFile(Map<String,List<ContentDocumentLink>> groupAssociatedLinkMap){
        if(groupAssociatedLinkMap.size()>0)
        {
            Map<String,List<User_Group_Item__c>> userUGroupMap = new Map<String,List<User_Group_Item__c>>();
            
            for(User_Group_Item__c ugItem : [select id,User__c,User_Group__c from User_Group_Item__c where User_Group__c IN: groupAssociatedLinkMap.keySet()])
            {
                if(!userUGroupMap.containsKey(ugItem.User__c))
                {
                    userUGroupMap.put(ugItem.User__c,new List<User_Group_Item__c>());
                }
                userUGroupMap.get(ugItem.User__c).add(ugItem);
            }
            
            Map<String,ContentDocumentLink> allContentDocLinkToInsert = new Map<String,ContentDocumentLink>(); 
            
            for(User_File__c uFile : [select id,OwnerId from User_File__c where OwnerId IN: userUGroupMap.keySet()])
            {
                if(userUGroupMap.containsKey(uFile.OwnerId))
                {
                    for(User_Group_Item__c ugItemObj: userUGroupMap.get(uFile.OwnerId)){
                        for(ContentDocumentLink cdlObj : groupAssociatedLinkMap.get(ugItemObj.User_Group__c)){
                            ContentDocumentLink cdl = new ContentDocumentLink();
                            cdl.ContentDocumentId = cdlObj.ContentDocumentId ;
                            cdl.LinkedEntityId = uFile.id;
                            cdl.ShareType = 'V';
                            cdl.Visibility = 'AllUsers';
                            allContentDocLinkToInsert.put(cdl.ContentDocumentId+'_'+cdl.LinkedEntityId,cdl);
                        }                
                    }            
                }
            }
            if(allContentDocLinkToInsert.size()>0)
            {
                 Database.SaveResult[] sResultList = Database.insert(allContentDocLinkToInsert.values(),false);
            }        
        }
    } 
    
    public static void restrictFileUnlinkUserFile(Map<String,List<ContentDocumentLink>> userFileAssociatedLinkMap,
                                                  Map<String,ContentDocumentLink> contentDocCDLMap ){
        if(userFileAssociatedLinkMap.size()>0)
        {
            Map<String,String> uFileOwnerMap = new Map<String,String>();
        
            for(User_File__c uFile : [select id,OwnerId from User_File__c where id IN: userFileAssociatedLinkMap.keySet() ])
            {
                uFileOwnerMap.put(uFile.id,uFile.OwnerId);
            }

            Map<String,String> groupUserMap = new Map<String,String>();
        
            for(User_Group_Item__c uGItem : [select id,User_Group__c,User__c from User_Group_Item__c where User__c IN: uFileOwnerMap.values() ])
            {
                groupUserMap.put(uGItem.User_Group__c,uGItem.User__c);
            }
            Map<String,Integer> documentGroupCountMap = new Map<String,Integer>();
            for(ContentDocumentLink cdLinkObj : [select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId IN : groupUserMap.keySet() AND ContentDocumentId IN : contentDocCDLMap.keySet()])
            {
                if(!documentGroupCountMap.containsKey(cdLinkObj.ContentDocumentId))
                {
                    documentGroupCountMap.put(cdLinkObj.ContentDocumentId,0);
                }
                documentGroupCountMap.put(cdLinkObj.ContentDocumentId,documentGroupCountMap.get(cdLinkObj.ContentDocumentId) + 1);
                if((isCalledFromParentRecord && documentGroupCountMap.get(cdLinkObj.ContentDocumentId)>1) || 
                   (!isCalledFromParentRecord && documentGroupCountMap.get(cdLinkObj.ContentDocumentId)>=1))
                {
                    if(contentDocCDLMap.containsKey(cdLinkObj.ContentDocumentId))
                        contentDocCDLMap.get(cdLinkObj.ContentDocumentId).addError(USER_WITH_GROUP_ERROR_MSG);
                }
            }
            
        }
    
    }                  
}
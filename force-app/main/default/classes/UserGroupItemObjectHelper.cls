public class UserGroupItemObjectHelper{
    // Associate UserGroupItem to UserFile
    public static void mapUserGroupItemToUserFile(Map<String,User_Group_Item__c> userGroupItemMap)
    {
        if(userGroupItemMap!=null && userGroupItemMap.size()>0)
        {
            for(User_File__c uFileObj : [select id,OwnerId from User_File__c where OwnerId IN : userGroupItemMap.keySet() ])
            {
                userGroupItemMap.get(uFileObj.OwnerId).User_File__c = uFileObj.id;
            }
        }
    }
    
    // While inserting or deleting UserGroupItem associate the change with UserFile 
    public static void doUserGroupItemsChangeToUserFile(Map<String,List<ID>> groupUserMap, Set<String> usersAdded,boolean isInsert)
    {
        if(groupUserMap!=null)
        {
            
            Map<String,List<ContentDocumentLink>> groupCDLMap = new Map<String,List<ContentDocumentLink>>();
            
            for(ContentDocumentLink cdl: [select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId IN : groupUserMap.keySet()])   
            {
                if(!groupCDLMap.containsKey(cdl.LinkedEntityId))
                {
                    groupCDLMap.put(cdl.LinkedEntityId,new List<ContentDocumentLink>());
                }
                groupCDLMap.get(cdl.LinkedEntityId).add(cdl);    
            }
            
            Map<String,String> userUFileMap = new Map<String,String>();
            if(usersAdded!=null && usersAdded.size()>0)
            {
                for(User_File__c uFile : [select id,OwnerId from User_File__c where OwnerId IN: usersAdded])
                {
                    userUFileMap.put(uFile.OwnerId,uFile.id);
                }
            }
            
            Map<String,ContentDocumentLink> allContentDocLinkToInsert = new Map<String,ContentDocumentLink>(); 
            Map<String,String> entityDocMap = new Map<String,String>();
            for(String groupId : groupUserMap.keySet())
            {
                if(groupUserMap.containsKey(groupId))
                {
                    for(String userId : groupUserMap.get(groupId))
                    {
                        if(groupCDLMap.containsKey(groupId))
                        {
                            for(ContentDocumentLink cdlObj : groupCDLMap.get(groupId))
                            {
                                if(userUFileMap.containsKey(userId))
                                {
                                    ContentDocumentLink cdl = new ContentDocumentLink();
                                    cdl.ContentDocumentId = cdlObj.ContentDocumentId ;
                                    cdl.LinkedEntityId = userUFileMap.get(userId);
                                    cdl.ShareType = 'V';
                                    cdl.Visibility = 'AllUsers';
                                    allContentDocLinkToInsert.put(cdl.ContentDocumentId+'_'+cdl.LinkedEntityId,cdl);
                                    entityDocMap.put(cdl.ContentDocumentId,cdl.LinkedEntityId);
                                }
                            }
                        }    
                    }
                }
            }
            
            if(isInsert && allContentDocLinkToInsert.size()>0)
            {
                Database.SaveResult[] sResultList = Database.insert(allContentDocLinkToInsert.values(),false);
            }
            
            if(!isInsert && allContentDocLinkToInsert.size()>0)
            {
                Map<String,String> cdlToDelete = new Map<String,String>();
                for(ContentDocumentLink cdlObj: [select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where 
                                                 ContentDocumentId IN : entityDocMap.keySet() AND LinkedEntityId IN: entityDocMap.values()
                                                ])   
                {
                    if(allContentDocLinkToInsert.containsKey(cdlObj.ContentDocumentId+'_'+cdlObj.LinkedEntityId))
                    {
                        cdlToDelete.put(cdlObj.ContentDocumentId+'_'+cdlObj.LinkedEntityId,cdlObj.id);
                    }
                }
                
                ContentDocumentLinkObjectHelper.isCalledFromParentRecord = true;
                Database.DeleteResult[] sResultDeleteList = Database.delete(cdlToDelete.values(),false);
                ContentDocumentLinkObjectHelper.isCalledFromParentRecord = false;
            }
        }
    }
}
public Class ContentDocumentLinkTriggerHandler implements ITrigger
{
    // Process 1 Data : Give all linkedDocument to UserFile visibility = AllUsers and ShareType = V uploaded by Standard User
    Map<String,List<ContentDocumentLink>> contentLinkMap = null;
    
    // Process 2 : Restrict community user to upload files from UserFile related List.
    
    // Process 3 : Content Linked to UserGroup assigned to all the UserFiles
    Map<String,List<ContentDocumentLink>> groupAssociatedLinkMap = null;    
    
    // Process 4 : check delete files from UserFile whether it is linked to UserGroup also or not
    Map<String,List<ContentDocumentLink>> userFileAssociatedLinkMap = null;
    Map<String,ContentDocumentLink> contentDocCDLMap = null; 
    
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){
        
        contentLinkMap = new Map<String,List<ContentDocumentLink>>();
        
        if(Trigger.isInsert){        
            for(ContentDocumentLink cdLink : (List<ContentDocumentLink>)Trigger.New)
            {
                
                    if(cdLink.LinkedEntityId!=NULL)
                    {
                        Id linkEntityId = cdLink.LinkedEntityId;
                        
                        if(linkEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(ContentDocumentLinkObjectHelper.USERFILE_API_NAME))
                        {
                            if(!contentLinkMap.containsKey(cdLink.ContentDocumentId))
                            {
                                contentLinkMap.put(cdLink.ContentDocumentId,new List<ContentDocumentLink>());                        
                            }
                            contentLinkMap.get(cdLink.ContentDocumentId).add(cdLink);
                            // Process 1
                            cdLink.ShareType = 'V';
                            cdLink.Visibility = 'AllUsers';                   
                        }
                    }
            }  
        }
        
        //Process 4
        if(Trigger.isDelete){
            
            userFileAssociatedLinkMap = new Map<String,List<ContentDocumentLink>>();
            contentDocCDLMap = new Map<String,ContentDocumentLink>(); 
    
            for(ContentDocumentLink cdLink : (List<ContentDocumentLink>)Trigger.old)
            {
                if(cdLink.LinkedEntityId!=NULL)
                {
                    Id userFileId = cdLink.LinkedEntityId;
                    if(userFileId.getSObjectType().getDescribe().getName().equalsIgnoreCase(ContentDocumentLinkObjectHelper.USERFILE_API_NAME))
                    {
                        if(!userFileAssociatedLinkMap.containsKey(userFileId))
                        {
                            userFileAssociatedLinkMap.put(userFileId,new List<ContentDocumentLink>());
                        }
                        userFileAssociatedLinkMap.get(userFileId).add(cdLink);
                        contentDocCDLMap.put(cdLink.ContentDocumentId,cdLink);
                    }
                }
            }
        }          
    }
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){
        //Process 3 
        groupAssociatedLinkMap = new Map<String,List<ContentDocumentLink>>();    
        if(Trigger.isInsert){
            for(ContentDocumentLink cdLink : (List<ContentDocumentLink>) Trigger.New)
            {
                if(cdLink.LinkedEntityId!=NULL)
                {
                    Id linkEntityId = cdLink.LinkedEntityId;
                    if(linkEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(ContentDocumentLinkObjectHelper.USERGROUP_API_NAME))
                    {
                        if(!groupAssociatedLinkMap.containsKey(linkEntityId))
                        {
                            groupAssociatedLinkMap.put(linkEntityId,new List<ContentDocumentLink>());
                        }
                        groupAssociatedLinkMap.get(linkEntityId).add(cdLink);
                        
                    }
                }
            }          
        }
    }
    
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){
        //Process 2
        ContentDocumentLinkObjectHelper.restrictCommunityUserToUploadFileOnUserFile(contentLinkMap);
    
    }
    
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){}
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){ 
        //Process 4
        ContentDocumentLinkObjectHelper.restrictFileUnlinkUserFile(userFileAssociatedLinkMap,contentDocCDLMap );
           
    }
    
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
        //Process 3
        ContentDocumentLinkObjectHelper.LinkContentToUserFile(groupAssociatedLinkMap);
    }
    
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){        
    }
    
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){
    } 
    //Finally do operations to Commit 
    public void finish(){        
               
    }
}
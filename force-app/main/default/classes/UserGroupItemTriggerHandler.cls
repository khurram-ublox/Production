public Class UserGroupItemTriggerHandler implements ITrigger
{
    
    // Process 1 Data : Associate UserFile with userGroupItem for selected user
    Map<String,User_Group_Item__c> userGroupItemMap = null;
    
    // Process 2 Data : share GroupItems file to specific with UserFile if inserted and also delete the link if Usergroup item is deleted
    Map<String,List<ID>> groupUserMap = null;
    Set<String> usersAdded = null;
                       
    
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){
        //Process 1
        if(Trigger.isInsert)
        {
            userGroupItemMap = new Map<String,User_Group_Item__c>();
            for(User_Group_Item__c ugItem : (List<User_Group_Item__c>)Trigger.new)
            {
                userGroupItemMap.put(ugItem.User__c,ugItem);
            }
        }
        
        //Process 2
        if(Trigger.isDelete)
        {
            groupUserMap = new Map<String,List<ID>>();
            usersAdded = new Set<String>();
            for(User_Group_Item__c ugItem : (List<User_Group_Item__c>)Trigger.old)
            {
                if(!groupUserMap.containsKey(ugItem.User_Group__c))
                {
                    groupUserMap.put(ugItem.User_Group__c,new List<ID>());
                }
                groupUserMap.get(ugItem.User_Group__c).add(ugItem.User__c);
                usersAdded.add(ugItem.User__c);
            }  
            UserGroupItemObjectHelper.doUserGroupItemsChangeToUserFile(groupUserMap,usersAdded,Trigger.isInsert);        
            
        }
    }
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){   
        //Process 2
        if(Trigger.isInsert)
        {
            groupUserMap = new Map<String,List<ID>>();
            usersAdded = new Set<String>();
            for(User_Group_Item__c ugItem : (List<User_Group_Item__c>)Trigger.new)
            {
                if(!groupUserMap.containsKey(ugItem.User_Group__c))
                {
                    groupUserMap.put(ugItem.User_Group__c,new List<ID>());
                }
                groupUserMap.get(ugItem.User_Group__c).add(ugItem.User__c);
                usersAdded.add(ugItem.User__c);
            }  
            UserGroupItemObjectHelper.doUserGroupItemsChangeToUserFile(groupUserMap,usersAdded,Trigger.isInsert);        
            
        }
             
    }
    
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){
        //Process 1
        UserGroupItemObjectHelper.mapUserGroupItemToUserFile(userGroupItemMap);   
    }
    
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){}
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){        
    }
    
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
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
/*
* Title: UserTriggerHandler
* Description: Class that updates 
*/
public Class UserTriggerHandler implements ITrigger
{
    //process 1 : 
    set<Id> accountOwnersForAction = new set<Id>();
        
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){
        //Process 1
    }
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){
        //Process 1
        list<User> userListNew = (list<User>)Trigger.new;
        accountOwnersForAction.clear();
        
        for(user tempUser:  userListNew ){
            if(Trigger.isUpdate){
                User oldUser =(User)trigger.oldMap.get(tempUser.Id);
            
                if(tempUser.Distributor_Name__c != oldUser.Distributor_Name__c 
                    || tempUser.Channel_Manager__c != oldUser.Channel_Manager__c 
                    || tempUser.Email_Channel_Manager__c != oldUser.Email_Channel_Manager__c 
                    || tempUser.Email != oldUser.Email){
                      accountOwnersForAction.add(tempUser.Id);
                }
            }
        }
    }
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){
    }
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){
    }
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){
    }
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
        //Process 1 Logic : calling Helper to get 
    }
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){
        UserObjectHelper.accountHelperCall(accountOwnersForAction);
        UserObjectHelper.updateContactOwner((list<User>)Trigger.new);
    }
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){
        //Process 1 Logic : calling Helper to get 
    } 
    //Finally do operations to Commit 
    public void finish(){
        //Process 1 Result Commit
    }
}
trigger updateOpportunityOwner on Opportunity (before insert, before update) {
    
    if(Trigger.isInsert)
    {
            updateOpportunityOwner.execute(Trigger.new);
    }       
    
    for(Opportunity oppObj : Trigger.new){
        if(!String.isEmpty(oppObj.AccountOwnerID__c)){
            oppObj.Account_Owner__c = oppObj.AccountOwnerID__c;            
        }else{
            oppObj.Account_Owner__c = NULL;            
        }
        if(!String.isEmpty(oppObj.Account_Channel_Manager_Id__c)){
            oppObj.Account_Channel_Manager_Obj__c = oppObj.Account_Channel_Manager_Id__c;
        }else{
            oppObj.Account_Channel_Manager_Obj__c = NULL;
        }
    }

}
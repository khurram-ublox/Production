trigger populateOrderProjectOwnerAccount on Billings__c (before insert, before update) {
    
    
    if(Trigger.isInsert)
        populateOrderProjectOwnerAccount.execute(Trigger.new);
    else if(Trigger.IsUpdate){
        
        populateOrderProjectOwnerAccount.execute(Trigger.new, Trigger.oldMap);
    }
}
/*
    rjd: Added the before update
*/

trigger populateOrderAccount on Billings__c (before insert, before update) {
    
    
    if(Trigger.isInsert)
        PopulateOrderAccount.execute(Trigger.new);
    else if(Trigger.IsUpdate)
        PopulateOrderAccount.execute(Trigger.new, Trigger.oldMap);
}
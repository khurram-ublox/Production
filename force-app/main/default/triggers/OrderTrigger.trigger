trigger OrderTrigger on Billings__c (before insert, before update, before delete, after insert, after update, after delete) {
    TriggerFactory.createAndExecuteHandler(OrderTriggerHandler.Class);
    a4x.InputTriggerHelper.measureProcessing(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);

     
}
trigger IPRCostTrigger on IPR_Cost__c (after insert,after update) {
TriggerFactory.createAndExecuteHandler(IPRCostTriggerHandler.class);
}
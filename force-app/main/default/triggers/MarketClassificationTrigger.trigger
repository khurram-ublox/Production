trigger MarketClassificationTrigger on Market_Classification__c (before insert,before update,after insert,after update,before delete,after delete) {
    TriggerFactory.createAndExecuteHandler(MarketClassificationTriggerHandler.Class);
}
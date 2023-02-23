trigger SPRPTrigger on Special_Price_Request_Product__c (before insert,before update) {
    TriggerFactory.createAndExecuteHandler(SPRPTriggerHandler.Class);
}
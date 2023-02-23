trigger oppProductTrigger on Opp_Product__c (after insert, after update, after delete) {   
    TriggerFactory.createAndExecuteHandler(OppProductTriggerHandler.class);    
}
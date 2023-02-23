trigger ProductPricesTrigger on ProductPrices__c (after insert, after update, after delete) {    
    TriggerFactory.createAndExecuteHandler(ProductPricesTriggerHandler.class);    
}
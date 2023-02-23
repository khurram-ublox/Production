trigger productTrigger on Product2 (before insert, before update, before delete, after insert, after update, after delete) {
    TriggerFactory.createAndExecuteHandler(ProductTriggerHandler.Class);
}
trigger QuoteTrigger on Quote ( before insert, after insert, before update, after update) {
    TriggerFactory.createAndExecuteHandler(QuoteTriggerHandler.Class);
}
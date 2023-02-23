trigger OutOfOfficeTrigger on OutOfOffice (after insert, after update) {
    TriggerFactory.createAndExecuteHandler(OutOfOfficeTriggerHandler.Class);
}
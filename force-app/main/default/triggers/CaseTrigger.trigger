Trigger CaseTrigger on Case(before insert,after update){
    TriggerFactory.createAndExecuteHandler(CaseTriggerHandler.class);
}
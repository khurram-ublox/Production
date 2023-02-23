trigger LeadTrigger on Lead (before insert,after insert){
    TriggerFactory.createAndExecuteHandler(LeadTriggerHandler.class);
}
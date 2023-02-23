trigger userTrigger on User (after update) {    
    TriggerFactory.createAndExecuteHandler(UserTriggerHandler.class);
}
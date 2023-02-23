trigger ContentVersionTrigger on ContentVersion (after Insert,after update) {
    TriggerFactory.createAndExecuteHandler(ContentVersionTriggerHandler.Class);    
}
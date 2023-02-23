trigger ContactTrigger on Contact (before insert, after update) {
    
    TriggerFactory.createAndExecuteHandler(ContactTriggerHandler.Class);   
}
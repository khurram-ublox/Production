trigger UserGroupItemTrigger on User_Group_Item__c (before insert,after insert,before delete) {
    TriggerFactory.createAndExecuteHandler(UserGroupItemTriggerHandler.Class);
}
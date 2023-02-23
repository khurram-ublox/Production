trigger EmailSubscriptionTrigger on CAU_Email_Subscription__c (after insert, after update) {
    TriggerFactory.createAndExecuteHandler(EmailSubscriptionTriggerHandler.class);
}
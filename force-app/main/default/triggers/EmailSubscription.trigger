trigger EmailSubscription on CAU_Email_Subscription__c (after insert, after update) {
    
    EmailSubscription.updateContactSubscriptions(Trigger.new);

}
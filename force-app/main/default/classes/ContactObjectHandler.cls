public with sharing  class ContactObjectHandler {
	@AuraEnabled
    public static Id updateSubscriptionField(string contactId){ 
		Contact c = [Select Id, Last_subscription_email_sent__c From Contact Where id=:contactId limit 1];
        c.Last_subscription_email_sent__c = Datetime.now();
        try {
            update c;
        } catch(Exception e) {
            system.debug('DML Exception has occured');
            system.debug(e);
        }
        return c.Id;
    }
}
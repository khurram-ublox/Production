/**
 * Created by ldra on 2018-01-24
 */

@IsTest
private class SubscriptionManagementUnregisteredTest {

    @testSetup static void setup() {
        Account a = new Account(Name='Test Account Name');
        insert a;
        
        Contact c = new Contact(LastName='TestUserr', Email='apex-test@u-blox.com', AccountId=a.Id);
        insert c;
    }
    
    @isTest static void unsubscriptionTest() {

        Contact c =  [Select Id, Email, LastName, Service_Item_3__c, Event_email__c, Webinar_email__c from Contact where LastName='TestUserr' and Email='apex-test@u-blox.com' limit 1];

        test.startTest();
        Contact contact = SubscriptionManagementUnregistered.getContactSubscriptions(c.Email, c.LastName, c.Id);
		test.stopTest();
        
        System.debug(c);
        System.debug(contact);
        
        Boolean result = SubscriptionManagementUnregistered.setContactSubscriptions(c.Email, c.Service_Item_3__c, c.Event_email__c, false, true, true, true, true);
        
        Boolean result2 = SubscriptionManagementUnregistered.setContactSubscriptions(c.Email, c.Service_Item_3__c, c.Event_email__c, true, true, true, true, true);
        
        Boolean cron_webinar = [Select Webinar_email__c FROM Contact where Email =: c.Email].Webinar_email__c;

        // System.assertEquals(false, uu.IsActive);
        System.assertEquals(true, cron_webinar);
    }
}
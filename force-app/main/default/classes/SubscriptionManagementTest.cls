/**
 * Created by wsha on 24/01/2019
 * Updated by ldra on 27/02/2019
 */

@IsTest
private class SubscriptionManagementTest{

    @testSetup
    static void setup(){
        Account a = new Account(Name = 'Test Account Name');
        insert a;

        Contact c = new Contact(LastName = 'LastName', Service_Item_3__c=true, Event_email__c=false, Webinar_email__c=false, Email = 'apex-test@u-blox.com.test', AccountId = a.id);
        insert c;

        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Community Registered User' LIMIT 1].Id;
        User u = new User(Alias = 'standt',
                Email = 'apex-test@u-blox.com.test',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Testing',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = profileId,
                TimeZoneSidKey = 'America/Los_Angeles',
                IsActive = true,
                Username = 'apex-test@u-blox.com.test',
                ContactId = c.Id,
                Deactivation_Request__c = true);
        insert u;

    }


    static testMethod void testGetUserName() {
        String onlineUser = SubscriptionManagement.getUserName();
    }


    static testMethod void testGetUserSubscriptions() {
        User u = [SELECT Id FROM User WHERE Email='apex-test@u-blox.com.test'];
        User uu = new User();
        System.runAs(u){
            uu = [SELECT Id, ContactId, Email, Contact.HasOptedOutOfEmail, Contact.Service_Item_3__c, Contact.Event_email__c, Contact.Webinar_email__c
            FROM User WHERE Id=:UserInfo.getUserId() and ContactId != null and (not Email LIKE '%u-blox.com') ];
        System.assertEquals(uu.Id, SubscriptionManagement.getUserSubscriptions().Id);

        }
    }

    static testMethod void testSetUserSubscriptions(){

        User u = [SELECT Id, Email FROM User WHERE Email='apex-test@u-blox.com.test'];

        Contact c =  [Select Id, Email, LastName, Service_Item_3__c, Event_email__c, Webinar_email__c from Contact where LastName='LastName' AND Email='apex-test@u-blox.com.test' limit 1];
       // Contact v = [SELECT Id, Email FROM Contact WHERE Email=:u.Email];
       // System.debug('v: '+v);

        Map<String, Object>subs = new Map<String, Object>();
        subs.put('Event_email__c', true);
        subs.put('Service_Item_3__c', true);
        subs.put('Webinar_email__c', true);
        
        subs.put('Email_Blog__c', true);
        subs.put('Email_Magazine__c', true);
        subs.put('Email_uCenter__c', true);
        subs.put('Email_Attendance__c', true);

        System.debug('subs: ' + subs);

        Boolean isUpdated = false;

        System.runAs(u) {

            System.assertNotEquals(null, subs);

            Test.startTest();
            isUpdated = SubscriptionManagement.setUserSubscriptions(subs);
            Test.stopTest();

            System.assertEquals(false, isUpdated);
        }

    }
}
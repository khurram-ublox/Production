/**
 * Created by wsha on 25/01/2019.
 */




@IsTest
private class ReactivateUserTest {

    @testSetup
    static void setup(){

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'reti', Email = 'reactivateuser@test.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles', IsActive = false,
                Username = 'reactivateuser@test.com', Deactivation_Request__c=true);
        insert u;
    }


    static testMethod void testgetDeactivatedUser() {

        User du = [SELECT Id, isActive, Email FROM User WHERE Email='reactivateuser@test.com' LIMIT 1];
        System.assertEquals(du, ReactivateUser.getDeactivatedUser(du.Email));

        Boolean ru = ReactivateUser.reactivateUser(du.Email);
        System.assertEquals(true, ru);
        
    }
}
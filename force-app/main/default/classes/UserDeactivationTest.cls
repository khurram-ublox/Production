/**
 * Created by ldra on 2018-01-23
 */

@IsTest
private class UserDeactivationTest {

    @testSetup static void setup() {
        Account a = new Account(Name='Test Account Name');
        insert a;
        
        Contact c = new Contact(LastName='Test User', AccountId=a.Id);
        insert c;       
    }
    
    @isTest static void deactivationTest() {

        User cUser = UserDeactivation.getUser();
        System.debug(cUser);
        
        Id contactId =  [Select Id from Contact where Name = 'Test User' limit 1].Id;
        Id profileId =  [Select Id from Profile where Name = 'Community Registered User' limit 1].Id;
        
        //Create user
        User u = new User(LastName='TestUser',
                          Alias='testAlia',
                          Email='test@u-blox.com.dev',
                          Username='test@u-blox.com.dev',
                          CommunityNickname='some.one',
                          ContactId=contactId,
                          ProfileId=profileId,
                          TimeZoneSidKey='America/New_York',
                          LocaleSidKey='en_Us',
                          EmailEncodingKey='ISO-8859-1',
                          LanguageLocaleKey='en_US');
        insert u;
        
        // deactivate user
        String reason = 'test_reason';
        System.debug(u.Id);
                
        Map<String,String> resultss = UserDeactivation.deactivateUser(reason, u);
        System.debug(resultss);
        
        User uu = [Select Id, IsActive, Reason_for_leaving__c from User where Id =: u.Id ];
        //User uu =  [Select Id, IsActive, Reason_for_leaving__c from User where Id =: u.Id ];
        //u.IsActive = false;
        //u.Reason_for_leaving__c = reason;
        //update u;

        UserLogin ul = [select Id, IsFrozen from UserLogin where UserId =: u.Id];
        //ul.IsFrozen = true;
        //update ul;

        System.assertEquals(false, uu.IsActive);
        System.assertEquals(true, ul.IsFrozen);

    }

}
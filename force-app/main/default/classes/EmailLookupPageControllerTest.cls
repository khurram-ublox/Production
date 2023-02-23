/*
    Name         : EmailLookupPageControllerTest
    Author       : PARX
    Date         : 12th Oct 2017
    Description  : This class is used for cover EmailLookupPageController class.
*/
@isTest 
public class EmailLookupPageControllerTest{
    
    public static testMethod void testRunAs() {
       
        // Setup test data
        // This code runs as the system user
       
        Profile pro = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='harivaishnav01@gmail.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = pro.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testingUser@hari.com');

        System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        }
        EmailLookupPageController emailLookup = new EmailLookupPageController();
    }
}
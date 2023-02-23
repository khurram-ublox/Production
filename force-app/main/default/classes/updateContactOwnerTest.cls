/*
    Name         : updateContactOwnerTest
    Author       : ldra
    Date         : 2019-02-04
    Description  : This class covers updateContactOwner class.
*/
@isTest
public class updateContactOwnerTest{
    
    @testSetup static void setup() {

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1]; 
        
        // Create new User
        User u = new User(Alias = 'standt', Email='apex-test@u-blox.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='apex-test@u-blox.com',
                         uB_Office__c='EMEA', Channel_Manager__c='Apex Test', Email_Channel_Manager__c='apex-test2@u-blox.com', Distributor_Name__c='Internal'
                         );
        insert u;
        
        // Create new Account
        Account a = new Account(name= 'Test updateContactOwnerTest', ShippingCity = 'Zurich', ShippingPostalCode = '8000', ShippingStreet = 'Hauptstrasse 1', OwnerId = u.Id);
        insert a;
    }
    
    @isTest static void testExecute() {
        Account a = [SELECT Id, OwnerId FROM Account WHERE Name = 'Test updateContactOwnerTest'];
        System.debug('account: '+a);
        
        // Create a new Contact
        Contact c = new Contact(LastName = 'Last', FirstName = 'First', Email = 'apex-test@u-blox.com', AccountId = a.Id);
        insert c;   

        Contact cs = [SELECT OwnerId FROM Contact WHERE Id =: c.Id];
        System.debug('contact: '+cs);
        
        System.assertEquals(a.OwnerId, cs.OwnerId);                                                
    } 
}
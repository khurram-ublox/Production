@isTest
public with sharing class AccountVisitingAddressTest {
    public AccountVisitingAddressTest() {

    }

    public static TestMethod void testUpdateContactVisitingAddress()
    {
        Account testAcc = new Account(Name = 'Test Account 01', Visiting_Address_changed__c = false);
        insert testAcc;
        
        List<Contact> testContacts = new List<Contact>();
        // Set up some test contacts
        for (Integer x = 0; x < 5; x++)
        {
            Contact c = new Contact(LastName = 'Test Contact ' + x);
            
            // Set up default mailing address for the test
            c.MailingStreet = 'Contact Street';
            c.MailingCountry = 'CA';
            c.MailingPostalCode = 'Contact Postal Code';
            c.MailingCity = 'Contact City';
            c.MailingState = 'AB';
            
            
            // Make sure the visiting address flag is false for the test
            c.Visiting_Address_changed__c = false;
            c.AccountId = testAcc.Id;
            testContacts.add(c);
        }
        insert testContacts;
        
        // Update account with new address info
        testAcc.BillingStreet = 'Account Street';
        testAcc.BillingCountry = 'CA';
        testAcc.BillingPostalCode = 'Account Postal Code';
        testAcc.BillingCity = 'Account City';
        testAcc.BillingState = 'BC';
        testAcc.Visiting_Address_changed__c = true;
        update testAcc;
        
        // Get updated account
        testAcc = [Select Id, Name, Visiting_Address_changed__c, BillingStreet, BillingCountry, BillingPostalCode, BillingCity, BillingState From Account Where Id = :testAcc.Id];
        System.assert(testAcc.Visiting_Address_changed__c == false);
        
        // Loop through all updated contacts
        Integer numContacts = 0;
        /*
        for (Contact c : [Select Id, Name, Visiting_Address_changed__c, MailingStreet, MailingCountry, MailingPostalCode, MailingCity, MailingState From Contact Where AccountId = :testAcc.Id])
        {
            // If the workflow isn't in effect, check the visiting address changed field
            if (testAcc.BillingStreet != c.MailingStreet) System.assertEquals(false, c.Visiting_Address_changed__c);
            else
            {
                // Check the account address equals contact address
                System.assertEquals(testAcc.BillingStreet, c.MailingStreet);
                System.assertEquals(testAcc.BillingCountry, c.MailingCountry);
                System.assertEquals(testAcc.BillingPostalCode, c.MailingPostalCode);
                System.assertEquals(testAcc.BillingCity, c.MailingCity);
                System.assertEquals(testAcc.BillingState, c.MailingState);
            }
            numContacts++;
        }
        // Check that we get the same number of contacts as we initially had
        System.assert(numContacts == 5);*/
    }
}
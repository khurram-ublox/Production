@isTest
public with sharing class CustomLookupLwcControllerTest {
    @isTest static void testSearch() {
        // Create some accounts
        Account abc = new Account(Name = 'ABC Account');
        Account xyz = new Account(Name = 'XYZ Account');

        List<Account> accounts = new List<Account> { abc, xyz };

        insert accounts;

        Id[] fixedSearchResults = new Id[] { xyz.Id };
        Test.setFixedSearchResults(fixedSearchResults);
        List<sObject> results = CustomLookupLwcController.fetchLookupData('xy', 'Account', '');
        sObject result2 = CustomLookupLwcController.fetchDefaultRecord('xy', 'Account');

        System.assertEquals(1, results.size());

    
   }   
}
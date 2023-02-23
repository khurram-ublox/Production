/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@IsTest
private class SpamEmailCtrlTest {
    
    static testMethod void TestMacrowithFAEUser() {
        Account customerAccount = new Account (
            Name = 'Registered Community Users',                
            uB_Office__c = 'EMEA'
        );
        insert customerAccount;
        system.debug('customerAccount--->>'+customerAccount);
        Contact customerContact = new Contact(
            FirstName = 'Justin',
            LastName = 'Fleming',
            Email = 'justin.fleming@mailinator.com',
            AccountId = customerAccount.Id
        );
        database.insert(customerContact, false);
        
        Case customerEmailCase = new Case(
            Accountid = customerAccount.Id,
            contactId = customerContact.Id,
            Type = 'Technical Question',
            Origin = 'E-Mail (EMEA)',
            Status = 'New',
            suppliedEmail ='test@example.com',
            Technology__c = 'Cellular',
            RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByName().get('Email Case').getRecordTypeId()
        );
        Test.startTest();
        insert customerEmailCase;
        SpamEmailCtrl.spamCaseId(customerEmailCase.Id);
        Test.stopTest();
    }
}
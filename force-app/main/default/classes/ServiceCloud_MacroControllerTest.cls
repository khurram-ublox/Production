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
private class ServiceCloud_MacroControllerTest {
    
    static testMethod void TestMacrowithFAEUser() {
        Id profileIdFAE =  [Select Id from Profile where Name = 'Service FAE' limit 1].Id;
        User internalFAE = new User(
            Alias = 'standt', 
            Email='apex-test@u-blox.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Mukul Bandodkar', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = profileIdFAE, 
            Channel_Manager__c = 'Test Manager',
            Email_Channel_Manager__c = 'apex-test-manager@u-blox.com',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='apex-test@u-blox.com',
            uB_Office__c = 'EMEA'
        );
        insert internalFAE;

        System.RunAs(internalFAE){
            Account customerAccount = new Account (
                Name = 'Adelco Account',                
                FAE__c = internalFAE.Id,
                uB_Office__c = 'EMEA'
            );
            database.insert(customerAccount, false);

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
                OwnerId = internalFAE.Id,
                Type = 'Technical Question',
                Origin = 'E-Mail (EMEA)',
                Status = 'New',
                Technology__c = 'Cellular',
                RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByName().get('Email Case').getRecordTypeId()
            );
            database.insert(customerEmailCase, false);
        
            ServiceCloud_MacroController.getMacroDropDownValues();
            ServiceCloud_MacroController.getMacroFromAddress(customerEmailCase.Id);
            ServiceCloud_MacroController.getToEmailAddress(customerEmailCase.Id);
            ServiceCloud_MacroController.runMacro(customerEmailCase.Id, 'Case_Send_Email_for_more_info','justin.fleming@mailinator.com',null,null,'support@u-blox.com');
       }
    }
}
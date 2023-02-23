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
@isTest
private class OutOfOfficeTriggerHandlerTest {
    static User internalFAE;
    static OutOfOffice OoOffice;

    static {
        Id profileIdFAE =  [Select Id from Profile where Name = 'Service FAE' limit 1].Id;
        internalFAE = new User(
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

        OoOffice = new OutOfOffice(
            UserId = internalFAE.Id,
            IsEnabled = true,
            StartDate = System.Today(),
            EndDate = System.Today().addDays(1),
            Message = 'I am out of office'
        );
        insert OoOffice;
    }
    
    static testMethod void TestOutOfOfficeTriggerUpdate() {
        // TO DO: implement unit test
        OoOffice.EndDate = System.Today();        
        update OoOffice;             
    }
    
    static testMethod void codeCoverageForReadonlyMethods() {
        // TO DO: implement unit test
        OutOfOfficeTriggerHandler handler = new OutOfOfficeTriggerHandler();        
        handler.beforeInsert();
        handler.prepareBefore();
        handler.beforeUpdate();
        handler.beforeDelete();
        handler.afterDelete();
    }
}
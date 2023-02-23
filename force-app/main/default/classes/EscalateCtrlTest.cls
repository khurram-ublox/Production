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
private class EscalateCtrlTest {
            
    @testSetup static void setup() {
        
        Account a = new Account(Name='Test Account Name');
        insert a;
        
        // Create a new internal FAE User 
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
        // Create a new Partner FAE User         
    }

    static testMethod void TestEscalationEMEAPartners() {
        Id profileIdPartners =  [Select Id from Profile where Name = 'Partner Base' limit 1].Id;
        User partnerFAE = new User(
            Alias = 'adloprt', 
            Email='apex-test@u-blox.com.partner', 
            EmailEncodingKey='UTF-8',            
            LastName='Adelco', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = profileIdPartners, 
            Channel_Manager__c = 'Test Manager',
            Email_Channel_Manager__c = 'apex-test-manager@u-blox.com.partner',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='apex-test@u-blox.com.partner',
            uB_Office__c = 'EMEA'
        );
        insert partnerFAE;

        System.RunAs(partnerFAE){
            Account PartnerAccount = new Account (
                Name = 'Adelco Partner Account',
                Distributor__c = 'Adelco',
                FAE__c = partnerFAE.Id,
                uB_Office__c = 'EMEA'
            );
            database.insert(PartnerAccount, false);
            
            Case PartnerCase = new Case(
                Accountid = PartnerAccount.Id,
                OwnerId = partnerFAE.Id,
                Type = 'Technical Question',
                Origin = 'Web',
                Status = 'New',
                Technology__c = 'Cellular',
                RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByName().get('Support Case').getRecordTypeId()
            );
            database.insert(PartnerCase, false);
        
            ApexPages.StandardController stdController= new ApexPages.StandardController(PartnerCase);   
            EscalateCtrl con= new EscalateCtrl(stdController);
            Boolean res = EscalateCtrl.escalateCaseId(PartnerCase.id);
            System.assertEquals(true, res); 
       }
    }

    static testMethod void TestEscalationEMEAChannelFAE() {
        User internalFAE = [Select Id from User where Email = 'apex-test@u-blox.com' and LastName = 'Mukul Bandodkar' limit 1];
        System.RunAs(internalFAE){
            Account channelAccount = new Account (
                Name = 'Account with Channel FAE',
                Distributor__c = 'channel',
                FAE__c = internalFAE.Id,
                uB_Office__c = 'EMEA'
            );
            database.insert(channelAccount, false);
            
            Case channelCase = new Case(
                Accountid = channelAccount.Id,
                OwnerId = internalFAE.Id,
                Type = 'Technical Question',
                Origin = 'Web',
                Status = 'New',
                Technology__c = 'Cellular',
                RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByName().get('Support Case').getRecordTypeId()
            );
            database.insert(channelCase, false);
        
            ApexPages.StandardController stdController= new ApexPages.StandardController(channelCase);   
            EscalateCtrl con= new EscalateCtrl(stdController);
            Boolean res = EscalateCtrl.escalateCaseId(channelCase.id);
            System.assertEquals(true, res); 
        }
    }

    static testMethod void TestEscalationEMEADirectFAE() {
        Id profileIdFAE =  [Select Id from Profile where Name = 'Service FAE' limit 1].Id;
        User directFAE = new User(
            Alias = 'drcmrtnd', 
            Email='apex-test@u-blox.com.direct', 
            EmailEncodingKey='UTF-8', 
            LastName='Dirk Martin', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = profileIdFAE, 
            Channel_Manager__c = 'Test Manager',
            Email_Channel_Manager__c = 'apex-test-manager@u-blox.com.direct',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='apex-test@u-blox.com.direct',
            uB_Office__c = 'EMEA'
        );
        insert directFAE;
        System.RunAs(directFAE){
            Account directAccount = new Account (
                Name = 'Account with Direct FAE',
                Distributor__c = 'Direct',
                FAE__c = directFAE.Id,
                uB_Office__c = 'EMEA'
            );
            database.insert(directFAE, false);
            
            Case directCase = new Case(
                Accountid = directAccount.Id,
                OwnerId = directFAE.Id,
                Type = 'Technical Question',
                Origin = 'Web',
                Status = 'New',
                Technology__c = 'Cellular',
                RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByName().get('Support Case').getRecordTypeId()
            );
            database.insert(directCase, false);
        
            ApexPages.StandardController stdController= new ApexPages.StandardController(directCase);   
            EscalateCtrl con= new EscalateCtrl(stdController);
            Boolean res = EscalateCtrl.escalateCaseId(directCase.id);
            System.assertEquals(true, res); 
        }
    }
    
    @isTest static void test(){
        User u = [Select Id from User where Email = 'apex-test@u-blox.com' and LastName = 'Mukul Bandodkar' limit 1];
        Account a = [Select Id from Account where Name='Test Account Name'];

        Case caseObj= new Case(
            Accountid = a.Id,
            OwnerId = u.Id,
            Type = 'Questionaire / Self-Assessments',
            Origin = 'Web',
            Status = 'New',            
            RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByName().get('Support Case').getRecordTypeId()
        );
        insert caseObj;
        
        ApexPages.StandardController stdController= new ApexPages.StandardController(caseObj);   
        EscalateCtrl con= new EscalateCtrl(stdController);
        Test.startTest();
        
        Boolean res = EscalateCtrl.escalateCaseId(caseObj.id);
        System.assertEquals(true, res); 

        Test.stopTest();

    }
}
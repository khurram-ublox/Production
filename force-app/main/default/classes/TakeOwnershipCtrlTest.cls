@IsTest
private class TakeOwnershipCtrlTest {     

	@testSetup static void setup() {
        Account a = new Account(Name='Test Account Name');
        insert a;
        
        // Create a new User 
        Id profileId =  [Select Id from Profile where Name = 'Service FAE' limit 1].Id;
        User u = new User(
            Alias = 'standt', 
            Email='apex-test@u-blox.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = profileId, 
            Channel_Manager__c = 'Test Manager',
            Email_Channel_Manager__c = 'apex-test-manager@u-blox.com',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='apex-test@u-blox.com'
        );
        insert u;
    }
    
    @isTest static void test(){
        
        User u = [Select Id from User where Email = 'apex-test@u-blox.com' and LastName = 'Testing'];
        Account a = [Select Id from Account where Name='Test Account Name'];
        
        Case caseObj= new Case(
            Accountid = a.Id,
            OwnerId = u.Id,
            Type = '',
            Origin = 'Web',
            Status = 'New',
            RecordTypeId = '012D0000000BarOIAS'
        );
        insert caseObj;
        
        ApexPages.StandardController stdController= new ApexPages.StandardController(caseObj);   
        TakeOwnershipCtrl con= new TakeOwnershipCtrl(stdController); 
        
        Boolean res = TakeOwnershipCtrl.updatedCaseId(caseObj.id);
        System.assertEquals(true, res);
        
    }
}
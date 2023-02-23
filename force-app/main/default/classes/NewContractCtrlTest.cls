@IsTest
private class NewContractCtrlTest {     

	@testSetup static void setup() {
        Account a = new Account(Name='Test Account Name 64 characters 100 percent');
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
    
    @isTest static void test()
    {
        User u = [Select Id from User where Email = 'apex-test@u-blox.com' and LastName = 'Testing'];
        Account a = [Select Id from Account where Name='Test Account Name 64 characters 100 percent'];
        
        Case caseObj= new Case(
            Accountid = a.Id,
            Type = '',
            Origin = 'Web',
            Status = 'New',
            RecordTypeId = '012D0000000BarOIAS'
        );
        insert caseObj;
        
        ApexPages.StandardController stdController= new ApexPages.StandardController(caseObj);   
        NewContractCtrl con= new NewContractCtrl(stdController);             
        
        Boolean res = NewContractCtrl.execute(caseObj.id);
        
        caseObj.type = 'Legal (e-NDA)';
        update caseObj;
        res = NewContractCtrl.execute(caseObj.id);

        caseObj.type = 'Legal (e-NDA Americas)';
        update caseObj;
        res = NewContractCtrl.execute(caseObj.id);
        
        caseObj.type = 'Legal (e-LULA-M)';
        update caseObj;
        res = NewContractCtrl.execute(caseObj.id);
        
        caseObj.type = 'Legal (e-LULA-N)';
        update caseObj;
        res = NewContractCtrl.execute(caseObj.id); 

        System.assertEquals(true, res);
        
    }
}
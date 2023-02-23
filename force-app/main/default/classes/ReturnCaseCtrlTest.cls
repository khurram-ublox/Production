@IsTest(SeeAllData=true)
public class ReturnCaseCtrlTest {
    
    static {
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
            Type = '',
            Origin = 'Web',
            Status = 'New',
            RecordTypeId = '012D0000000BarOIAS'
        );
        insert caseObj;
        
        CaseHistory historyObj = [Select CaseId from CaseHistory order by CreatedDate DESC limit 1];
        
        ApexPages.StandardController stdController= new ApexPages.StandardController(caseObj);   
        ReturnCaseCtrl con= new ReturnCaseCtrl(stdController); 
        
        Boolean res = ReturnCaseCtrl.updatedCaseId(historyObj.CaseId);
        System.assertEquals(true, res);
        
    }
}
@IsTest
private class NewPartnerRoleCtrlTest {    
    public static TestMethod void test(){
        
        // 2017.11.27 khir: Added Account creation to solve the error for Flow "EMEA_Sales_Stage_8" (made by Process Builder)
        Account acc = new Account(Name='Test Acc',uB_Office__c='Corporate');
        insert acc;
        
        Opportunity oppObj = new Opportunity();
        oppObj.Name='test'; 
        oppObj.StageName='3 Calling on'; 
        oppObj.CloseDate=System.today();
        oppObj.AccountId=acc.Id; // 2017.11.27 khir
        insert oppObj;      
        
        Opportunity o = NewPartnerRoleCtrl.getRecord(oppObj.Id);
        system.assertNotEquals(null, o);
        
        Partner_Role__c pr1 = new Partner_Role__c();
        pr1.Partner_Role__c = '3 Design house';
        pr1.Opportunity__c = oppObj.Id;
        pr1.CurrencyIsoCode = oppObj.CurrencyIsoCode;
        insert pr1;
        
        Variable__c var =new Variable__c();
        var.Name =UserInfo.getUserId();
        var.LastOppID__c= oppObj.Id;
        var.LastPartnerRoleID__c=pr1.Id; 
        insert var;  
        
        Partner_Role__c pr = new Partner_Role__c();
        pr.Partner_Role__c = '3 Design house';
        pr.Partner_Account__c = acc.Id;
        pr.Opportunity__c = oppObj.Id;
        pr.Opportunity_Account__c = acc.Id;
        pr.CurrencyIsoCode = oppObj.CurrencyIsoCode;
        
        Id prid = NewPartnerRoleCtrl.save(pr);
        system.assertNotEquals(null, prid);
    }
    
    //Test 2
    @isTest
    public static void testingCustomController(){
        
        Account acc = new Account(Name='Test Acc',uB_Office__c='Corporate');
        insert acc;
        
        Opportunity oppObj = new Opportunity();
        oppObj.Name='test'; 
        oppObj.StageName='3 Calling on'; 
        oppObj.CloseDate=System.today();
        oppObj.AccountId=acc.Id;
        insert oppObj;      
        
        Opportunity o = NewPartnerRoleCtrl.getRecord(oppObj.Id);
        system.assertNotEquals(null, o);
        Test.StartTest();
        PageReference pageRef = Page.NewPartnerRolePage; 
        pageRef.getParameters().put('id',oppObj.Id );
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(oppObj);
        NewPartnerRoleCtrl NewPartnerRoleCtrlObj = new NewPartnerRoleCtrl(sc);
        NewPartnerRoleCtrlObj.doSave();
        NewPartnerRoleCtrlObj.doCancel();
        Test.StopTest();
    }
    
}
@IsTest
private class ClearNewFlagVFCtrlTest { 
    
    @testSetup static void setup() {
        Account a = new Account(Name='Test Account Name');
        insert a;
    }
    
    
    public static TestMethod void test(){
        
        Account a = [Select Id from Account where Name='Test Account Name'];
        
        Case caseObj= new Case(
            Accountid = a.Id,
            Type = '',
            Origin = 'Web',
            Status = 'New',
            RecordTypeId = '012D0000000BarOIAS'
        );
        insert caseObj;
        ApexPages.StandardController stdController= new ApexPages.StandardController(caseObj);   
        ClearNewFlagVFCtrl con= new ClearNewFlagVFCtrl(stdController);    
        
    }
}
@IsTest
private class NewOpportunityCtrlTest{
    public static TestMethod void test(){      
        Account accObj=new Account();
        accObj.Name='Sumit';    
        insert accObj; 
        String accId=accObj.id;
        Account a = NewOpportunityCtrl.getAccount(accId);
        system.assertNotEquals(null, a);
        
        Opportunity o = new Opportunity();
        o.OwnerId = a.OwnerId;
        o.CurrencyIsoCode = a.CurrencyIsoCode;
        o.StageName = '3 Calling On';
        o.CloseDate = a.OppCloseDate__c;
        o.Opportunity_Account__c = a.Id;
        o.Name='Quotation'; 
        Id oId = NewOpportunityCtrl.save(o);
        system.assertNotEquals(null, oId);
    }
}
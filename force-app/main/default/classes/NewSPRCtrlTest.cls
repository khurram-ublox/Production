@IsTest
private class NewSPRCtrlTest {

    public class wrapperClass{
       public String AccountId {get; set;}
       public String OpportunityId {get; set;}
    }

    public static TestMethod void test(){
        
        String NewApplicationType='Unmanned aerial vehicles (UAV)';
            
        Account acc = new Account(Name='Test Acc 3',uB_Office__c='APAC',New_Application_Type__c=NewApplicationType);
        insert acc;

        Map<String, String> m = NewSPRCtrl.getIds(acc.Id);
        String aId = m.get('AccountId');
        system.debug('0');
        
        Opportunity o = new Opportunity();
        o.OwnerId = [Select Id, Username from User where Username like 'salesforce@u-blox.com%'].Id;
        o.StageName = '5 Design-in';
        o.CloseDate = date.newInstance(2012,05,22);
        o.Opportunity_Account__c = aId;
        o.New_Application_Type__c=NewApplicationType;
        o.AccountId = aId;
        o.Value_Proposition__c = 'test value proposition';
        o.Gain_Creators__c = 'test';
        o.Pain_Relievers__c='text area';
        o.Customer_Type__c='test';
        o.Gains__c = 'ere';
        o.Pains__c='pains';
        o.Customer_Jobs__c = 'customer jobs';
        o.Name='Opportunity'; 
        insert o;
        system.debug(o.Id);
        
        Product2 p = new Product2();
        p.Name = 'Product';
        p.Type_No__c = 'Product-01';
        insert p;
        
        Opp_Product__c op = new Opp_Product__c();
        op.Product__c = p.Id;
        op.Annual_Quantity__c = 200;
        op.Unit_Price__c = 1.2;
        //op.Use_Restriction__c = ;
        //op.IPR_Coverage__c = ;
        op.Opportunity__c = o.Id;
        insert op;
        system.debug('11');

        
  	    Special_Price_Request__c spr = new Special_Price_Request__c(
            Account__c = aId,
            Opportunity__c = o.Id,
            CurrencyIsoCode = o.CurrencyIsoCode,
            Price_Level__c = 'PPP (Project Price Plan)',
            Comment_by_Requestor__c = 'test'
        );
            
        String oId2 = NewSPRCtrl.save(spr);
        //system.assertNotEquals(null, oId2);
        


    }
}
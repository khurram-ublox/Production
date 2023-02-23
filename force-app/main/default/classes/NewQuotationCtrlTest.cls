@IsTest
private class NewQuotationCtrlTest{
    public static TestMethod void test(){
        // 2017.11.27 khir: Added Account creation to solve the error for Flow "EMEA_Sales_Stage_8" (made by Process Builder)
        Account acc = new Account(Name='Test Acc 3',uB_Office__c='APAC');
        insert acc;

        Account a = NewQuotationCtrl.getAccount(acc.Id);
        system.debug('0');
        
        Opportunity o = new Opportunity();
        o.OwnerId = [Select Id, Username from User where Username like 'salesforce@u-blox.com%'].Id;
        o.StageName = '3 Calling On';
        o.CloseDate = a.OppCloseDate__c;
        o.Opportunity_Account__c = a.Id;
        o.AccountId = a.Id;
        o.Name='Opportunity'; 
        insert o;
        system.debug('1');
        
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
        
        // PricebookEntry pbe = new PricebookEntry();
        // pbe.UnitPrice = 10;
        // pbe.Product2Id = p.Id;
        // pbe.Pricebook2Id = ?;
        // pbe.CurrencyIsoCode = o.CurrencyIsoCode;
        // insert pbe;
        
        Contact c=new Contact();
        c.LastName='sumit singh';
        insert c;
        system.debug('2');
        
        AccountContactRole acr= new AccountContactRole();
        acr.AccountId=a.Id;
        acr.ContactId=c.id;
        acr.IsPrimary = true;
        acr.Role = 'Contact Commercial';
        insert acr;       
     	system.debug('3');
        
        OpportunityContactRole ocr= new OpportunityContactRole();
        ocr.OpportunityId=o.id;
        ocr.ContactId=c.id;
        ocr.Role = 'Contact Quotation';
        insert ocr;       
     	system.debug('33');
        
        Opportunity q = new Opportunity();
        q.OwnerId = o.OwnerId;
        q.CurrencyIsoCode = o.CurrencyIsoCode;
        q.StageName = '3 Calling On';
        q.Quotation_Account__c = a.Id;
        q.Name='Quotation 1'; 
        q.RecordTypeId = '01220000000CqRdAAK';
        q.CloseDate = a.OppCloseDate__c;
        q.Referred_Opportunity__c = o.Id;
        q.Referred_Opportunity_Account__c = o.AccountId;
		system.debug('4');
        
        Id oId1 = NewQuotationCtrl.save(q,'Opportunity');
        system.assertNotEquals(null, oId1);
        
        a = NewQuotationCtrl.getAccount(o.Id);
        
        q = new Opportunity();
        q.OwnerId = o.OwnerId;
        q.CurrencyIsoCode = o.CurrencyIsoCode;
        q.StageName = '3 Calling On';
        q.Quotation_Account__c = a.Id;
        q.Name='Quotation 2'; 
        q.RecordTypeId = '01220000000CqRdAAK';
        q.CloseDate = a.OppCloseDate__c;
		system.debug('4');
        
        Id oId2 = NewQuotationCtrl.save(q,'Account');
        //system.assertNotEquals(null, oId2);
        


    }
}
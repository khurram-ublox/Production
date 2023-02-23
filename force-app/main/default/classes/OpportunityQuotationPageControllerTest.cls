@isTest(seealldata=false)
public class OpportunityQuotationPageControllerTest {
    public static testmethod void oppQuotationTest (){
        Account acc = new Account(Name='Test Acc',uB_Office__c='Corporate');
        insert acc;
        Opportunity opp = new Opportunity(Name='TestOpp', StageName='3 Calling on',CloseDate=Date.today(),Description='test description',AccountId=acc.Id);
        insert opp;
        
        Contact c = new Contact();
        c.FirstName = 'Paul';
        c.LastName  = 'Test';
        c.AccountId = acc.id;
        insert c;
        
        AccountContactRole acr = new AccountContactRole();
        acr.ContactId = c.Id;
        acr.AccountId = acc.Id;
        acr.IsPrimary = TRUE;
        acr.Role = 'Contact Commercial';
        insert acr;
        
        Product2 prodForRanked3 = new Product2(Name='testProd2222',BusinessUnit__c = 'Tashang', Type_No__c='testTypeNum3332', Product_Center__C='Positioning');  // khir: Added Product Canter
        insert prodForRanked3;
        
        
        Opp_Product__c oppProductRanked1 = new Opp_Product__c(); 
        oppProductRanked1.Opportunity__c = opp.id;
        oppProductRanked1.Product__c = prodForRanked3.Id; 
        insert oppProductRanked1;
        
        
        //Test.setCurrentPageReference(new PageReference('Page.Inline_Opportunity_Product')); 
        //System.currentPageReference().getParameters().put('id', oppProductRanked1.Id);
        test.startTest();
        system.assertEquals(1, [select count() from Opp_Product__c ]) ;
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        OpportunityQuotationPageController opc = new OpportunityQuotationPageController(sc);
        //NewQuotationCtrl nQC = new NewQuotationCtrl();
        NewQuotationCtrl.checkBusinessUnit(opp.Id);
        opc.doCancel();
        opc.doSave();
        test.stopTest();
    }
    
    public static testmethod void oppQuotationTest1 (){
        Account acc = new Account(Name='Test Acc',uB_Office__c='Corporate');
        insert acc;
        Opportunity opp = new Opportunity(Name='TestOpp', StageName='3 Calling on',CloseDate=Date.today(),Description='test description',AccountId=acc.Id);
        insert opp;
        
        Contact c = new Contact();
        c.FirstName = 'Paul';
        c.LastName  = 'Test';
        c.AccountId = acc.id;
        
        insert c;
        
        
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = c.Id;
        ocr.OpportunityId = opp.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Contact Quotation';
        insert ocr;
        
        
        
        Product2 prodForRanked3 = new Product2(Name='testProd2222',BusinessUnit__c = 'u-blox', Type_No__c='testTypeNum3332', Product_Center__C='Positioning');  // khir: Added Product Canter
        insert prodForRanked3;
        
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
        
        
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = prodForRanked3.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;
        
        //Query the PricebookEntry record
        pbe = [SELECT Id, Pricebook2.IsStandard FROM PricebookEntry];
        //It should return true
        System.assertEquals(true, pbe.Pricebook2.IsStandard);
        
        Opp_Product__c oppProductRanked1 = new Opp_Product__c(); 
        oppProductRanked1.Opportunity__c = opp.id;
        oppProductRanked1.Product__c = prodForRanked3.Id;
        oppProductRanked1.Annual_Quantity__c = 1;
        oppProductRanked1.Unit_Price__c = 10;
        insert oppProductRanked1;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        OpportunityQuotationPageController opc = new OpportunityQuotationPageController(sc);
        opc.doSave();
    }
}
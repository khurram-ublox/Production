@isTest
public class QuoteTriggerHandlerTest {
    @testSetup
    static void setup(){
        
        AccountTestDataFactory AccountTestDataFactoryobj = new AccountTestDataFactory();
        Account quoteAccount= (Account)AccountTestDataFactoryobj.initializeRecord();
        quoteAccount.Name = 'KAE Electronics';
        quoteAccount.uB_Office__c = 'EMEA';
        insert quoteAccount;
        
        Product2TestDataFactory productTestFactoryObj = new Product2TestDataFactory();
        Product2 cellularProduct = (Product2)productTestFactoryObj.initializeRecord();
        cellularProduct.Name = 'TOBY-L201 quote';
        cellularProduct.Type_No__C='TOBY-L201-02S-01-q';
        cellularProduct.Product_Center__C='Cellular';
        cellularProduct.BusinessUnit__c = 'u-blox';
        insert cellularProduct;
        
        OpportunityTestDataFactory OpportunityTestDataFactoryObj = new OpportunityTestDataFactory();
        Opportunity oppObj= (Opportunity)OpportunityTestDataFactoryObj.initializeRecord();
        oppObj.accountId = quoteAccount.Id;
        oppObj.Name='KAE Electronics';
        oppObj.StageName='3 Calling on';
        oppObj.CloseDate = Date.today().addDays(7);      
        oppObj.End_Customer_Account__c = quoteAccount.Id;
        oppObj.Quotation_Account__c = quoteAccount.Id;
        oppObj.AccountId = quoteAccount.Id;
        oppObj.Type_of_quotation__c = 'Quotation';
        oppObj.RecordTypeId = Schema.sObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity').getRecordTypeId();
        insert oppObj;
        
        Opp_Product__c oppProductObj = new Opp_Product__c();
        oppProductObj.Opportunity__c = oppObj.Id;
        oppProductObj.Product__c = cellularProduct.Id;
        oppProductObj.Unit_Price__c = 12;
        oppProductObj.Annual_Quantity__c = 12;
        oppProductObj.Status__c = 'Evaluation';
        insert oppProductObj;
        
        pricebook2 priceBookObj = new pricebook2();
        priceBookObj.Name = 'Standard Price Book';
        priceBookObj.CurrencyIsoCode = 'USD';
        insert priceBookObj;
        
        List<pricebookEntry> pricebookEntryList = new List<pricebookEntry>();
        pricebookEntry PBEObj2 = new pricebookEntry();
        PBEObj2.Product2Id = cellularProduct.Id;
        PBEObj2.UnitPrice = 12;
        PBEObj2.Pricebook2Id = Test.getStandardPricebookId();
        PBEObj2.IsActive = true;
        pricebookEntryList.add(PBEObj2);
        pricebookEntry PBEObj = new pricebookEntry();
        PBEObj.Product2Id = cellularProduct.Id;
        PBEObj.UnitPrice = 12;
        PBEObj.Pricebook2Id = priceBookObj.Id;
        PBEObj.IsActive = true;
        pricebookEntryList.add(PBEObj);
        insert pricebookEntryList;
        
    }
    @isTest
    public static void afterInsertTest(){
        Opportunity oppObj = [SELECT Id,AccountId FROM opportunity WHERE Name = 'KAE Electronics'];
         pricebookEntry PBEObj = [SELECT Id FROM pricebookEntry WHERE UnitPrice = 12 LIMIT 1 ];
        pricebook2 priceBookObj = [SELECT Id FROM pricebook2 WHERE name = 'Standard Price Book' LIMIT 1];
        
        Quote quoteObj = new Quote();
        quoteObj.OpportunityId = oppObj.Id;
        quoteObj.Name = 'test quote';
        quoteObj.pricebook2Id = priceBookObj.Id;
        quoteObj.Quotation_Account__c = oppObj.AccountId;

        insert quoteObj;
        
    }
        @isTest
    public static void afterUpdateTest(){
        Opportunity oppObj = [SELECT Id,AccountId FROM opportunity WHERE Name = 'KAE Electronics'];
         pricebookEntry PBEObj = [SELECT Id FROM pricebookEntry WHERE UnitPrice = 12 LIMIT 1 ];
        pricebook2 priceBookObj = [SELECT Id FROM pricebook2 WHERE name = 'Standard Price Book' LIMIT 1];
        
        Quote quoteObj = new Quote();
        quoteObj.OpportunityId = oppObj.Id;
        quoteObj.Name = 'test quote Update';
        quoteObj.pricebook2Id = priceBookObj.Id;
        quoteObj.Quotation_Account__c = oppObj.AccountId;
        insert quoteObj;
        
        quoteObj.Name = 'test quote update';
        update quoteObj;
    }
}
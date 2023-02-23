/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest
private class NewQuotationSPRCtrlTest {
    static testMethod void TestNewSPRQuotation() {
        Account acc = new Account();
        acc.uB_Office__c = 'Corporate';
        acc.Name = 'test class name';           
        acc.Abacus_Payterms__c = 'test payment abacus'; 
        acc.CurrencyIsoCode = 'USD';
        insert acc;

        Opportunity quotOpp = new Opportunity();
        quotOpp.Name = 'Test Opportunity';        
        quotOpp.CloseDate = Date.newInstance(2016, 12, 9);
        quotOpp.AccountId = acc.Id;
        quotOpp.StageName = '5 Design-in';
        quotOpp.Value_Proposition__c = 'test value proposition';
        quotOpp.Gain_Creators__c = 'test';
        quotOpp.Pain_Relievers__c='text area';
        quotOpp.Customer_Type__c='test';
        quotOpp.Gains__c = 'ere';
        quotOpp.Pains__c='pains';
        quotOpp.Customer_Jobs__c = 'customer jobs';
        insert quotOpp;
            
        Contact cont = new Contact();
        cont.LastName = 'Test contact name';
        cont.AccountId = acc.Id;
        insert cont;
            
        Special_Price_Request__c spr = new Special_Price_Request__c();
        spr.Price_Level__c = 'PPP (Project Price Plan)';
        spr.Account__c = acc.Id;
        spr.CurrencyIsoCode = 'USD';
        spr.Account__c = acc.Id;
        spr.Delivery__c = 'FCA Thalwil (CH)';
        
        spr.Payment__c = '30 days end of month net';
        spr.Status__c = 'Approved';
        spr.Approved_By_Regional_Head__c = true;
        spr.Opportunity__c = quotOpp.Id;
        spr.Contact__c = cont.Id;
        insert spr;

        Product2 prod = new Product2();
        //Product__c prod = new Product__c();
        prod.Name = 'Test product';
        prod.Type_No__c = 'Test 123654789 type';
        prod.Packaging_Size__c = 123456;
        //prod.Product_Family__c = 'ALEX';
        prod.Positioning_Engine__c = 'u-blox D9';
        prod.CurrencyIsoCode = spr.CurrencyIsoCode;
        insert prod;
        
        
        Special_Price_Request_Product__c sprp = new Special_Price_Request_Product__c();
        sprp.Special_Price_Request__c = spr.Id;
        sprp.Product__c = prod.Id;
        sprp.CurrencyIsoCode = spr.CurrencyIsoCode;
        sprp.Year_P1__c = Date.newInstance(2016, 12, 9);
        sprp.Unit_Price_P1__c = 15;
        sprp.Quantity_P1__c = 1500;
        sprp.Quantity_P2__c = 15;
        sprp.Quantity_P3__c = 20;
        sprp.Quantity_P4__c = 20;
        sprp.Quantity_P5__c = 20; 
        insert sprp;
        
        Special_Price_Request_Product__c sprp2 = new Special_Price_Request_Product__c();
        sprp2.Special_Price_Request__c = spr.Id;
        sprp2.Product__c = prod.Id;
        sprp2.CurrencyIsoCode = spr.CurrencyIsoCode;
        sprp2.Year_P1__c = Date.newInstance(2016, 12, 9);
        sprp2.Unit_Price_P1__c = 15;
        sprp2.Quantity_P1__c = 1500;
        insert sprp2;
        
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = prod.Id,
            CurrencyIsoCode = 'USD',
            UnitPrice = 10.5,
            IsActive = true,
            UseStandardPrice = false
        );
        insert pbe;
       
        NewQuotationSPRCtrl.getSPRid(spr.Id); 
          
            
    }
}
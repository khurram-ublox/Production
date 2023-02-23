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
@isTest
private class OpportunityLineItemTriggerHandlerTest {

    static final Product2 cellularProduct;    
    static final Account quoteAccount;
    static final Opportunity quotation;
    static final PricebookEntry stdPriceBookEntry;
    static final OpportunityLineItem[] quoteProducts = new OpportunityLineItem[]{};
            
    static{        
        quoteAccount = new Account(
            Name = 'KAE Electronics',
            uB_Office__c = 'EMEA'
        );
        database.insert(quoteAccount);

        cellularProduct = new Product2(
            Name='TOBY-L201 quote',
            BusinessUnit__c = 'u-blox', 
            Type_No__c='TOBY-L201-02S-01-q', 
            Product_Center__C='Cellular'
        ); 
        database.insert(cellularProduct);
        
        stdPriceBookEntry = new PricebookEntry(
            Pricebook2Id = test.getStandardPricebookId(),
            Product2Id = cellularProduct.Id,
            UnitPrice = 0.00,
            IsActive = true
        );
        database.insert(stdPriceBookEntry);

        quotation = new Opportunity(
            Name='KAE Electronics', 
            StageName='3 Calling on',
            CloseDate = Date.today().addDays(7),            
            End_Customer_Account__c = quoteAccount.Id,
            Quotation_Account__c = quoteAccount.Id,
            AccountId = quoteAccount.Id,
            Type_of_quotation__c = 'Quotation',
            RecordTypeId = Schema.sObjectType.Opportunity.getRecordTypeInfosByName().get('Quotation').getRecordTypeId()
        );
        database.insert(quotation);
        
        system.assert(cellularProduct.Id != null);
        system.assert(quotation.Id != null);
        
        quoteProducts.add(new OpportunityLineItem(
            OpportunityId = quotation.Id,
            Product2Id = cellularProduct.Id,
            PricebookEntryId = stdPriceBookEntry.Id,
            Quantity = 10,
            UnitPrice = 14,
            Price_Level__c = 'RSP (Recommended Sales Price)',
            IPR_Coverage__c = 'Prime coverage'
        ));
        quoteProducts.add(new OpportunityLineItem(
            OpportunityId = quotation.Id,
            Product2Id = cellularProduct.Id,
            PricebookEntryId = stdPriceBookEntry.Id,            
            Quantity = 10,
            UnitPrice = 15,
            Price_Level__c = 'RSP (Recommended Sales Price)',
            IPR_Coverage__c = 'Premium coverage'
        ));
        database.insert(quoteProducts);
    }
       
    static testMethod void codeCoverageForReadonlyMethods() {
        // TO DO: implement unit test
        OpportunityLineItemTriggerHandler handler = new OpportunityLineItemTriggerHandler();        
        handler.prepareBefore();
        handler.prepareAfter();
        handler.beforeInsert();
        handler.beforeUpdate();
        handler.afterUpdate();
        handler.beforeDelete();
        handler.afterDelete();
    }
}
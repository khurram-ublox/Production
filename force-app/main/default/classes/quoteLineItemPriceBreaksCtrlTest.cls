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
public class quoteLineItemPriceBreaksCtrlTest {
    static final Product2 cellularProduct;    
    static final Account quoteAccount;
    static final opportunity opportunity;
    static final Quote quotation;
    static final list<Quote> quoteList;
    static final PricebookEntry stdPriceBookEntry;
    static final QuoteLineItem[] quoteProducts = new QuoteLineItem[]{};
        
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
            
            Opportunity = new Opportunity(
                Name='KAE Electronics', 
                StageName='3 Calling on',
                CloseDate = Date.today().addDays(7),            
                End_Customer_Account__c = quoteAccount.Id,
                Quotation_Account__c = quoteAccount.Id,
                AccountId = quoteAccount.Id,
                // Type_of_quotation__c = 'Quotation',
                RecordTypeId = Schema.sObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity').getRecordTypeId()
            );
            database.insert(Opportunity);
            
            quotation = new Quote(
                Name='KAE Electronics',
                opportunityId =Opportunity.Id,
                pricebook2Id =test.getStandardPricebookId(),
                //CloseDate = Date.today().addDays(7),            
                //End_Customer_Account__c = AccountId,
                Quotation_Account__c = quoteAccount.Id
                //AccountId = quoteAccount.Id
                
            );
            quoteList= new list<Quote>();
            quoteList.add(quotation);
            database.insert(quoteList);
            
            system.assert(cellularProduct.Id != null);
            system.assert(quoteList[0].Id != null);
            
            quoteProducts.add(new QuoteLineItem(
                QuoteId = quoteList[0].Id,
                Product2Id = cellularProduct.Id,
                PricebookEntryId = stdPriceBookEntry.Id,
                Quantity = 10,
                UnitPrice = 14,
                Price_Level__c = 'RSP (Recommended Sales Price)',
                IPR_Coverage__c = 'Prime coverage'
            ));
            quoteProducts.add(new QuoteLineItem(
                //  QuoteId = quotation.Id,
                quoteId = quoteList[0].Id,
                Product2Id = cellularProduct.Id,
                PricebookEntryId = stdPriceBookEntry.Id,            
                Quantity = 10,
                UnitPrice = 15,
                Price_Level__c = 'RSP (Recommended Sales Price)',
                IPR_Coverage__c = 'Premium coverage'
            ));
            database.insert(quoteProducts);
            
        }
    
    static testMethod void codeCoverageMultiPriceBreakWithExistingItem() {
        // TO DO: implement unit test
        ApexPages.currentPage().getParameters().put('id',quoteList[0].Id);
        
        ApexPages.StandardSetController sController = new ApexPages.StandardSetController(quoteList);        
        quoteLineItemPriceBreaksCtrl ctrl = new quoteLineItemPriceBreaksCtrl(sController);        
        ctrl.quoteId = quoteList[0].Id;
        Quote_Multi_Price_Breaks__c priceBreak = new Quote_Multi_Price_Breaks__c(
            Quote__c = quoteList[0].Id,
            Quote_Line_Item__c = quoteProducts[1].Id,
            Product__c = quoteProducts[1].Product2Id,
            Year__c = '2023',
            Price_Sample_1k__c = 4.5,
            Price_Sample_100__c = 4.7,
            Price_Sample_4k__c = 5,
            Price_Sample_50k__c = 5.5,
            Price_Sample_100k__c = 6
        ); 
        quoteLineItemPriceBreaksCtrl.priceBreaksWrapper wrapper = new quoteLineItemPriceBreaksCtrl.priceBreaksWrapper();
        wrapper.productName = quoteProducts[1].Product2.Name;
        wrapper.orderingCode = quoteProducts[1].Product2.ProductCode;
        wrapper.priceBreak = priceBreak;
        list<quoteLineItemPriceBreaksCtrl.priceBreaksWrapper> wrapperList = new list<quoteLineItemPriceBreaksCtrl.priceBreaksWrapper>();
        wrapperList.add(wrapper);
        ctrl.multiPriceBreaks.put(quoteProducts[1].Id,wrapperList);  
        ctrl.saveAll();      
    }

    static testMethod void codeCoverageMultiPriceBreak() {
        // TO DO: implement unit test
        ApexPages.currentPage().getParameters().put('id',quoteList[0].Id);
        
        ApexPages.StandardSetController sController = new ApexPages.StandardSetController(quoteList);        
        quoteLineItemPriceBreaksCtrl ctrl = new quoteLineItemPriceBreaksCtrl(sController);
        ctrl.showQuoteLookup = true;
        ctrl.quoteLookupId = quoteProducts[0];
        ctrl.quoteId = quoteList[0].Id;
        ctrl.addPriceBreaksFromExistingQuote();
        ctrl.saveAll();      
    }
}
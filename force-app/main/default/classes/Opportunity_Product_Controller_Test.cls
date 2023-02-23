@isTest(seealldata=false)
public class Opportunity_Product_Controller_Test {
    public static testmethod void customInlineOpp (){
        Account acc = new Account(Name='Test Acc',uB_Office__c='Corporate');
        insert acc;
		Opportunity opp = new Opportunity(Name='TestOpp', StageName='3 Calling on',CloseDate=Date.today(),Description='test description',AccountId=acc.Id);
        insert opp;
        
        Product2 prodForRanked3 = new Product2(Name='testProd2222', Type_No__c='testTypeNum3332', Product_Center__C='Positioning');  // khir: Added Product Canter
        insert prodForRanked3;

		Id recTypeId = Schema.SObjectType.Opp_Product__c.getRecordTypeInfosByDeveloperName().get('Opp_Product_Tashang').getRecordTypeId(); 
        
        Opp_Product__c oppProductRanked1 = new Opp_Product__c(); 
        // Revenue = Annual_Quantity__c * Unit_Price__c * Status_Factor__c
        oppProductRanked1.Annual_Quantity__c = 10000;
        oppProductRanked1.Opportunity__c = opp.id;
        oppProductRanked1.RecordTypeId = recTypeId;
        oppProductRanked1.Unit_Price__c = 10;
        oppProductRanked1.Status__c = 'Won'; 
        oppProductRanked1.Loss_Reason__c = 'Price'; 
        oppProductRanked1.Product__c = prodForRanked3.Id; 
		insert oppProductRanked1;

        Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.Inline_Opportunity_Product')); 
        System.currentPageReference().getParameters().put('id', oppProductRanked1.Id);
        system.assertEquals(1, [select count() from Opp_Product__c ]) ;


        ApexPages.StandardController sc = new ApexPages.StandardController(oppProductRanked1);
		Opportunity_Product_Controller opc = new Opportunity_Product_Controller(sc);
        Test.stopTest();
    }
}
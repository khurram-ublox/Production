@isTest(seeAllData = false)
public class updateCustomProductTest {
    
    public static testmethod void updateCustomProductTestMethod(){
		Test.startTest();	
        	Map<Id, Opp_Product__c> oppProducts = new Map<Id, Opp_Product__c>();
        	
        	Id RecordTypeIdOppProd = Schema.SObjectType.Opp_Product__c.getRecordTypeInfosByName().get('Opp Product Tashang').getRecordTypeId();
        	            
        	Account acc = new Account(Name='Test Acc',uB_Office__c='Corporate');
            insert acc;

        	Opportunity opp = new Opportunity(Name='TestOpp', StageName='3 Calling on',CloseDate=Date.today(),Description='test description',AccountId=acc.Id);
        	insert opp;
            
        	Product2 prod1 = new Product2(Name='testProd1', Type_No__c='testTypeNum1',
                                          Product_Center__C='Positioning',
                                          Visible_To_Partner__c = true,
                                          MFi_License_Required__c = false,
                                          BusinessUnit__c ='Tashang');  
        	insert prod1;
        
        	Opp_Product__c oppProduct = new Opp_Product__c();
        	oppProduct.Opportunity__c= opp.Id;
            oppProduct.RecordTypeID= RecordTypeIdOppProd;
            oppProduct.Annual_Quantity__c = 10000;
            oppProduct.Unit_Price__c = 10;
            oppProduct.Status__c = 'Won'; 
            oppProduct.Loss_Reason__c = 'Price'; 
            oppProduct.Product__c = prod1.Id;
			insert oppProduct;
        
        	oppProducts.put(oppProduct.id,oppProduct);
    // Commenting out this(updateProduct) method. It is for the removal of custom Product obj. By ufar, 12-6-22.
			/*  
            oppProductTriggerHelper.updateProduct(oppProducts);
			*/
            system.assertEquals(1, [select count() from Product2 ]) ;
        Test.stopTest();
        
	}

}
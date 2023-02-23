@isTest(seealldata=false)
public class BeforeUpdateAbacusProductTest {
    
    public static testmethod void insertCustomProductTest(){
        
        Map<Id,Product2> prodMap = new Map<Id,Product2>();
        Product2 prod1 = new Product2(Name='testProd1', Type_No__c='testTypeNum1',
                                      Product_Center__C='Positioning',
                                      Automotive_Product__c = true,
                                      ES_Under_Allocation__c = true,
                                      FOTA__c = false,
                                      From_Abacus__c =true,
                                      IPR_Checked__c = false,
                                      IPR_Technology_Changed__c = true,
                                      MEID__c =false,
                                      RoT__c = false,
                                      Shop_Active__c = false,
                                      Time_Based_WF_Flag__c = true,
                                      Use_Abacus_Cost__c = true,
                                      Visible_In_Masterschedule__c	= false,
                                      Visible_To_Partner__c = true,
                                      MFi_License_Required__c = false,
                                      BusinessUnit__c ='Tashang');  
        insert prod1;
        prodMap.put(prod1.id,prod1);
        
        
        
        
        Test.startTest();
    // Commenting out this(updateProduct) method. It is for the removal of custom Product obj. By ufar, 12-6-22.
	/*  
        BeforeUpdateAbacusProduct.upsertCustomProduct(prodMap);
	*/
        system.assertEquals(1, [select count() from Product2 ]) ;
        Test.stopTest();
        
    }
    public static testmethod void testCustomProductTest(){
        List<Product2> oldlistProduct=new List<Product2>();
        List<Product2> newlistProduct=new List<Product2>();
        
        oldlistProduct.add(new Product2(Name='Test123', Type_No__c='type', From_Abacus__c = false));
        insert oldListProduct;
        
        newlistProduct.add(new Product2(Name='Test', Type_No__c='type123', From_Abacus__c = true));
        
        //update oldListProduct;

        system.debug('oldListProduct: '+oldListProduct);
        system.debug('newlistProduct: '+newlistProduct);
        
        test.startTest();
        try{
            BeforeUpdateAbacusProduct.profileName = 'standard user';
            BeforeUpdateAbacusProduct.errorMessage = 'Product linked to Abacus. Name, Ordering No, Type No, Status, and Product Text are not modifiable.';
        	BeforeUpdateAbacusProduct.beforeUpdateAbacusProduct(newlistProduct,oldListProduct);
            BeforeUpdateAbacusProduct.doTest();
        }        
        catch (exception ex){
            system.debug('ex Test: '+ex);
            Boolean expectedExceptionThrown =  ex.getMessage().contains('Product linked to Abacus. Name, Ordering No, Type No, Status, and Product Text are not modifiable.') ? true : false;
			//System.assertEquals(expectedExceptionThrown, false);
        }
        test.stopTest();
    }
}
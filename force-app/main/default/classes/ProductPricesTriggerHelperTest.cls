@isTest
public class ProductPricesTriggerHelperTest {
    
     // -------------  updateHandler -----------------------------
     
     // if a non relevant field is changed then its product code should not be returned
   	 @isTest static void testupdateHandlerWithoutAChangeToARelavantField() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      	List<Product2> triggerNew       = new List<Product2>();
        Map<Id, Product2> triggerNewMap = new Map<Id, Product2>();
        List<Product2> triggerOld       = new List<Product2>();
        Map<Id, Product2> triggerOldMap = new Map<Id, Product2>();
         
 		Product2 testProductA = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        insert testProductA;
     	
        triggerNew.add(testProductA);
        triggerNewMap.put(testProductA.Id, testProductA);
         
         
        Product2 clonedtestProductA = testProductA.clone(true);
        clonedtestProductA.Name = 'NEO-M8P-X';
         
        triggerOld.add(clonedtestProductA);
        triggerOldMap.put(clonedtestProductA.Id, clonedtestProductA);
               
        Test.startTest();
        Set<String> productCodes = ProductPricesTriggerHelper.afterUpdateProductHandler(triggerNew, triggerNewMap, triggerOld, triggerOldMap);
        Test.stopTest();
        
        System.assert(productCodes.size() == 0);
	}
    
     // if a relevant field is changed its product code should be returned
   	 @isTest static void testupdateHandlerWithAChangeToARelavantField() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      	List<Product2> triggerNew       = new List<Product2>();
        Map<Id, Product2> triggerNewMap = new Map<Id, Product2>();
        List<Product2> triggerOld       = new List<Product2>();
        Map<Id, Product2> triggerOldMap = new Map<Id, Product2>();
         
 		Product2 testProductA = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        insert testProductA;
     	
        triggerNew.add(testProductA);
        triggerNewMap.put(testProductA.Id, testProductA);
         
        Product2 clonedtestProductA = testProductA.clone(true);
        
        clonedtestProductA.Product_Series__c = 'LEON-G1';
         
        triggerOld.add(clonedtestProductA);
        triggerOldMap.put(clonedtestProductA.Id, clonedtestProductA);
               
        Test.startTest();
        Set<String> productCodes = ProductPricesTriggerHelper.afterUpdateProductHandler(triggerNew, triggerNewMap, triggerOld, triggerOldMap);
        Test.stopTest();
        
        System.assert(productCodes.size() == 1);
	}
    
    
     // if a relevant field is changed its product code should be returned, if not then not
   	 @isTest static void testupdateHandlerWithAChangeMultipleMix() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      	List<Product2> triggerNew       = new List<Product2>();
        Map<Id, Product2> triggerNewMap = new Map<Id, Product2>();
        List<Product2> triggerOld       = new List<Product2>();
        Map<Id, Product2> triggerOldMap = new Map<Id, Product2>();
         
 		Product2 testProductA = new Product2(Name = 'NEO-M8P',  Type_No__c= 'NEO-M8P-2-11',  ProductCode= 'NEO-M8P-2',  Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        insert testProductA;
        Product2 testProductB = new Product2(Name = 'NEO-M8P1', Type_No__c= 'NEO-M8P1-2-11', ProductCode= 'NEO-M8P1-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        insert testProductB;
        Product2 testProductC = new Product2(Name = 'NEO-M8P2', Type_No__c= 'NEO-M8P2-2-11', ProductCode= 'NEO-M8P2-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        insert testProductC;
     	
        triggerNew.add(testProductA);
        triggerNew.add(testProductB);
        triggerNew.add(testProductC);
        triggerNewMap.put(testProductA.Id, testProductA);
        triggerNewMap.put(testProductB.Id, testProductB);
        triggerNewMap.put(testProductC.Id, testProductC);
         
        Product2 clonedtestProductA = testProductA.clone(true);
        Product2 clonedtestProductB = testProductB.clone(true);
        Product2 clonedtestProductC = testProductC.clone(true);
        
        // for two Products a relevant field is changed
        clonedtestProductA.Product_Series__c = 'LEON-G1';
        clonedtestProductB.Name = 'NEO-M8P11';
        clonedtestProductC.Product_Series__c = 'LEON-G1';
         
        triggerOld.add(clonedtestProductA);
        triggerOld.add(clonedtestProductB);
        triggerOld.add(clonedtestProductC);
        triggerOldMap.put(clonedtestProductA.Id, clonedtestProductA);
        triggerOldMap.put(clonedtestProductB.Id, clonedtestProductB);
        triggerOldMap.put(clonedtestProductC.Id, clonedtestProductC);
               
        Test.startTest();
        Set<String> productCodes = ProductPricesTriggerHelper.afterUpdateProductHandler(triggerNew, triggerNewMap, triggerOld, triggerOldMap);
        Test.stopTest();
        System.debug('??????????????????');
        System.debug(productCodes);
        System.debug(productCodes.size());
        System.assert(productCodes.size() == 2);
	}
     
     
     // -------------  rateProductStatus -----------------------------
     
     // rateProductStatus for Product without Product Status should be 0
   	 @isTest static void testRateProductStatusWithoutProductStatus() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
 		Product2 testProductA = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
       
        Test.startTest();
        Integer rate = ProductPricesTriggerHelper.rateProductStatus(testProductA);
        Test.stopTest();
        
        System.assert(rate == 0);
	}
    
	 // rateProductStatus for 'Mass Production' should be 10
   	 @isTest static void testRateProductStatusMassProduction() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
 		Product2 testProductA = new Product2(Name = 'NEO-M8P', Product_Status__c = 'Mass Production', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
       
        Test.startTest();
        Integer rate = ProductPricesTriggerHelper.rateProductStatus(testProductA);
        Test.stopTest();
        
        System.assert(rate == 10);
	}
         
	 // rateProductStatus for 'Initial Production' should be 9
   	 @isTest static void testRateProductStatusInitialProduction() {
      
 		Product2 testProductA = new Product2(Name = 'NEO-M8P', Product_Status__c = 'Initial Production', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = '0052p00000AJ6s3');
       
        Test.startTest();
        Integer rate = ProductPricesTriggerHelper.rateProductStatus(testProductA);
        Test.stopTest();
        
        System.assert(rate == 9);
	}
    
             
	 // rateProductStatus for 'Engineering Samples' should be 8
   	 @isTest static void testRateProductStatusEngineeringSample() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
 		Product2 testProductA = new Product2(Name = 'NEO-M8P', Product_Status__c = 'Engineering Samples', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
       
        Test.startTest();
        Integer rate = ProductPricesTriggerHelper.rateProductStatus(testProductA);
        Test.stopTest();
        
        System.assert(rate == 8);
	}
    
     // rateProductStatus for 'Prototypes' should be 7
   	 @isTest static void testRateProductStatusPrototypes() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
 		Product2 testProductA = new Product2(Name = 'NEO-M8P', Product_Status__c = 'Prototypes', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
       
        Test.startTest();
        Integer rate = ProductPricesTriggerHelper.rateProductStatus(testProductA);
        Test.stopTest();
        
        System.assert(rate == 7);
	}
    
     // rateProductStatus for 'End of Life' should be 6
   	 @isTest static void testRateProductStatusEndOfLife() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
 		Product2 testProductA = new Product2(Name = 'NEO-M8P', Product_Status__c = 'End of Life', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
       
        Test.startTest();
        Integer rate = ProductPricesTriggerHelper.rateProductStatus(testProductA);
        Test.stopTest();
        
        System.assert(rate == 6);
	}
    
     // rateProductStatus for 'In Development' should be 5
   	 @isTest static void testRateProductStatusInDevelopment() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
 		Product2 testProductA = new Product2(Name = 'NEO-M8P', Product_Status__c = 'In Development', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
       
        Test.startTest();
        Integer rate = ProductPricesTriggerHelper.rateProductStatus(testProductA);
        Test.stopTest();
        
        System.assert(rate == 5);
	}
    
      // rateProductStatus for '0' should be 0
   	 @isTest static void testRateProductStatusConsidered() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
         
 		Product2 testProductA = new Product2(Name = 'NEO-M8P', Product_Status__c = 'Considered', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
       
        Test.startTest();
        Integer rate = ProductPricesTriggerHelper.rateProductStatus(testProductA);
        Test.stopTest();
        
        System.assert(rate == 0);
	}
    
     // rateProductStatus for 'Obsolete' should be 0
   	 @isTest static void testRateProductStatusObsolete() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
 		Product2 testProductA = new Product2(Name = 'NEO-M8P', Product_Status__c = 'Obsolete', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
       
        Test.startTest();
        Integer rate = ProductPricesTriggerHelper.rateProductStatus(testProductA);
        Test.stopTest();
        
        System.assert(rate == 0);
	}
    
    
    // -------------  isProductAHigherRatedThanProductB -----------------------------
    
    // test if Product A is higher rated than product B without a Product status should always return false
    @isTest static void testisProductAHigherRatedThanProductBWithoutStatus() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
        Product2 testProductA = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        Product2 testProductB = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        
        Test.startTest();
        Boolean result = ProductPricesTriggerHelper.isProductAHigherRatedThanProductB(testProductA, testProductB);
        Boolean result2 = ProductPricesTriggerHelper.isProductAHigherRatedThanProductB(testProductB, testProductA);
        Test.stopTest();
        
        System.assert(result == false);
        System.assert(result2 == false);
	}
    
    
    // test if Product A with product status 'Mass Producton' is higher rated than product B with Product status 'End of life'
    @isTest static void testisProductAHigherRatedThanProductB() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
        Product2 testProductA = new Product2(Name = 'NEO-M8P', Product_Status__c = 'Mass Production', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        Product2 testProductB = new Product2(Name = 'NEO-M8P', Product_Status__c = 'End of Life', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        
        Test.startTest();
        Boolean result = ProductPricesTriggerHelper.isProductAHigherRatedThanProductB(testProductA, testProductB);
        Boolean result2 = ProductPricesTriggerHelper.isProductAHigherRatedThanProductB(testProductB, testProductA);
        Test.stopTest();
        
        System.assert(result == true);
        System.assert(result2 == false);
	}
    
    
    // test if Product A with product status 'Engineering Samples' is higher rated than product B with Product status 'In Definition'
    @isTest static void testisProductAHigherRatedThanProductB2() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
        Product2 testProductA = new Product2(Name = 'NEO-M8P', Product_Status__c = 'Engineering Samples', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        Product2 testProductB = new Product2(Name = 'NEO-M8P', Product_Status__c = 'In Definition', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        
        Test.startTest();
        Boolean result = ProductPricesTriggerHelper.isProductAHigherRatedThanProductB(testProductA, testProductB);
        Boolean result2 = ProductPricesTriggerHelper.isProductAHigherRatedThanProductB(testProductB, testProductA);
        Test.stopTest();
        
        System.assert(result == true);
        System.assert(result2 == false);
	}
    
    // test if Product A with product status 'Prototypes' is not higher rated than product B with Product status 'Engineering Samples'
    @isTest static void testisProductAHigherRatedThanProductB3() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
        Product2 testProductA = new Product2(Name = 'NEO-M8P', Product_Status__c = 'Prototypes', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        Product2 testProductB = new Product2(Name = 'NEO-M8P', Product_Status__c = 'Engineering Samples', Type_No__c= 'NEO-M8P-2-10', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        
        Test.startTest();
        Boolean result = ProductPricesTriggerHelper.isProductAHigherRatedThanProductB(testProductA, testProductB);
        Boolean result2 = ProductPricesTriggerHelper.isProductAHigherRatedThanProductB(testProductB, testProductA);
        Test.stopTest();
        
        System.assert(result == false);
        System.assert(result2 == true);
	}
    
    // test if Product A with the same product status as product B is not higher because Product B was modified later
    @isTest static void testisProductAHigherRatedThanProductB4() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
        Product2 testProductA = new Product2(Name = 'NEO-M8P', Product_Status__c = 'Prototypes', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        insert testProductA;
		
        
        Long startTime = DateTime.now().getTime();
		Long finalTime = DateTime.now().getTime();
        
        Long millisecondsToWait = 1500; 
        while (finalTime - startTime < millisecondsToWait) {
        	finalTime = DateTime.now().getTime();
        }
        
        Product2 testProductB = new Product2(Name = 'NEO-M8P', Product_Status__c = 'Prototypes', Type_No__c= 'NEO-M8P-2-10', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        insert testProductB;
        
        List<Product2> databaseTestProductA = [SELECT Id, ProductCode, Product_Status__c, Product_Center__c, Product_Series__c, Product_Owner__c, SystemModstamp FROM Product2 WHERE Id = :testProductA.Id];
        List<Product2> databaseTestProductB = [SELECT Id, ProductCode, Product_Status__c, Product_Center__c, Product_Series__c, Product_Owner__c, SystemModstamp FROM Product2 WHERE Id = :testProductB.Id];
        
        System.assert(databaseTestProductA.size() == 1);
        System.assert(databaseTestProductB.size() == 1);

        //system.debug('zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz');
        //system.debug(databaseTestProductA[0].SystemModstamp);
        //system.debug(databaseTestProductB[0].SystemModstamp);
        
        Test.startTest();
        Boolean result = ProductPricesTriggerHelper.isProductAHigherRatedThanProductB(databaseTestProductA[0], databaseTestProductB[0]);
        Boolean result2 = ProductPricesTriggerHelper.isProductAHigherRatedThanProductB(databaseTestProductB[0], databaseTestProductA[0]);
        Test.stopTest();
        
        System.assert(result == false);
        System.assert(result2 == true);
	}
    
        
    // test if Product A with the same product status as product B is  higher because Product A was modified later
    @isTest static void testisProductAHigherRatedThanProductB5() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
        Product2 testProductA = new Product2(Name = 'NEO-M8P', Product_Status__c = 'Prototypes', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        insert testProductA;
        Product2 testProductB = new Product2(Name = 'NEO-M8P', Product_Status__c = 'Prototypes', Type_No__c= 'NEO-M8P-2-10', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        insert testProductB;
        
        Long startTime = DateTime.now().getTime();
		Long finalTime = DateTime.now().getTime();
        
        Long millisecondsToWait = 1500; 
        while (finalTime - startTime < millisecondsToWait) {
        	finalTime = DateTime.now().getTime();
        }
        
        testProductA.Name = 'NEO-M8P-updated'; 
        update testProductA;
          
         
        List<Product2> databaseTestProductA = [SELECT Id, ProductCode, Product_Status__c, Product_Center__c, Product_Series__c, Product_Owner__c, SystemModstamp FROM Product2 WHERE Id = :testProductA.Id];
        List<Product2> databaseTestProductB = [SELECT Id, ProductCode, Product_Status__c, Product_Center__c, Product_Series__c, Product_Owner__c, SystemModstamp FROM Product2 WHERE Id = :testProductB.Id];
        
        System.assert(databaseTestProductA.size() == 1);
        System.assert(databaseTestProductB.size() == 1);
        
        //system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXyyyyyyyyyyyyyyyyyyyy');
        //system.debug(databaseTestProductA[0].SystemModstamp);
        //system.debug(databaseTestProductB[0].SystemModstamp);
        
        Test.startTest();
        Boolean result = ProductPricesTriggerHelper.isProductAHigherRatedThanProductB(databaseTestProductA[0], databaseTestProductB[0]);
        Boolean result2 = ProductPricesTriggerHelper.isProductAHigherRatedThanProductB(databaseTestProductB[0], databaseTestProductA[0]);
        Test.stopTest();
        
        System.assert(result == true);
        System.assert(result2 == false);
	}
    
   
    @isTest static void testisMaxMapPricingBLowerThanA() {
        Boolean isBLowerA = ProductPricesTriggerHelper.isMaxMapPricingBLowerThanA('100', '50');
        System.assertEquals(true, isBLowerA);
        
        isBLowerA = ProductPricesTriggerHelper.isMaxMapPricingBLowerThanA('100', '500');
        System.assertEquals(false, isBLowerA);
    }
    
    
    @isTest static void testisMaxMapPricingBLowerThanAWithEmptyFields() {
        Boolean isBLowerA = ProductPricesTriggerHelper.isMaxMapPricingBLowerThanA('100', null);
        System.assertEquals(true, isBLowerA);
        
        isBLowerA = ProductPricesTriggerHelper.isMaxMapPricingBLowerThanA(null, null);
        System.assertEquals(false, isBLowerA);
    }
    
    
}
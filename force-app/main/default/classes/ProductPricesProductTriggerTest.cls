@isTest
public class ProductPricesProductTriggerTest {

    @testSetup static void setup() {
        ProductPricesTestDataFactory.setupConversionRates();
    }
    
    // ---------- insert ---------------------------------------------------
    
    // if a product is created without a price present it should not cause any issues
    @isTest static void testInsertingAProductWithoutAPrice() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id, Map_Pricing__c = true, max_MAP_pricing__c = '25');
        
        Test.startTest();
        Database.SaveResult result = Database.insert(testProduct, false);
        Test.stopTest();
        system.debug('dddddddddddddddddddddd');
         //system.debug(result.isSuccess());
        //system.debug(result.getErrors());
        //system.debug(result.getErrors()[0].getMessage());
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
	}
    
    
    // if a product is created without a price present it should not cause any issues
    @isTest static void testInsertingAProductWithAPrice() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        insert testProductPrice;
        
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id, Map_Pricing__c = true, max_MAP_pricing__c = '25');
        
        Test.startTest();
        Database.SaveResult result = Database.insert(testProduct, false);
        Test.stopTest();

        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assertEquals(1, productPrice.size());
        System.assertEquals('Cellular' ,productPrice[0].Product_Center__c);
        System.assertEquals('LARA-R2', productPrice[0].Product_Series__c);
        System.assertEquals(testUser.Id, productPrice[0].Product_Owner__c);
        System.assertEquals('25', productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true, productPrice[0].Map_Pricing_OR__c);
        //System.assert(productPrice[0].is_most_recent__c == true);
    }
    
    // if a product is created without multiple prices present it should not cause any issues
    @isTest static void testInsertingAProductWithMultiplePrices() {
      
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
        
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2',  Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        insert testProductPrice;
        ProductPrices__c testProductPrice2 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-08', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 148.0000, Price_USD_Sample_Size_10__c=104.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,8) );
        insert testProductPrice2;
        ProductPrices__c testProductPrice3 = new ProductPrices__c(Name = 'NEO-M8P-2-2019-02-03', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        insert testProductPrice3;
        
        ProductPrices__c testProductPrice_other = new ProductPrices__c(Name = 'MAX-8C-2019-02-03', Product_Name__c= 'MAX-8C', Ordering_Number__c='MAX-8C-0', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        insert testProductPrice_other;
        
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id, Map_Pricing__c = false, max_MAP_pricing__c = '1000');
        
        Test.startTest();
        Database.SaveResult result = Database.insert(testProduct, false);
        Test.stopTest();

        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        
        // All three prices for NEO-M8P-2 should have been updated
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assert(productPrice.size() == 1);
        System.assertEquals('Cellular' ,productPrice[0].Product_Center__c);
        System.assertEquals('LARA-R2', productPrice[0].Product_Series__c);
        System.assertEquals(testUser.Id, productPrice[0].Product_Owner__c);
        System.assertEquals('1000', productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(false, productPrice[0].Map_Pricing_OR__c);
        
        List<ProductPrices__c> productPrice2 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice2.Id];
        System.assert(productPrice2.size() == 1);
        System.assertEquals('Cellular' ,productPrice2[0].Product_Center__c);
        System.assertEquals('LARA-R2', productPrice2[0].Product_Series__c);
        System.assertEquals(testUser.Id, productPrice2[0].Product_Owner__c);
        System.assertEquals('1000', productPrice2[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(false, productPrice2[0].Map_Pricing_OR__c);

        
        List<ProductPrices__c> productPrice3 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice3.Id];
        System.assert(productPrice3.size() == 1);
        System.assert(productPrice3[0].Product_Center__c == 'Cellular');
        System.assert(productPrice3[0].Product_Series__c == 'LARA-R2');
        System.assert(productPrice3[0].Product_Owner__c  == testUser.Id);
        System.assertEquals('1000', productPrice3[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(false, productPrice3[0].Map_Pricing_OR__c);
        
        // The price for MAX-8C should not have been updated
        List<ProductPrices__c> productPrice_other = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice_other.Id];
        System.assert(productPrice_other.size() == 1);
        System.assert(productPrice_other[0].Product_Center__c != 'Cellular');
        System.assert(productPrice_other[0].Product_Series__c != 'LARA-R2');
        System.assert(productPrice_other[0].Product_Owner__c  != testUser.Id);
        System.assertEquals(null, productPrice_other[0].Max_MAP_Pricing_Min__c);  
        System.assertEquals(false, productPrice_other[0].Map_Pricing_OR__c);
    }
    
    // if a multiple products are created without multiple prices present it should not cause any issues
    @isTest static void testInsertingMultipleProductsWithMultiplePrices() {
      
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
        
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2',  Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        insert testProductPrice;
        ProductPrices__c testProductPrice2 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-08', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 148.0000, Price_USD_Sample_Size_10__c=104.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,8) );
        insert testProductPrice2;
        ProductPrices__c testProductPrice3 = new ProductPrices__c(Name = 'NEO-M8P-2-2019-02-03', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        insert testProductPrice3;
        
        ProductPrices__c testProductPrice_other = new ProductPrices__c(Name = 'MAX-8C-2019-02-03', Product_Name__c= 'MAX-8C', Ordering_Number__c='MAX-8C-0', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        insert testProductPrice_other;
        
        Product2 testProduct  = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id, Map_Pricing__c = false, max_MAP_pricing__c = '500');
        Product2 testProduct2 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-0-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id, Map_Pricing__c = false, max_MAP_pricing__c = '1000');
        Product2 testProduct3 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-1-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id, Map_Pricing__c = false, max_MAP_pricing__c = '100');
        List<Product2> testProducts = new List<Product2>();
        testProducts.add(testProduct);
        testProducts.add(testProduct2);
        testProducts.add(testProduct3);
        
        Test.startTest();
        Database.SaveResult[] results = Database.insert(testProducts, false);
        Test.stopTest();
	 
        for (Database.SaveResult result : results) {
            System.assert(result.isSuccess());
        	System.assert(result.getErrors().size() == 0);
        }
        
        
        // All three prices for NEO-M8P-2 should have been updated
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assert(productPrice.size() == 1);
        System.assertEquals('Cellular' ,productPrice[0].Product_Center__c);
        System.assertEquals('LARA-R2', productPrice[0].Product_Series__c);
        System.assertEquals(testUser.Id, productPrice[0].Product_Owner__c);
        System.assertEquals('100', productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(false, productPrice[0].Map_Pricing_OR__c);
        
        List<ProductPrices__c> productPrice2 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice2.Id];
        System.assert(productPrice2.size() == 1);
        System.assertEquals('Cellular' ,productPrice2[0].Product_Center__c);
        System.assertEquals('LARA-R2', productPrice2[0].Product_Series__c);
        System.assertEquals(testUser.Id, productPrice2[0].Product_Owner__c);
        System.assertEquals('100', productPrice2[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(false, productPrice2[0].Map_Pricing_OR__c);

        
        List<ProductPrices__c> productPrice3 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice3.Id];
        System.assert(productPrice3.size() == 1);
        System.assert(productPrice3[0].Product_Center__c == 'Cellular');
        System.assert(productPrice3[0].Product_Series__c == 'LARA-R2');
        System.assert(productPrice3[0].Product_Owner__c  == testUser.Id);
        System.assertEquals('100', productPrice3[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(false, productPrice3[0].Map_Pricing_OR__c);
        
        // The price for MAX-8C should not have been updated
        List<ProductPrices__c> productPrice_other = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice_other.Id];
        System.assert(productPrice_other.size() == 1);
        System.assert(productPrice_other[0].Product_Center__c != 'Cellular');
        System.assert(productPrice_other[0].Product_Series__c != 'LARA-R2');
        System.assert(productPrice_other[0].Product_Owner__c  != testUser.Id);
        System.assertEquals(null, productPrice_other[0].Max_MAP_Pricing_Min__c);  
        System.assertEquals(false, productPrice_other[0].Map_Pricing_OR__c);
    }
    
    
    // if a multiple products (without Map_Pricing__c or max_MAP_pricing__c) are created one price present it should not cause any issues
    @isTest static void testInsertingMultipleProductsWithoutMapPricingWithOnePrice() {
      
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
        
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2',  Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        insert testProductPrice;
        
        Product2 testProduct  = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        Product2 testProduct2 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-0-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        Product2 testProduct3 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-1-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id);
        
        List<Product2> testProducts = new List<Product2>();
        testProducts.add(testProduct);
        testProducts.add(testProduct2);
        testProducts.add(testProduct3);
        
        Test.startTest();
        Database.SaveResult[] results = Database.insert(testProducts, false);
        Test.stopTest();
	 
        for (Database.SaveResult result : results) {
            System.assert(result.isSuccess());
        	System.assert(result.getErrors().size() == 0);
        }
        
        
        // The price for NEO-M8P-2 should have been updated
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assert(productPrice.size() == 1);
        System.assertEquals('Cellular' ,productPrice[0].Product_Center__c);
        System.assertEquals('LARA-R2', productPrice[0].Product_Series__c);
        System.assertEquals(testUser.Id, productPrice[0].Product_Owner__c);
        System.assertEquals(null, productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(false, productPrice[0].Map_Pricing_OR__c);    
    }
    
    // --------- update ---------------------------------------------------------------------------------
    
    // if a product is created without multiple prices present it should not cause any issues
    @isTest static void testUpdatingAProductWithMultiplePrices() {
      
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
        User testUser2 = ProductPricesTestDataFactory.createTestUser('new', 'user');
        
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2',  Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        insert testProductPrice;
        ProductPrices__c testProductPrice2 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-08', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 148.0000, Price_USD_Sample_Size_10__c=104.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,8) );
        insert testProductPrice2;
        ProductPrices__c testProductPrice3 = new ProductPrices__c(Name = 'NEO-M8P-2-2019-02-03', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        insert testProductPrice3;
        
        ProductPrices__c testProductPrice_other = new ProductPrices__c(Name = 'MAX-8C-2019-02-03', Product_Name__c= 'MAX-8C', Ordering_Number__c='MAX-8C-0', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        insert testProductPrice_other;
        
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id, Map_Pricing__c = false, max_MAP_pricing__c = '1000');
        insert testProduct;
        
      
        testProduct.Product_Center__c = 'Short Range';
        testProduct.Product_Series__c = 'LILY-W1';
        testProduct.Product_Owner__c  = testUser2.Id;
        testProduct.Map_Pricing__c = true;
        testProduct.max_MAP_pricing__c = '500';
        
        Test.startTest();
        Database.SaveResult result = Database.update(testProduct, false);
        Test.stopTest();

        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        
        // All three prices for NEO-M8P-2 should have been updated
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assert(productPrice.size() == 1);
        System.assert(productPrice[0].Product_Center__c == 'Short Range');
        System.assert(productPrice[0].Product_Series__c == 'LILY-W1');
        System.assert(productPrice[0].Product_Owner__c  == testUser2.Id);
        System.assertEquals('500', productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true, productPrice[0].Map_Pricing_OR__c);
        
        List<ProductPrices__c> productPrice2 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice2.Id];
        System.assert(productPrice2.size() == 1);
        System.assert(productPrice2[0].Product_Center__c == 'Short Range');
        System.assert(productPrice2[0].Product_Series__c == 'LILY-W1');
        System.assert(productPrice2[0].Product_Owner__c  == testUser2.Id);
        System.assertEquals('500', productPrice2[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true, productPrice2[0].Map_Pricing_OR__c);
        
        List<ProductPrices__c> productPrice3 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice3.Id];
        System.assert(productPrice3.size() == 1);
        System.assert(productPrice3[0].Product_Center__c == 'Short Range');
        System.assert(productPrice3[0].Product_Series__c == 'LILY-W1');
        System.assert(productPrice3[0].Product_Owner__c  == testUser2.Id);
        System.assertEquals('500', productPrice3[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true, productPrice3[0].Map_Pricing_OR__c);
        
        // The price for MAX-8C should not have been updated
        List<ProductPrices__c> productPrice_other = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice_other.Id];
        System.assert(productPrice_other.size() == 1);
        System.assert(productPrice_other[0].Product_Center__c != 'Short Range');
        System.assert(productPrice_other[0].Product_Series__c != 'LILY-W1');
        System.assert(productPrice_other[0].Product_Owner__c  != testUser2.Id);
        System.assertEquals(null, productPrice_other[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(false, productPrice_other[0].Map_Pricing_OR__c);
    }
    
    
    // if multiple products are created without multiple prices present it should not cause any issues
    @isTest static void testUpdatingMultipleProductsWithMultiplePrices() {
      
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
        User testUser2 = ProductPricesTestDataFactory.createTestUser('new', 'user');
        
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2',  Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        insert testProductPrice;
        ProductPrices__c testProductPrice2 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-08', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 148.0000, Price_USD_Sample_Size_10__c=104.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,8) );
        insert testProductPrice2;
        ProductPrices__c testProductPrice3 = new ProductPrices__c(Name = 'NEO-M8P-2-2019-02-03', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        insert testProductPrice3;
        
        ProductPrices__c testProductPrice_other = new ProductPrices__c(Name = 'MAX-8C-2019-02-03', Product_Name__c= 'MAX-8C', Ordering_Number__c='MAX-8C-0', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        insert testProductPrice_other;
        
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id, Map_Pricing__c = false, max_MAP_pricing__c = '1000');
        insert testProduct;
        Product2 testProduct2 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-0-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id, Map_Pricing__c = false, max_MAP_pricing__c = '1000');
        insert testProduct2;
        Product2 testProduct3 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-1-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id, Map_Pricing__c = false, max_MAP_pricing__c = '100');
        insert testProduct3;
             
    
        testProduct.Product_Center__c = 'Short Range';
        testProduct.Product_Series__c = 'LILY-W1';
        testProduct.Product_Owner__c  = testUser2.Id;
        testProduct.Map_Pricing__c = true;
        testProduct.max_MAP_pricing__c = '500';
        
        testProduct3.max_MAP_pricing__c = '500';
        
        List<Product2> testProducts = new List<Product2>();
        testProducts.add(testProduct);
        testProducts.add(testProduct3);
        
        Test.startTest();
        Database.SaveResult[] results = Database.update(testProducts, false);
        Test.stopTest();

	 
        for (Database.SaveResult result : results) {
            System.assert(result.isSuccess());
        	System.assert(result.getErrors().size() == 0);
        }
        
        // All three prices for NEO-M8P-2 should have been updated
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assert(productPrice.size() == 1);
        System.assert(productPrice[0].Product_Center__c == 'Short Range');
        System.assert(productPrice[0].Product_Series__c == 'LILY-W1');
        System.assert(productPrice[0].Product_Owner__c  == testUser2.Id);
        System.assertEquals('500', productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true, productPrice[0].Map_Pricing_OR__c);
        
        List<ProductPrices__c> productPrice2 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice2.Id];
        System.assert(productPrice2.size() == 1);
        System.assert(productPrice2[0].Product_Center__c == 'Short Range');
        System.assert(productPrice2[0].Product_Series__c == 'LILY-W1');
        System.assert(productPrice2[0].Product_Owner__c  == testUser2.Id);
        System.assertEquals('500', productPrice2[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true, productPrice2[0].Map_Pricing_OR__c);
        
        List<ProductPrices__c> productPrice3 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice3.Id];
        System.assert(productPrice3.size() == 1);
        System.assert(productPrice3[0].Product_Center__c == 'Short Range');
        System.assert(productPrice3[0].Product_Series__c == 'LILY-W1');
        System.assert(productPrice3[0].Product_Owner__c  == testUser2.Id);
        System.assertEquals('500', productPrice3[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true, productPrice3[0].Map_Pricing_OR__c);
        
        // The price for MAX-8C should not have been updated
        List<ProductPrices__c> productPrice_other = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice_other.Id];
        System.assert(productPrice_other.size() == 1);
        System.assert(productPrice_other[0].Product_Center__c != 'Short Range');
        System.assert(productPrice_other[0].Product_Series__c != 'LILY-W1');
        System.assert(productPrice_other[0].Product_Owner__c  != testUser2.Id);
        System.assertEquals(null, productPrice_other[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(false, productPrice_other[0].Map_Pricing_OR__c);
    }
    
    
    // ---------- delete -------------------------------------------------------------------------
    
        
    // delete the only Product for a Product Price, values should be reset
    @isTest static void testDeleteAProductWithAPrice() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        insert testProductPrice;
        
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id,  Map_Pricing__c = true, max_MAP_pricing__c = '1000');
        insert testProduct;
        
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assert(productPrice.size() == 1);
        System.assert(productPrice[0].Product_Center__c == 'Cellular');
        System.assert(productPrice[0].Product_Series__c == 'LARA-R2');
        System.assert(productPrice[0].Product_Owner__c  == testUser.Id);
        System.assertEquals('1000', productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true, productPrice[0].Map_Pricing_OR__c);
        
        Test.startTest();
        Database.DeleteResult result = Database.delete(testProduct, false);
        Test.stopTest();

        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        
        productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assert(productPrice.size() == 1);
        System.assert(productPrice[0].Product_Center__c == null);
        System.assert(productPrice[0].Product_Series__c == null);
        System.assert(productPrice[0].Product_Owner__c  == null);
        System.assertEquals(null, productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(false, productPrice[0].Map_Pricing_OR__c);
    }
    
    
    // there are multiple products for multiple product prices, the product that is connected is deleted, and the product prices are updated to another product
    @isTest static void testDeleteComplex1() {
        
  		// setup test users
        User testUser1 = ProductPricesTestDataFactory.createTestUser('test1', 'user');
        User testUser2 = ProductPricesTestDataFactory.createTestUser('test2', 'user');
        User testUser3 = ProductPricesTestDataFactory.createTestUser('test3', 'user');
        
        // setup test prices	
        List<ProductPrices__c> testProductPrices = new List<ProductPrices__c>();
        ProductPrices__c testProductPriceNEO1 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
		testProductPrices.add(testProductPriceNEO1);     
        ProductPrices__c testProductPriceNEO2 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-08', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=112.4815, 	Price_USD_Sample_Size_50__c = 101.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,8) );
		testProductPrices.add(testProductPriceNEO2);     
        ProductPrices__c testProductPriceNEO3 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-04-02', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 145.0000, Price_USD_Sample_Size_10__c=111.4815, 	Price_USD_Sample_Size_50__c = 101.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 80.2145, 	Price_USD_Sample_Size_500__c=81.5781, Price_USD_Sample_Size_1000__c = 75.2294, Valid_From__c = Date.newInstance( 2020,4,2) );
		testProductPrices.add(testProductPriceNEO3);     
        
        ProductPrices__c testProductPriceMAX1 = new ProductPrices__c(Name = 'MAX-8C-0-2020-01-09', Product_Name__c= 'MAX-8C', Ordering_Number__c='MAX-8C-0', Price_USD_Sample_Size_1__c = 10.0000, Price_USD_Sample_Size_10__c=9.4815, 	Price_USD_Sample_Size_50__c = 8.1390, Price_USD_Sample_Size_100__c= 7.6890, Price_USD_Sample_Size_250__c= 6.2145, 	Price_USD_Sample_Size_500__c=6.5781, Price_USD_Sample_Size_1000__c = 5.2294, Valid_From__c = Date.newInstance( 2020,1,9) );
		testProductPrices.add(testProductPriceMAX1);
        ProductPrices__c testProductPriceMAX2 = new ProductPrices__c(Name = 'MAX-8C-0-2020-04-02', Product_Name__c= 'MAX-8C', Ordering_Number__c='MAX-8C-0', Price_USD_Sample_Size_1__c = 10.0000, Price_USD_Sample_Size_10__c=9.4815, 	Price_USD_Sample_Size_50__c = 8.1390, Price_USD_Sample_Size_100__c= 7.6890, Price_USD_Sample_Size_250__c= 6.2145, 	Price_USD_Sample_Size_500__c=6.5781, Price_USD_Sample_Size_1000__c = 5.2294, Valid_From__c = Date.newInstance( 2020,4,2) );
		testProductPrices.add(testProductPriceMAX2);    
        
        insert testProductPrices;
        
        // setup test products
        List<Product2> testProducts = new List<Product2>();
        Product2 testProductNeo1 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-00', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Status__c='Prototypes', Product_Owner__c = testUser1.Id, Map_Pricing__c = true, max_MAP_pricing__c = '1000');
        testProducts.add(testProductNeo1);
        Product2 testProductNeo2 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-10', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LISA-C2', Product_Status__c='Mass Production', Product_Owner__c = testUser2.Id, Map_Pricing__c = false, max_MAP_pricing__c = '250');  // this is the product that should be connected to the NEO prices
        testProducts.add(testProductNeo2);
        Product2 testProductNeo3 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='ALEX-R5', Product_Status__c='Engineering Samples', Product_Owner__c = testUser1.Id, Map_Pricing__c = true, max_MAP_pricing__c = '500'); 
        testProducts.add(testProductNeo3);
        
        Product2 testProductMAX1 = new Product2(Name = 'MAX-8', Type_No__c= 'MAX-8-0-0', ProductCode= 'MAX-8-0', Product_Center__c = 'Short Range', Product_Series__c='EMMY-W1', Product_Status__c='Prototypes', Product_Owner__c = testUser3.Id, Map_Pricing__c = true, max_MAP_pricing__c = '25'); // this is the product that should be connected to the MAX prices
        testProducts.add(testProductMAX1);

        insert testProducts;
        
        
        //Check setup was completed correctly
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPriceNEO1.Id];
        System.AssertEquals(1, productPrice.size());
        System.AssertEquals('Cellular', productPrice[0].Product_Center__c);
        System.AssertEquals('LISA-C2', productPrice[0].Product_Series__c);
        System.AssertEquals(testUser2.Id, productPrice[0].Product_Owner__c );
        System.assertEquals('250', productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true, productPrice[0].Map_Pricing_OR__c);
        
        Test.startTest();
        Database.DeleteResult result = Database.delete(testProductNeo2, false);  // delete the connected Product
        Test.stopTest();

        System.assert(result.isSuccess());
        System.AssertEquals(0, result.getErrors().size());
        
        // the product price should be connected to another product
        productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPriceNEO1.Id];
        System.AssertEquals(1, productPrice.size());
        System.AssertEquals('Cellular', productPrice[0].Product_Center__c);
        System.AssertEquals('ALEX-R5', productPrice[0].Product_Series__c);
        System.AssertEquals(testUser1.Id, productPrice[0].Product_Owner__c );
        System.assertEquals('500', productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true, productPrice[0].Map_Pricing_OR__c);
    }
    
        
    // there are multiple products for multiple product prices, the product that is not connected is deleted, and the product prices are updated to another product
    @isTest static void testDeleteComplex2() {
        // setup test users
        User testUser1 = ProductPricesTestDataFactory.createTestUser('test1', 'user');
        User testUser2 = ProductPricesTestDataFactory.createTestUser('test2', 'user');
        User testUser3 = ProductPricesTestDataFactory.createTestUser('test3', 'user');
        
        // setup test prices	
        List<ProductPrices__c> testProductPrices = new List<ProductPrices__c>();
        ProductPrices__c testProductPriceNEO1 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
		testProductPrices.add(testProductPriceNEO1);     
        ProductPrices__c testProductPriceNEO2 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-08', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=112.4815, 	Price_USD_Sample_Size_50__c = 101.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,8) );
		testProductPrices.add(testProductPriceNEO2);     
        ProductPrices__c testProductPriceNEO3 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-04-02', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 145.0000, Price_USD_Sample_Size_10__c=111.4815, 	Price_USD_Sample_Size_50__c = 101.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 80.2145, 	Price_USD_Sample_Size_500__c=81.5781, Price_USD_Sample_Size_1000__c = 75.2294, Valid_From__c = Date.newInstance( 2020,4,2) );
		testProductPrices.add(testProductPriceNEO3);     
        
        ProductPrices__c testProductPriceMAX1 = new ProductPrices__c(Name = 'MAX-8C-0-2020-01-09', Product_Name__c= 'MAX-8C', Ordering_Number__c='MAX-8C-0', Price_USD_Sample_Size_1__c = 10.0000, Price_USD_Sample_Size_10__c=9.4815, 	Price_USD_Sample_Size_50__c = 8.1390, Price_USD_Sample_Size_100__c= 7.6890, Price_USD_Sample_Size_250__c= 6.2145, 	Price_USD_Sample_Size_500__c=6.5781, Price_USD_Sample_Size_1000__c = 5.2294, Valid_From__c = Date.newInstance( 2020,1,9) );
		testProductPrices.add(testProductPriceMAX1);
        ProductPrices__c testProductPriceMAX2 = new ProductPrices__c(Name = 'MAX-8C-0-2020-04-02', Product_Name__c= 'MAX-8C', Ordering_Number__c='MAX-8C-0', Price_USD_Sample_Size_1__c = 10.0000, Price_USD_Sample_Size_10__c=9.4815, 	Price_USD_Sample_Size_50__c = 8.1390, Price_USD_Sample_Size_100__c= 7.6890, Price_USD_Sample_Size_250__c= 6.2145, 	Price_USD_Sample_Size_500__c=6.5781, Price_USD_Sample_Size_1000__c = 5.2294, Valid_From__c = Date.newInstance( 2020,4,2) );
		testProductPrices.add(testProductPriceMAX2);    
        
        insert testProductPrices;
        
        // setup test products
        List<Product2> testProducts = new List<Product2>();
        Product2 testProductNeo1 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-00', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Status__c='Prototypes', Product_Owner__c = testUser1.Id,  Map_Pricing__c = false, max_MAP_pricing__c = '1000');
        testProducts.add(testProductNeo1);
        Product2 testProductNeo2 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-10', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LISA-C2', Product_Status__c='Mass Production', Product_Owner__c = testUser2.Id,  Map_Pricing__c = false, max_MAP_pricing__c = '1000');  // this is the product that should be connected to the NEO prices
        testProducts.add(testProductNeo2);
        Product2 testProductNeo3 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='ALEX-R5', Product_Status__c='Engineering Samples', Product_Owner__c = testUser1.Id,  Map_Pricing__c = true, max_MAP_pricing__c = '1000'); 
        testProducts.add(testProductNeo3);
        
        Product2 testProductMAX1 = new Product2(Name = 'MAX-8', Type_No__c= 'MAX-8-0-0', ProductCode= 'MAX-8-0', Product_Center__c = 'Short Range', Product_Series__c='EMMY-W1', Product_Status__c='Prototypes', Product_Owner__c = testUser3.Id); // this is the product that should be connected to the MAX prices
        testProducts.add(testProductMAX1);

        insert testProducts;
        
        
        //Check setup was completed correctly
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPriceNEO1.Id];
        System.AssertEquals(1, productPrice.size());
        System.AssertEquals('Cellular', productPrice[0].Product_Center__c);
        System.AssertEquals('LISA-C2', productPrice[0].Product_Series__c);
        System.AssertEquals(testUser2.Id, productPrice[0].Product_Owner__c );
        System.assertEquals('1000', productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true, productPrice[0].Map_Pricing_OR__c);
        
        Test.startTest();
        Database.DeleteResult result = Database.delete(testProductNeo3, false);  // delete a non connected Product
        Test.stopTest();

        System.assert(result.isSuccess());
        System.AssertEquals(0, result.getErrors().size());
        
        // the product price should still be connected to the same product
        productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPriceNEO1.Id];
        System.AssertEquals(1, productPrice.size());
        System.AssertEquals('Cellular', productPrice[0].Product_Center__c);
        System.AssertEquals('LISA-C2', productPrice[0].Product_Series__c);
        System.AssertEquals(testUser2.Id, productPrice[0].Product_Owner__c );
        System.assertEquals('1000', productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(false, productPrice[0].Map_Pricing_OR__c);
    }
    
}
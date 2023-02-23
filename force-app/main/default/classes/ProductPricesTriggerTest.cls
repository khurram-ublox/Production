@isTest
public class ProductPricesTriggerTest {
    
    // ------------ inserting ---------------------------------------------------------------------------------------------------------------
    
    // if a product is created without a price present it should not cause any issues
    @isTest static void testInsertingAProductPriceWithoutAProduct() {
      
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
     
        Test.startTest();
        Database.SaveResult result = Database.insert(testProductPrice, false);
        Test.stopTest();

         //system.debug(result.isSuccess());
        //system.debug(result.getErrors());
        //system.debug(result.getErrors()[0].getMessage());
        System.assert(result.isSuccess());
        System.assertEquals(0, result.getErrors().size());
	}
    
    // if a product is created without a price present it should not cause any issues
    @isTest static void testInsertingAProductPriceWithAProduct() {
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
      
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2',  Product_Owner__c = testUser.Id);
        insert testProduct;
          
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
          
        Test.startTest();
        Database.SaveResult result = Database.insert(testProductPrice, false);
        Test.stopTest();

        System.assert(result.isSuccess());
        System.assertEquals(0, result.getErrors().size());
        
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assertEquals(1, productPrice.size());
        System.assertEquals('Cellular', productPrice[0].Product_Center__c);
        System.assertEquals('LARA-R2', productPrice[0].Product_Series__c );
        System.assertEquals(testUser.Id, productPrice[0].Product_Owner__c);
        System.assertEquals(true, productPrice[0].is_most_recent__c);
        
        System.assertEquals(null, productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(false, productPrice[0].Map_Pricing_OR__c);        
    }
    
    
    // if a product is created without multiple prices present it should not cause any issues
    @isTest static void testInsertingComplex1() {
      
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
        
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id, Map_Pricing__c = true, max_MAP_pricing__c = '100');
        insert testProduct;
        
        List<ProductPrices__c> testProductPrices = new List<ProductPrices__c>();
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2',  Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        testProductPrices.add(testProductPrice);
        ProductPrices__c testProductPrice2 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-08', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 148.0000, Price_USD_Sample_Size_10__c=104.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,8) );
        testProductPrices.add(testProductPrice2);
        ProductPrices__c testProductPrice3 = new ProductPrices__c(Name = 'NEO-M8P-2-2019-02-03', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        testProductPrices.add(testProductPrice3);
        
        ProductPrices__c testProductPrice_other = new ProductPrices__c(Name = 'MAX-8C-2019-02-03', Product_Name__c= 'MAX-8C', Ordering_Number__c='MAX-8C-0', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        testProductPrices.add(testProductPrice_other);
        
        
        Test.startTest();
        Database.SaveResult[] results = Database.insert(testProductPrices, false);
        Test.stopTest();
		
        for (Database.SaveResult sr : results) 
        {
            System.assert(sr.isSuccess());
            System.assertEquals(0, sr.getErrors().size());
        }
        
        // All three prices for NEO-M8P-2 should have been updated
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assertEquals(1, productPrice.size());
        System.assertEquals('Cellular',  productPrice[0].Product_Center__c);
        System.assertEquals('LARA-R2',   productPrice[0].Product_Series__c );
        System.assertEquals(testUser.Id, productPrice[0].Product_Owner__c);
        System.assertEquals(true,        productPrice[0].is_most_recent__c);
        System.assertEquals('100',       productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true,        productPrice[0].Map_Pricing_OR__c);
        
        List<ProductPrices__c> productPrice2 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice2.Id];
        System.assertEquals(1, productPrice2.size());
        System.assertEquals('Cellular',  productPrice2[0].Product_Center__c);
        System.assertEquals('LARA-R2',   productPrice2[0].Product_Series__c );
        System.assertEquals(testUser.Id, productPrice2[0].Product_Owner__c);
        System.assertEquals(false,       productPrice2[0].is_most_recent__c);
        System.assertEquals('100',       productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true,        productPrice[0].Map_Pricing_OR__c);
        
        List<ProductPrices__c> productPrice3 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice3.Id];       
        System.assertEquals(1, productPrice3.size());
        System.assertEquals('Cellular',  productPrice3[0].Product_Center__c);
        System.assertEquals('LARA-R2',   productPrice3[0].Product_Series__c );
        System.assertEquals(testUser.Id, productPrice3[0].Product_Owner__c);
        System.assertEquals(false,       productPrice3[0].is_most_recent__c);
        System.assertEquals('100',       productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true,        productPrice[0].Map_Pricing_OR__c);
        
        // The price for MAX-8C should not have been updated, but should be most recent
        List<ProductPrices__c> productPrice_other = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c, Max_MAP_Pricing_Min__c, Map_Pricing_OR__c FROM ProductPrices__c WHERE Id = :testProductPrice_other.Id];
        System.assertEquals(1, productPrice_other.size());
        System.assertNotEquals('Cellular',  productPrice_other[0].Product_Center__c);
        System.assertNotEquals('LARA-R2',   productPrice_other[0].Product_Series__c );
        System.assertNotEquals(testUser.Id, productPrice_other[0].Product_Owner__c);
        System.assertEquals(true,           productPrice_other[0].is_most_recent__c);
        System.assertEquals('100',          productPrice[0].Max_MAP_Pricing_Min__c);
        System.assertEquals(true,           productPrice[0].Map_Pricing_OR__c);
    }
    
     // ------------ updating ---------------------------------------------------------------------------------------------------------------
     
    
     // update a price on a ProductPrice that is not the most recent, should not make it the most recent
     @isTest static void testUpdatingPrices1() {
        
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
        
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id,  Map_Pricing__c = true, max_MAP_pricing__c = '25');
        insert testProduct;
        
        List<ProductPrices__c> testProductPrices = new List<ProductPrices__c>();
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2',  Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        testProductPrices.add(testProductPrice);
        ProductPrices__c testProductPrice2 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-08', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 148.0000, Price_USD_Sample_Size_10__c=104.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,8) );
        testProductPrices.add(testProductPrice2);
        ProductPrices__c testProductPrice3 = new ProductPrices__c(Name = 'NEO-M8P-2-2019-02-03', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        testProductPrices.add(testProductPrice3);
        
        ProductPrices__c testProductPrice_other = new ProductPrices__c(Name = 'MAX-8C-2019-02-03', Product_Name__c= 'MAX-8C', Ordering_Number__c='MAX-8C-0', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        testProductPrices.add(testProductPrice_other);
        
        insert testProductPrices;
         
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assertEquals(1, productPrice.size());
        System.assertEquals(true,        productPrice[0].is_most_recent__c);
        
        List<ProductPrices__c> productPrice2 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice2.Id];
        System.assertEquals(1, productPrice2.size());
        System.assertEquals(false,       productPrice2[0].is_most_recent__c);
         
        List<ProductPrices__c> productPrice3 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice3.Id];       
        System.assertEquals(1, productPrice3.size());
        System.assertEquals(false,       productPrice3[0].is_most_recent__c);
         
        testProductPrice2.Price_USD_Sample_Size_1__c = 142.0000;
               
        Test.startTest();
        Database.SaveResult result = Database.update(testProductPrice2, false);
        Test.stopTest();
		    
        System.assert(result.isSuccess());
        System.assertEquals(0, result.getErrors().size());
        
        
		// the values for most recent should not have changed
        productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assertEquals(1, productPrice.size());
        System.assertEquals(true, productPrice[0].is_most_recent__c);
        
        productPrice2 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice2.Id];
        System.assertEquals(1, productPrice2.size());
        System.assertEquals(false, productPrice2[0].is_most_recent__c);
        
        productPrice3 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice3.Id];       
        System.assertEquals(1, productPrice3.size());
        System.assertEquals(false, productPrice3[0].is_most_recent__c);
    }
    
     // update valid from on a ProductPrice and making it the most recent
     @isTest static void testUpdatingPrices2() {
        
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
        
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id, Map_Pricing__c = true, max_MAP_pricing__c = '25');
        insert testProduct;
        
        List<ProductPrices__c> testProductPrices = new List<ProductPrices__c>();
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2',  Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        testProductPrices.add(testProductPrice);
        ProductPrices__c testProductPrice2 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-08', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 148.0000, Price_USD_Sample_Size_10__c=104.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,8) );
        testProductPrices.add(testProductPrice2);
        ProductPrices__c testProductPrice3 = new ProductPrices__c(Name = 'NEO-M8P-2-2019-02-03', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        testProductPrices.add(testProductPrice3);
        
        ProductPrices__c testProductPrice_other = new ProductPrices__c(Name = 'MAX-8C-2019-02-03', Product_Name__c= 'MAX-8C', Ordering_Number__c='MAX-8C-0', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        testProductPrices.add(testProductPrice_other);
        
        insert testProductPrices;
         
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assertEquals(1, productPrice.size());
        System.assertEquals(true,        productPrice[0].is_most_recent__c);
        
        List<ProductPrices__c> productPrice2 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice2.Id];
        System.assertEquals(1, productPrice2.size());
        System.assertEquals(false,       productPrice2[0].is_most_recent__c);
         
        List<ProductPrices__c> productPrice3 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice3.Id];       
        System.assertEquals(1, productPrice3.size());
        System.assertEquals(false,       productPrice3[0].is_most_recent__c);
         
        testProductPrice2.Valid_From__c = Date.newInstance( 2021,1,8);
               
        Test.startTest();
        Database.SaveResult result = Database.update(testProductPrice2, false);
        Test.stopTest();
		    
        System.assert(result.isSuccess());
        System.assertEquals(0, result.getErrors().size());
        
        
		// the values for most recent should change and make productPrice2 the most recent one
        productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assertEquals(1, productPrice.size());
        System.assertEquals(false, productPrice[0].is_most_recent__c);
        
        productPrice2 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice2.Id];
        System.assertEquals(1, productPrice2.size());
        System.assertEquals(true, productPrice2[0].is_most_recent__c);
        
        productPrice3 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice3.Id];       
        System.assertEquals(1, productPrice3.size());
        System.assertEquals(false, productPrice3[0].is_most_recent__c);
    }
    
    
     // ------------ deleting ---------------------------------------------------------------------------------------------------------------
     
     // delete a price that is not the most recent should not change anything
     @isTest static void testDeletePrices1() {
        
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
        
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id, Map_Pricing__c = true, max_MAP_pricing__c = '25');
        insert testProduct;
        
        List<ProductPrices__c> testProductPrices = new List<ProductPrices__c>();
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2',  Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        testProductPrices.add(testProductPrice);
        ProductPrices__c testProductPrice2 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-08', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 148.0000, Price_USD_Sample_Size_10__c=104.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,8) );
        testProductPrices.add(testProductPrice2);
        ProductPrices__c testProductPrice3 = new ProductPrices__c(Name = 'NEO-M8P-2-2019-02-03', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        testProductPrices.add(testProductPrice3);
        
        ProductPrices__c testProductPrice_other = new ProductPrices__c(Name = 'MAX-8C-2019-02-03', Product_Name__c= 'MAX-8C', Ordering_Number__c='MAX-8C-0', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        testProductPrices.add(testProductPrice_other);
        
        insert testProductPrices;
         
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assertEquals(1, productPrice.size());
        System.assertEquals(true,        productPrice[0].is_most_recent__c);
        
        List<ProductPrices__c> productPrice2 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice2.Id];
        System.assertEquals(1, productPrice2.size());
        System.assertEquals(false,       productPrice2[0].is_most_recent__c);
         
        List<ProductPrices__c> productPrice3 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice3.Id];       
        System.assertEquals(1, productPrice3.size());
        System.assertEquals(false,       productPrice3[0].is_most_recent__c);
         
       
               
        Test.startTest();
        Database.DeleteResult result = Database.delete(testProductPrice2, false);
        Test.stopTest();
		    
        System.assert(result.isSuccess());
        System.assertEquals(0, result.getErrors().size());
        
        
		// the values for most recent should not change and productPrice should still be the most recent price
        productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assertEquals(1, productPrice.size());
        System.assertEquals(true, productPrice[0].is_most_recent__c);
        
        productPrice2 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice2.Id];
        System.assertEquals(0, productPrice2.size());

        productPrice3 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice3.Id];       
        System.assertEquals(1, productPrice3.size());
        System.assertEquals(false, productPrice3[0].is_most_recent__c);
    }
    
     // delete the most recent price should make another price the most recent
     @isTest static void testDeletePrices2() {
        // --- setup user --------------
        User testUser = ProductPricesTestDataFactory.createTestUser('test', 'user');
         
        // --- setup product --------------
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Product_Center__c = 'Cellular', Product_Series__c='LARA-R2', Product_Owner__c = testUser.Id, Map_Pricing__c = true, max_MAP_pricing__c = '25');
        insert testProduct;
        
        // --- setup prices --------------
        List<ProductPrices__c> testProductPrices = new List<ProductPrices__c>();
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2',  Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000, Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        testProductPrices.add(testProductPrice);
        ProductPrices__c testProductPrice2 = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-08', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 148.0000, Price_USD_Sample_Size_10__c=104.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,8) );
        testProductPrices.add(testProductPrice2);
        ProductPrices__c testProductPrice3 = new ProductPrices__c(Name = 'NEO-M8P-2-2019-02-03', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        testProductPrices.add(testProductPrice3);
        
        ProductPrices__c testProductPrice_other = new ProductPrices__c(Name = 'MAX-8C-2019-02-03', Product_Name__c= 'MAX-8C', Ordering_Number__c='MAX-8C-0', Price_USD_Sample_Size_1__c = 147.0000, Price_USD_Sample_Size_10__c=104.4115, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2019,2,3) );
        testProductPrices.add(testProductPrice_other);
        
        insert testProductPrices;
         
        // --- check if prices were initialized correctly --------------
        List<ProductPrices__c> productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assertEquals(1, productPrice.size());
        System.assertEquals(true,productPrice[0].is_most_recent__c);
        
        List<ProductPrices__c> productPrice2 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice2.Id];
        System.assertEquals(1, productPrice2.size());
        System.assertEquals(false, productPrice2[0].is_most_recent__c);
         
        List<ProductPrices__c> productPrice3 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice3.Id];       
        System.assertEquals(1, productPrice3.size());
        System.assertEquals(false, productPrice3[0].is_most_recent__c);
         
        
        // --- actual test --------------
        Test.startTest();
        Database.DeleteResult result = Database.delete(testProductPrice, false);
        Test.stopTest();
         
		// --- verify results --------------   
        System.assert(result.isSuccess());
        System.assertEquals(0, result.getErrors().size());
          
		// the values for most recent should change and make productPrice2 the most recent one
        productPrice = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice.Id];
        System.assertEquals(0, productPrice.size());

        productPrice2 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice2.Id];
        System.assertEquals(1, productPrice2.size());
        System.assertEquals(true, productPrice2[0].is_most_recent__c); 

        productPrice3 = [SELECT Id, Product_Center__c, Product_Series__c, Product_Owner__c, is_most_recent__c FROM ProductPrices__c WHERE Id = :testProductPrice3.Id];       
        System.assertEquals(1, productPrice3.size());
        System.assertEquals(false, productPrice3[0].is_most_recent__c);
    }

}
@isTest
public class ProductPricesAbacusCtrlTest {
    
	@testSetup static void setup() {
        ProductPricesTestDataFactory.setupConversionRates();
    }
   
    // init should not throw an error
	@isTest static void testInit() {
      new ProductPricesAbacusCtrl();
	}
    
    //------------------------- getProductsPricesByProductId ----------------------------------------------------------------

	// an unkown Id should return empty list
	@isTest static void testGetProductsPricesByProductIdUnkownId() {
      
      List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getProductsPricesByProductId('5003000000D8cuI');
      System.assertNotEquals(null, productPrices);
      System.assertEquals(0, productPrices.size());
	}
    
    // known id should return a product price 
    @isTest static void testGetProductsPricesByProductIdKownId() {
      Id testProductId = ProductPricesTestDataFactory.createProduct()[0].id;
      ProductPricesTestDataFactory.createProductPrice();
      
      List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getProductsPricesByProductId(testProductId);
      System.assertNotEquals(null, productPrices);
      System.assertEquals(1, productPrices.size());
	}
    
    // known id should return all product prices
    @isTest static void testGetProductsPricesByProductIdKownIdwithMultiplePrices() {
      Id testProductId = ProductPricesTestDataFactory.createProduct()[0].id;
      ProductPricesTestDataFactory.createProductPrices();
      
      List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getProductsPricesByProductId(testProductId);
      System.assertNotEquals(null, productPrices);
      System.assertEquals(6, productPrices.size());
	}
    
    // known id should return all product prices
    @isTest static void testGetProductsPricesByProductIdKownIdwithMultiplePricesMax() {
      Id testProductId = ProductPricesTestDataFactory.createProduct()[0].id;
      ProductPricesTestDataFactory.createProductPricesMax();
      
      List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getProductsPricesByProductId(testProductId);
      System.assertNotEquals(null, productPrices);
      System.assertEquals(6, productPrices.size());
	}
    
    
    //------------------------- getProductsPricesByProductCode ----------------------------------------------------------------
    
    // an unkown code should return empty list
	@isTest static void testGetProductsPricesByProductCodeUnkownCode() {
      
      List<ProductPrices__c> productPrices = ProductPricesAbacusCtrl.getProductsPricesByProductCode('does-not-exist');
      System.assertNotEquals(null, productPrices);
      System.assertEquals(0, productPrices.size());
	}
    
    // an kown code should a product price
	@isTest static void testGetProductsPricesByProductCodeKownCode() {
      ProductPricesTestDataFactory.createProductPrice();
        
      List<ProductPrices__c> productPrices = ProductPricesAbacusCtrl.getProductsPricesByProductCode('NEO-M8P-2');
      System.assertNotEquals(null, productPrices);
      System.assertEquals(1, productPrices.size());
	}
    
    // an kown code should all product prices
	@isTest static void testGetProductsPricesByProductCodeKownCodeMultiple() {
      ProductPricesTestDataFactory.createProductPrices();
        
      List<ProductPrices__c> productPrices = ProductPricesAbacusCtrl.getProductsPricesByProductCode('NEO-M8P-2');
      System.assertNotEquals(null, productPrices);
      System.assertEquals(6, productPrices.size());
	}
    
    // an kown code should all product prices, for many prices
	@isTest static void testGetProductsPricesByProductCodeKownCodeMax() {
      ProductPricesTestDataFactory.createProductPricesmax();
        
      List<ProductPrices__c> productPrices = ProductPricesAbacusCtrl.getProductsPricesByProductCode('NEO-M8P-2');
      System.assertNotEquals(null, productPrices);
      System.assertEquals(6, productPrices.size());
	}
    
    
    //------------------------- getMapProductsPrices ----------------------------------------------------------------
       
    // get all MapPrices without test data should return an empty list
	@isTest static void testGetMapProductsPricesAllPricesAndNoTestData() {
      
      List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getMapProductsPrices(null);
      System.assertNotEquals(null, productPrices);
      System.assertEquals(0, productPrices.size());
	}
    
    // get MapPrices for an non-existing product Id without test data should return an empty list
	@isTest static void testGetMapProductsPricesNonexistingIdAndNoTestData() {
      
      List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getMapProductsPrices('5003000000D8cuI');
      System.assertNotEquals(null, productPrices);
      System.assertEquals(0, productPrices.size());
	}
    
    
    // get all MapPrices without with a single product price should return it
	@isTest static void testGetMapProductsPricesAllPricesWithData1() {
      Id testProductId = ProductPricesTestDataFactory.createProduct()[0].id;
      ProductPricesTestDataFactory.createProductPrice();
      
      List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getMapProductsPrices(null);
      System.assertNotEquals(null, productPrices);
      System.assertEquals(1, productPrices.size());
      System.assertEquals('NEO-M8P-2-2020-01-09', productPrices[0].name);
	}
    
    
    // get all MapPrices without with a multiple product prices of a single Product should return the most recent one
	@isTest static void testGetMapProductsPricesAllPricesWithData2() {
      Id testProductId = ProductPricesTestDataFactory.createProduct()[0].id;
      ProductPricesTestDataFactory.createProductPrices();
      
      List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getMapProductsPrices(null);
      System.assertNotEquals(null, productPrices);
      System.assertEquals(1, productPrices.size());
      System.assertEquals('NEO-M8P-2-2020-01-20', productPrices[0].name);
	}
    
    // max prices and products
	@isTest static void testGetMapProductsPricesAllPricesWithDataMax() {
      List<Product2> testProducts = ProductPricesTestDataFactory.createProductsMax();
      List<ProductPrices__c> testProductPrices = ProductPricesTestDataFactory.createProductPricesMax();
      
      Product2 testProductEVKN200;
      Product2 testProductTOBYL220;
      Product2 testProductNEOM8P0;
       
      for (Product2 product :testProducts)
      {
          if(product.Type_No__c == 'EVK-N200-02B-00') {
          	testProductEVKN200 = product;
          }
          
          if(product.Type_No__c == 'TOBY-L220-02S-00') {
          	testProductTOBYL220 = product;
          }
          
          if(product.Type_No__c == 'NEO-M8P-0-11') {
          	testProductNEOM8P0 = product;
          }
      }
      
      List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getMapProductsPrices(null);
      System.assertNotEquals(null, productPrices);
     // System.assertEquals(8, productPrices.size());
      
      // Product EVK-N200 should have an id and the correct price should have been returned
      System.assertNotEquals(null, testProductEVKN200);
      List<MapProductPrices> productPricesEVKN200 = ProductPricesAbacusCtrl.getMapProductsPrices(testProductEVKN200.id);
      System.assertNotEquals(null, productPricesEVKN200);
      System.assertEquals(1, productPricesEVKN200.size());
      System.assertEquals(409.0000, productPricesEVKN200[0].priceSampleSize1);
      System.assertEquals('EVK-N200-02B-2020-01-11', productPricesEVKN200[0].Name);
      System.assertEquals(1, productPricesEVKN200[0].moq);  
      
      // Product TOBY-L220 should have an id and the correct price should have been returned
      System.assertNotEquals(null, testProductTOBYL220);
      List<MapProductPrices> productPricesTOBYL220= ProductPricesAbacusCtrl.getMapProductsPrices(testProductTOBYL220.id);
      System.assertNotEquals(null, productPricesTOBYL220);
      System.assertEquals(1, productPricesTOBYL220.size());
      System.assertEquals(115.2000, productPricesTOBYL220[0].priceSampleSize1);
      System.assertEquals(86.4000, productPricesTOBYL220[0].priceSampleSize10);
      System.assertEquals(69.0000, productPricesTOBYL220[0].priceSampleSize50);
      System.assertEquals(60.0000, productPricesTOBYL220[0].priceSampleSize100);
      System.assertEquals('TOBY-L220-02S-2020-01-09', productPricesTOBYL220[0].Name);
      System.assertEquals(150, productPricesTOBYL220[0].moq);
        
      // Product NEO-M8P-0 should have an id and the correct price should have been returned
      System.assertNotEquals(null, testProductNEOM8P0);
      List<MapProductPrices> productPricesNEOM8P0= ProductPricesAbacusCtrl.getMapProductsPrices(testProductNEOM8P0.id);
      System.assertNotEquals(null, productPricesNEOM8P0);
      System.assertEquals(1, productPricesNEOM8P0.size());
      System.assertEquals(149.0000, productPricesNEOM8P0[0].priceSampleSize1);
      System.assertEquals(99.5190, productPricesNEOM8P0[0].priceSampleSize10);
      System.assertEquals(90.5940, productPricesNEOM8P0[0].priceSampleSize50);
      System.assertEquals(82.3515, productPricesNEOM8P0[0].priceSampleSize100);
      System.assertEquals('NEO-M8P-0-2020-01-09', productPricesNEOM8P0[0].Name);
      System.assertEquals(250, productPricesNEOM8P0[0].moq);  
	}
    
    
    //------------------------- getProductsPrices ----------------------------------------------------------------
    
    // get product prices without test data should return an empty list
	@isTest static void testGetProductsPricesNoTestData() {
      
      List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getProductsPrices();
      System.assertNotEquals(null, productPrices);
      System.assertEquals(0, productPrices.size());
	}
    
    //
	@isTest static void testGetProductsPricesWithData1() {
      Id testProductId = ProductPricesTestDataFactory.createProduct()[0].id;
      ProductPricesTestDataFactory.createProductPrices();
        
      List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getProductsPrices();
      System.assertNotEquals(null, productPrices);
      System.assertEquals(6, productPrices.size());
      Boolean testPrice1Exisits = false;
      Boolean testPrice2Exisits = false;
      Boolean testPrice3Exisits = false;
      Boolean testPrice4Exisits = false;
      Boolean testPrice5Exisits = false;
      Boolean testPrice6Exisits = false;

      for (MapProductPrices pp :productPrices)
      {
          System.assertEquals(testProductId, pp.productId);
          if(pp.name == 'NEO-M8P-2-2020-01-09') 
          {
              testPrice1Exisits = true;
          }
          
          if(pp.name == 'NEO-M8P-2-2020-01-20') 
          {
              testPrice2Exisits = true;
          }
          
          if(pp.name == 'NEO-M8P-2-2020-01-07') 
          {
              testPrice3Exisits = true;
          }
          
          if(pp.name == 'NEO-M8P-2-2020-01-06') 
          {
              testPrice4Exisits = true;
          }
          
          if(pp.name == 'NEO-M8P-2-2020-01-05') 
          {
              testPrice5Exisits = true;
          }
          
          if(pp.name == 'NEO-M8P-2-2019-12-09') 
          {
              testPrice6Exisits = true;
          }
      }
      
       System.assertEquals(true, testPrice1Exisits);
       System.assertEquals(true, testPrice2Exisits);
       System.assertEquals(true, testPrice3Exisits);
       System.assertEquals(true, testPrice4Exisits);
       System.assertEquals(true, testPrice5Exisits);
       System.assertEquals(true, testPrice6Exisits);
	}
    
    // get product prices returns all product and price combinations
	@isTest static void testGetProductsPricesWithDataMax() {
      List<Product2> testProducts = ProductPricesTestDataFactory.createProductsMax();
      List<ProductPrices__c> testProductPrices = ProductPricesTestDataFactory.createProductPricesMax();
        
      List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getProductsPrices();
      System.assertNotEquals(null, productPrices);
      System.assertEquals(27, productPrices.size());
	}
    
    //------------------------- getProductsByProductPriceId ----------------------------------------------------------------
	
    // get product prices by Product Id without test data should return an empty list
	@isTest static void testGetProductsByProductPriceIdNoTestData() {
      
      List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getProductsByProductPriceId('5003000000D8cuI');
      System.assertNotEquals(null, productPrices);
      System.assertEquals(0, productPrices.size());
	}
    
    //
	@isTest static void testGetProductsByProductPriceIdWithData1() {
      Product2 testProduct = ProductPricesTestDataFactory.createProduct()[0];
      List<ProductPrices__c> testProductPrices = ProductPricesTestDataFactory.createProductPrices();
        
      List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getProductsByProductPriceId(testProductPrices[0].id);
      System.assertNotEquals(null, productPrices);
      System.assertEquals(1, productPrices.size());
      System.assertEquals(testProduct.id, productPrices[0].productId);
	}
    
    // get product prices returns all product and price combinations
	@isTest static void testGetProductsByProductPriceIdWithDataMax() {
      List<Product2> testProducts = ProductPricesTestDataFactory.createProductsMax();
      List<ProductPrices__c> testProductPrices = ProductPricesTestDataFactory.createProductPricesMax();
        
      ProductPrices__c testProductPriceEVKN200;
      ProductPrices__c testProductPriceTOBYL220;
      ProductPrices__c testProductPriceNEOM8P0;
       
      for (ProductPrices__c pp : testProductPrices)
      {
          if(pp.name == 'EVK-N200-02B-2020-01-09') {
          	testProductPriceEVKN200 = pp;
          }
          
          if(pp.name == 'TOBY-L220-02S-2019-12-05') {
          	testProductPriceTOBYL220 = pp;
          }
          
          if(pp.name == 'NEO-M8P-0-2020-01-09') {
          	testProductPriceNEOM8P0 = pp;
          }
      }
        
      List<MapProductPrices> productPricesEVKN200 = ProductPricesAbacusCtrl.getProductsByProductPriceId(testProductPriceEVKN200.id);
      System.assertNotEquals(null, productPricesEVKN200);
      System.assertEquals(1, productPricesEVKN200.size());
        
      List<MapProductPrices> productPricesTOBYL220 = ProductPricesAbacusCtrl.getProductsByProductPriceId(testProductPriceTOBYL220.id);
      System.assertNotEquals(null, productPricesTOBYL220);
      System.assertEquals(1, productPricesTOBYL220.size());
        
      List<MapProductPrices> productPricesNEOM8P0= ProductPricesAbacusCtrl.getProductsByProductPriceId(testProductPriceNEOM8P0.id);
      System.assertNotEquals(null, productPricesNEOM8P0);
      System.assertEquals(2, productPricesNEOM8P0.size());
	}
    
    //------------------------- getProductByProductId ----------------------------------------------------------------
	
    // get product prices by Product Id without test data should return null
	@isTest static void testGetProductByProductIdNoTestData() {
      
      Product2 product = ProductPricesAbacusCtrl.getProductByProductId('5003000000D8cuI');
      System.assertEquals(null, product);
	}
    
    // get product prices by Product Id should return it
	@isTest static void testGetProductByProductIdWithData1() {
      Product2 testProduct = ProductPricesTestDataFactory.createProduct()[0];
      ProductPricesTestDataFactory.createProductPrices();
        
      Product2 product = ProductPricesAbacusCtrl.getProductByProductId(testProduct.id);
      System.assertNotEquals(null, product);
      System.assertEquals(testProduct.name, product.name);
   	}
    
    // get product prices by Product Id should return it
	@isTest static void testGetProductByProductIdWithDataMax() {
      List<Product2> testProducts = ProductPricesTestDataFactory.createProductsMax();
      ProductPricesTestDataFactory.createProductPricesMax();
      
      for(Product2 testProduct: testProducts) {
          Product2 product = ProductPricesAbacusCtrl.getProductByProductId(testProduct.id);
          System.assertNotEquals(null, product);
          System.assertEquals(testProduct.name, product.name);
      }
   	}
    
    
    //------------------------- getProductPriceCalculatorDataByOppProdId ----------------------------------------------------------------
 
    // get product prices calculator data by OppProd Id without test data should return an empty list
	@isTest static void testGetProductPriceCalculatorDataByOppProdIdNoTestData() {        
      List<ProductPriceForCaclulator> productPrices = ProductPricesAbacusCtrl.getProductPriceCalculatorDataByOppProdId('5003000000D8cuI');
      System.assertNotEquals(null, productPrices);
      System.assertEquals(0, productPrices.size());
	}
    
    //get product prices calculator data by OppProd Id with one product, one price, one opportunity and one OppProd should return an one dataset
	@isTest static void testGetProductPriceCalculatorDataByOppProdIdWithData() {
      Product2 testProduct = ProductPricesTestDataFactory.createProduct()[0];
      List<ProductPrices__c> testProductsPrices = ProductPricesTestDataFactory.createProductPrice();
      Integer annualQuantity = 100;
      String currencyCode = 'USD';
      Opp_Product__c testOppProd = ProductPricesTestDataFactory.createOppProd(testProduct, annualQuantity, currencyCode);
        
      List<ProductPriceForCaclulator> productPrices = ProductPricesAbacusCtrl.getProductPriceCalculatorDataByOppProdId(testOppProd.id);
      System.assertNotEquals(null, productPrices);
      System.assertEquals(1, productPrices.size());
      System.assertEquals(annualQuantity, productPrices[0].amount);
      System.assertEquals(currencyCode, productPrices[0].priceCurrency);
      System.assertEquals(1, productPrices[0].priceMod);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_1__c, productPrices[0].priceSampleSize1);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_10__c, productPrices[0].priceSampleSize10);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_50__c, productPrices[0].priceSampleSize50);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_100__c, productPrices[0].priceSampleSize100);
	}
    
    //get product prices calculator data by OppProd Id without with one product, one price, one opportunity and one OppProd should return an one dataset, same test as testGetProductPriceCalculatorDataByOppProdIdWithData but for CHF
	@isTest static void testGetProductPriceCalculatorDataByOppProdIdWithDataCHF() {
      Product2 testProduct = ProductPricesTestDataFactory.createProduct()[0];
      List<ProductPrices__c> testProductsPrices = ProductPricesTestDataFactory.createProductPrice();
      Integer annualQuantity = 100;
      String currencyCode = 'CHF';
      Opp_Product__c testOppProd = ProductPricesTestDataFactory.createOppProd(testProduct, annualQuantity, currencyCode);
        
      List<ProductPriceForCaclulator> productPrices = ProductPricesAbacusCtrl.getProductPriceCalculatorDataByOppProdId(testOppProd.id);
      System.assertNotEquals(null, productPrices);
      System.assertEquals(1, productPrices.size());
      System.assertEquals(annualQuantity, productPrices[0].amount);
      System.assertEquals(currencyCode, productPrices[0].priceCurrency);
      System.assertEquals(0.990, productPrices[0].priceMod);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_1__c, productPrices[0].priceSampleSize1);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_10__c, productPrices[0].priceSampleSize10);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_50__c, productPrices[0].priceSampleSize50);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_100__c, productPrices[0].priceSampleSize100);
	}
    
    //get product prices calculator data by OppProd Id without with one product, one price, one opportunity and one OppProd should return an one dataset, same test as testGetProductPriceCalculatorDataByOppProdIdWithData but for JPY
	@isTest static void testGetProductPriceCalculatorDataByOppProdIdWithDataJPY() {
      Product2 testProduct = ProductPricesTestDataFactory.createProduct()[0];
      List<ProductPrices__c> testProductsPrices = ProductPricesTestDataFactory.createProductPrice();
      Integer annualQuantity = 100;
      String currencyCode = 'JPY';
      Opp_Product__c testOppProd = ProductPricesTestDataFactory.createOppProd(testProduct, annualQuantity, currencyCode);
        
      List<ProductPriceForCaclulator> productPrices = ProductPricesAbacusCtrl.getProductPriceCalculatorDataByOppProdId(testOppProd.id);
      System.assertNotEquals(null, productPrices);
      System.assertEquals(1, productPrices.size());
      System.assertEquals(annualQuantity, productPrices[0].amount);
      System.assertEquals(currencyCode, productPrices[0].priceCurrency);
      System.assertEquals(110.100, productPrices[0].priceMod);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_1__c, productPrices[0].priceSampleSize1);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_10__c, productPrices[0].priceSampleSize10);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_50__c, productPrices[0].priceSampleSize50);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_100__c, productPrices[0].priceSampleSize100);
	}
    
    //get product prices calculator data by OppProd Id without with one product, one price, one opportunity and one OppProd should return an one dataset, same test as testGetProductPriceCalculatorDataByOppProdIdWithData but for EUR
	@isTest static void testGetProductPriceCalculatorDataByOppProdIdWithDataEUR() {
      Product2 testProduct = ProductPricesTestDataFactory.createProduct()[0];
      List<ProductPrices__c> testProductsPrices = ProductPricesTestDataFactory.createProductPrice();
      Integer annualQuantity = 100;
      String currencyCode = 'EUR';
      Opp_Product__c testOppProd = ProductPricesTestDataFactory.createOppProd(testProduct, annualQuantity, currencyCode);
        
      List<ProductPriceForCaclulator> productPrices = ProductPricesAbacusCtrl.getProductPriceCalculatorDataByOppProdId(testOppProd.id);
      System.assertNotEquals(null, productPrices);
      System.assertEquals(1, productPrices.size());
      System.assertEquals(annualQuantity, productPrices[0].amount);
      System.assertEquals(currencyCode, productPrices[0].priceCurrency);
      System.assertEquals(0.880, productPrices[0].priceMod);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_1__c, productPrices[0].priceSampleSize1);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_10__c, productPrices[0].priceSampleSize10);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_50__c, productPrices[0].priceSampleSize50);
      System.assertEquals(testProductsPrices[0].Price_USD_Sample_Size_100__c, productPrices[0].priceSampleSize100);
	}
    
    @isTest static void testGetProductPriceCalculatorDataByOppProdIdWithDataMax() {
      List<Product2> testProducts = ProductPricesTestDataFactory.createProductsMax();
      List<ProductPrices__c> testProductsPrices = ProductPricesTestDataFactory.createProductPricesMax();
        
      Integer annualQuantity = 100;
      String currencyCode = 'EUR';
      
      Product2 testProduct;
      Product2 testProduct2;
      Product2 testProduct3;
      ProductPrices__c expectedTestPrice;
        
      for(Product2 tproduct: testProducts) {
          if(tproduct.Type_No__c == 'TOBY-L220-02S-00') {
              testProduct = tproduct;
          }
          
 		  if(tproduct.Type_No__c == 'ZOE-M8B-0-10') {
              testProduct2 = tproduct;
          }
                    
 		  if(tproduct.Type_No__c == 'TOBY-L220-62S-00') {
              testProduct3 = tproduct;
          }
      }
        
      Opp_Product__c testOppProd = ProductPricesTestDataFactory.createOppProd(testProduct, annualQuantity, currencyCode);
      Opp_Product__c testOppProd2 = ProductPricesTestDataFactory.createOppProd(testProduct2, annualQuantity, 'USD');
      Opp_Product__c testOppProd3 = ProductPricesTestDataFactory.createOppProd(testProduct3, annualQuantity, 'JPY');
      
      List<ProductPriceForCaclulator> productPrices = ProductPricesAbacusCtrl.getProductPriceCalculatorDataByOppProdId(testOppProd.id);
      System.assertNotEquals(null, productPrices);
      System.assertEquals(3, productPrices.size());
        
      List<ProductPriceForCaclulator> productPrices2 = ProductPricesAbacusCtrl.getProductPriceCalculatorDataByOppProdId(testOppProd2.id);
      System.assertNotEquals(null, productPrices2);
      System.assertEquals(0, productPrices2.size());
        
      List<ProductPriceForCaclulator> productPrices3 = ProductPricesAbacusCtrl.getProductPriceCalculatorDataByOppProdId(testOppProd3.id);
      System.assertNotEquals(null, productPrices3);
      System.assertEquals(1, productPrices3.size());
    }
    
    
    //------------------------- getAbacusProductsPricesByProductId ----------------------------------------------------------------
 
    // get abacus product prices by product Id without test data should return an empty list
	@isTest static void testGetAbacusProductsPricesByProductIdNoTestData() {        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices('5003000000D8cuI', false);
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(0, abacusProductPrices.size());
        
      abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices('5003000000D8cuI', true);
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(0, abacusProductPrices.size());
	}
    
    //get abacus product prices by product Id with one product, one price should return 21 datasets
    @isTest static void testGetAbacusProductsPricesByProductIdWithData() {
      Product2 testProduct = ProductPricesTestDataFactory.createProduct()[0];
      List<ProductPrices__c> testProductsPrices = ProductPricesTestDataFactory.createProductPrice();

      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(testProduct.id, false);
        

      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(12, abacusProductPrices.size());
      
      for(AbacusProductPrices abacusPrice: AbacusProductPrices)
      {
         System.assertEquals(testProduct.id, abacusPrice.productId);
      }
	}
    
    //get abacus product prices by product Id with one product with status obsolete, one price should not return data, but should return 21 with flag 'allProducts' set to true
    @isTest static void testGetAbacusProductsPricesByProductIdWithData2() {
      Product2 testProduct = ProductPricesTestDataFactory.createProductWithStatusObsolete()[0];
      List<ProductPrices__c> testProductsPrices = ProductPricesTestDataFactory.createProductPrice();

      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(testProduct.id, false);
        
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(0, abacusProductPrices.size());
      
      abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(testProduct.id, true);
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(12, abacusProductPrices.size());
      for(AbacusProductPrices abacusPrice: AbacusProductPrices)
      {
         System.assertEquals(testProduct.id, abacusPrice.productId);
      }
        
      abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(null, true);
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(12, abacusProductPrices.size());
      for(AbacusProductPrices abacusPrice: AbacusProductPrices)
      {
         System.assertEquals(testProduct.id, abacusPrice.productId);
      }
	}
    
    //get abacus product prices by product Id with one product, one product price set, one price is empty, should return 10 datasets
    @isTest static void testGetAbacusProductsPricesByProductIdWithData3() {
      Product2 testProduct = ProductPricesTestDataFactory.createProduct()[0];
      List<ProductPrices__c> testProductsPrices = ProductPricesTestDataFactory.createProductPriceWithOneEmptyPrice();

      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(testProduct.id, false);
        

      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(9, abacusProductPrices.size());
      
      for(AbacusProductPrices abacusPrice: AbacusProductPrices)
      {
         System.assertEquals(testProduct.id, abacusPrice.productId);
      }
	}
    
    //get abacus product prices by product Id with one product with status obsolete, one price should not return data, but should return 12 with flag 'allProducts' set to true
    @isTest static void testGetAbacusProductsPricesByProductIdWithDataMax() {
      List<Product2> testProducts = ProductPricesTestDataFactory.createProductsMax();
      List<ProductPrices__c> testProductsPrices = ProductPricesTestDataFactory.createProductPricesMax();
    
      Product2 testProduct;
      Product2 testProduct2;
      Product2 testProduct3;
      ProductPrices__c expectedTestPrice;
        
      for(Product2 tproduct: testProducts) {
          if(tproduct.Type_No__c == 'TOBY-L220-02S-00') {
              testProduct = tproduct;
          }
          
 		  if(tproduct.Type_No__c == 'ZOE-M8B-0-10') {
              testProduct2 = tproduct;
          }
                    
 		  if(tproduct.Type_No__c == 'EVK-N200-02B-00') {
              testProduct3 = tproduct;
          }
      }
	
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(testProduct.id, false);   
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(36, abacusProductPrices.size());
        
      abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(testProduct2.id, false);   
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(0, abacusProductPrices.size());
      
      abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(testProduct3.id, false);   
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(6, abacusProductPrices.size());
	}
    
        
    //------------------------- getAbacusProductsPrices ----------------------------------------------------------------
 
    // get abacus product prices without test data should return an empty list
	@isTest static void testGetAbacusProductsPricesNoTestData() {        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices('5003000000D8cuI', false);
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(0, abacusProductPrices.size());
        
      abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices('5003000000D8cuI', true);
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(0, abacusProductPrices.size());
      
      abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(null, true);
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(0, abacusProductPrices.size());
      
      abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(null, false);
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(0, abacusProductPrices.size());        
	}
    
    //get abacus product prices with one product, one price should return 21 datasets
    @isTest static void testGetAbacusProductsPricesWithData() {
      Product2 testProduct = ProductPricesTestDataFactory.createProduct()[0];
      List<ProductPrices__c> testProductsPrices = ProductPricesTestDataFactory.createProductPrice();

      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(testProduct.id, false);
        
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(12, abacusProductPrices.size());
      
      for(AbacusProductPrices abacusPrice: AbacusProductPrices)
      {
         System.assertEquals(testProduct.id, abacusPrice.productId);
      }
	}
    
    //get abacus product prices with one product with status obsolete, one price should not return data, but should return 21 with flag 'allProducts' set to true
    @isTest static void testGetAbacusProductsPricesWithData2() {
      Product2 testProduct = ProductPricesTestDataFactory.createProductWithStatusObsolete()[0];
      List<ProductPrices__c> testProductsPrices = ProductPricesTestDataFactory.createProductPrice();

      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(testProduct.id, false);
        
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(0, abacusProductPrices.size());
      
      abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(testProduct.id, true);
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(12, abacusProductPrices.size());
      for(AbacusProductPrices abacusPrice: AbacusProductPrices)
      {
         System.assertEquals(testProduct.id, abacusPrice.productId);
      }
        
      abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(null, true);
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(12, abacusProductPrices.size());
      for(AbacusProductPrices abacusPrice: AbacusProductPrices)
      {
         System.assertEquals(testProduct.id, abacusPrice.productId);
      }
	}
    
    //get abacus product prices with one product with status obsolete, one price should not return data, but should return 63 with flag 'allProducts' set to true
    @isTest static void testGetAbacusProductsPricesWithDataMax() {
      List<Product2> testProducts = ProductPricesTestDataFactory.createProductsMax();
      List<ProductPrices__c> testProductsPrices = ProductPricesTestDataFactory.createProductPricesMax();
    
      Product2 testProduct;
      Product2 testProduct2;
      Product2 testProduct3;
      ProductPrices__c expectedTestPrice;
        
      for(Product2 tproduct: testProducts) {
          if(tproduct.Type_No__c == 'TOBY-L220-02S-00') {
              testProduct = tproduct;
          }
          
 		  if(tproduct.Type_No__c == 'ZOE-M8B-0-10') {
              testProduct2 = tproduct;
          }
                    
 		  if(tproduct.Type_No__c == 'EVK-N200-02B-00') {
              testProduct3 = tproduct;
          }
      }
        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(testProduct.id, false);   
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(36, abacusProductPrices.size());
        
      abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(testProduct2.id, false);   
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(0, abacusProductPrices.size());
      
      abacusProductPrices = ProductPricesAbacusCtrl.getAbacusProductsPrices(testProduct3.id, false);   
      System.assertNotEquals(null, abacusProductPrices);
      System.assertEquals(6, abacusProductPrices.size());  // sold in webshop is true so it should return results
	}
    
    
    //------------------------- getProductByProductPrice ----------------------------------------------------------------
 
    // get product by product prices without test data should returns null
	@isTest static void testGetProductByProductPriceNoTestData() {        
     
      List<Product2> products = ProductPricesAbacusCtrl.getProductByProductPrice(null);
      System.assertEquals(null, products); 
	}
    
    //get product by product price with one product, one price should return the product
    @isTest static void testGetProductByProductPriceWithData() {
      Product2 testProduct = ProductPricesTestDataFactory.createProduct()[0];
      List<ProductPrices__c> testProductsPrices = ProductPricesTestDataFactory.createProductPrice();

      List<Product2> products = ProductPricesAbacusCtrl.getProductByProductPrice(testProductsPrices[0]);
        
      System.assertNotEquals(null, products);
      System.assertEquals(1, products.size());
      System.assertEquals(testProduct.id, products[0].id);
	}
    
    //get product by product price with multiple products, multiple price should return the product
    @isTest static void testGetProductByProductPriceWithDataMax() {
      List<Product2> testProducts = ProductPricesTestDataFactory.createProductsMax();
      List<ProductPrices__c> testProductsPrices = ProductPricesTestDataFactory.createProductPricesMax();

	  Product2 testProduct;
      ProductPrices__c testPrice;
      
      for(ProductPrices__c tPrice: testProductsPrices) {
          if(tPrice.Name == 'TOBY-L220-02S-2019-12-03') {
              testPrice = tPrice;
          }
      }
      System.assertNotEquals(null, testPrice);
        
      for(Product2 tproduct: testProducts) {
          if(tproduct.Type_No__c == 'TOBY-L220-02S-00') {
              testProduct = tproduct;
          }
      }
        
      List<Product2> products = ProductPricesAbacusCtrl.getProductByProductPrice(testPrice);
        
      System.assertNotEquals(null, products);
      System.assertEquals(1, products.size());
      System.assertEquals(testProduct.id, products[0].id);
	}
    
    
    //------------------------- abacusProductPriceFactoryList ----------------------------------------------------------------
 
    // get abacus products prices with empty imput should return an empty list
	@isTest static void testAbacusProductPriceFactoryListWithEmptyData() {        

      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(null, null, null, null, null);
      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(0, abacusProductPrices.size());
      
      MapProductPrices p = new MapProductPrices();
      abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(p, null, null, null, null);
      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(0, abacusProductPrices.size());
	}
    
    // get abacus product prices for moq 1
	@isTest static void testAbacusProductPriceFactoryListWithDataMoq1() {        

	  MapProductPrices p = new MapProductPrices();
      p.maxMapPricing = 1;
      p.priceSampleSize1 = 10;
        
      String priceCurrency = 'USD';
      Integer customerGroupNumber = 101;
        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(p, customerGroupNumber, priceCurrency, 1.0, 1000);
      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(1, abacusProductPrices.size());
      System.assertEquals(priceCurrency, abacusProductPrices[0].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[0].customerGroupNumber);
      System.assertEquals(p.priceSampleSize1, abacusProductPrices[0].seriesPrice);
      System.assertEquals(1, abacusProductPrices[0].seriesToAmount);          
	}
    
    // get abacus product prices for moq 3
	@isTest static void testAbacusProductPriceFactoryListWithDataMoq3() {        

	  MapProductPrices p = new MapProductPrices();
      p.maxMapPricing = 3;
      p.priceSampleSize1 = 10;
        
      String priceCurrency = 'USD';
      Integer customerGroupNumber = 101;
        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(p, customerGroupNumber, priceCurrency, 1.0, 1000);
      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(1, abacusProductPrices.size());
      System.assertEquals(priceCurrency, abacusProductPrices[0].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[0].customerGroupNumber);
      System.assertEquals(p.priceSampleSize1, abacusProductPrices[0].seriesPrice);
      System.assertEquals(2, abacusProductPrices[0].seriesToAmount);       
	}
    
    
    // get abacus product prices for moq 10
	@isTest static void testAbacusProductPriceFactoryListWithDataMoq10() {        

	  MapProductPrices p = new MapProductPrices();
      p.name = 'test-01';
      p.maxMapPricing = 10;
      p.priceSampleSize1 = 10;
      p.priceSampleSize10 = 20;
      p.priceSampleSize50 = 30;
      p.priceSampleSize100 = 40;
        
      String priceCurrency = 'USD';
      Integer customerGroupNumber = 101;
        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(p, customerGroupNumber, priceCurrency, 1.0, 1000);

      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(1, abacusProductPrices.size());
       
      System.assertEquals(priceCurrency, abacusProductPrices[0].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[0].customerGroupNumber);
      System.assertEquals(p.priceSampleSize1, abacusProductPrices[0].seriesPrice);
      System.assertEquals(9, abacusProductPrices[0].seriesToAmount); 
        /*
      System.assertEquals(priceCurrency, abacusProductPrices[1].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[1].customerGroupNumber);
      System.assertEquals(p.priceSampleSize10, abacusProductPrices[1].seriesPrice);
      System.assertEquals(49, abacusProductPrices[1].seriesToAmount); 
        
      System.assertEquals(priceCurrency, abacusProductPrices[2].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[2].customerGroupNumber);
      System.assertEquals(p.priceSampleSize50, abacusProductPrices[2].seriesPrice);
      System.assertEquals(99, abacusProductPrices[2].seriesToAmount); 
        
      System.assertEquals(priceCurrency, abacusProductPrices[3].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[3].customerGroupNumber);
      System.assertEquals(p.priceSampleSize100, abacusProductPrices[3].seriesPrice);
      System.assertEquals(2499, abacusProductPrices[3].seriesToAmount); */
	}
    
    // get abacus product prices for moq 10
	@isTest static void testAbacusProductPriceFactoryListWithDataMoq10_2() {        

	  MapProductPrices p = new MapProductPrices();
      p.name = 'test-01';
      p.maxMapPricing = 10;
      p.priceSampleSize1 = 10;
      p.priceSampleSize10 = 20;

      String priceCurrency = 'USD';
      Integer customerGroupNumber = 101;
        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(p, customerGroupNumber, priceCurrency, 1.0, 1000);

      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(1, abacusProductPrices.size());
       
      System.assertEquals(priceCurrency, abacusProductPrices[0].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[0].customerGroupNumber);
      System.assertEquals(p.priceSampleSize1, abacusProductPrices[0].seriesPrice);
      System.assertEquals(9, abacusProductPrices[0].seriesToAmount); 
      /*
      System.assertEquals(priceCurrency, abacusProductPrices[1].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[1].customerGroupNumber);
      System.assertEquals(p.priceSampleSize10, abacusProductPrices[1].seriesPrice);
      System.assertEquals(2499, abacusProductPrices[1].seriesToAmount);     */ 
	}
    
    // get abacus product prices for moq 11
    @isTest static void testAbacusProductPriceFactoryListWithDataMoq11() {   
      MapProductPrices p = new MapProductPrices();
      p.name = 'test-02';
      p.maxMapPricing = 11;
      p.priceSampleSize1 = 10;
      p.priceSampleSize10 = 20;
      p.priceSampleSize50 = 30;
      p.priceSampleSize100 = 40;
        
      String priceCurrency = 'USD';
      Integer customerGroupNumber = 101;
        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(p, customerGroupNumber, priceCurrency, 1.0, 1000);

      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(2, abacusProductPrices.size()); 
      
      System.assertEquals(priceCurrency, abacusProductPrices[0].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[0].customerGroupNumber);
      System.assertEquals(p.priceSampleSize1, abacusProductPrices[0].seriesPrice);
      System.assertEquals(9, abacusProductPrices[0].seriesToAmount); 
        
      System.assertEquals(priceCurrency, abacusProductPrices[1].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[1].customerGroupNumber);
      System.assertEquals(p.priceSampleSize10, abacusProductPrices[1].seriesPrice);
      System.assertEquals(10, abacusProductPrices[1].seriesToAmount); 
       
        /*
      System.assertEquals(priceCurrency, abacusProductPrices[2].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[2].customerGroupNumber);
      System.assertEquals(p.priceSampleSize50, abacusProductPrices[2].seriesPrice);
      System.assertEquals(99, abacusProductPrices[2].seriesToAmount); 
        
      System.assertEquals(priceCurrency, abacusProductPrices[3].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[3].customerGroupNumber);
      System.assertEquals(p.priceSampleSize100, abacusProductPrices[3].seriesPrice);
      System.assertEquals(2499, abacusProductPrices[3].seriesToAmount); */
    }
    
    // get abacus product prices for moq 50
    @isTest static void testAbacusProductPriceFactoryListWithDataMoq50() {   
      MapProductPrices p = new MapProductPrices();
      p.name = 'test-03';
      p.maxMapPricing = 50;
      p.priceSampleSize1 = 10;
      p.priceSampleSize10 = 20;
      p.priceSampleSize50 = 30;
      p.priceSampleSize100 = 40;
        
      String priceCurrency = 'USD';
      Integer customerGroupNumber = 101;
        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(p, customerGroupNumber, priceCurrency, 1.0, 1000);
   
      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(2, abacusProductPrices.size());
      
      System.assertEquals(priceCurrency, abacusProductPrices[0].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[0].customerGroupNumber);
      System.assertEquals(p.priceSampleSize1, abacusProductPrices[0].seriesPrice);
      System.assertEquals(9, abacusProductPrices[0].seriesToAmount); 
        
      System.assertEquals(priceCurrency, abacusProductPrices[1].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[1].customerGroupNumber);
      System.assertEquals(p.priceSampleSize10, abacusProductPrices[1].seriesPrice);
      System.assertEquals(49, abacusProductPrices[1].seriesToAmount); 
       /*
      System.assertEquals(priceCurrency, abacusProductPrices[2].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[2].customerGroupNumber);
      System.assertEquals(p.priceSampleSize50, abacusProductPrices[2].seriesPrice);
      System.assertEquals(99, abacusProductPrices[2].seriesToAmount); 
        
      System.assertEquals(priceCurrency, abacusProductPrices[3].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[3].customerGroupNumber);
      System.assertEquals(p.priceSampleSize100, abacusProductPrices[3].seriesPrice);
      System.assertEquals(2499, abacusProductPrices[3].seriesToAmount); */
    }
    
     // get abacus product prices for moq 50
    @isTest static void testAbacusProductPriceFactoryListWithDataMoq50_2() {   
      MapProductPrices p = new MapProductPrices();
      p.name = 'test-03';
      p.maxMapPricing = 50;
      p.priceSampleSize1 = 10;
      p.priceSampleSize10 = 20;
      p.priceSampleSize50 = 30;
        
      String priceCurrency = 'USD';
      Integer customerGroupNumber = 101;
        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(p, customerGroupNumber, priceCurrency, 1.0, 1000);
   
      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(2, abacusProductPrices.size());
      
      System.assertEquals(priceCurrency, abacusProductPrices[0].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[0].customerGroupNumber);
      System.assertEquals(p.priceSampleSize1, abacusProductPrices[0].seriesPrice);
      System.assertEquals(9, abacusProductPrices[0].seriesToAmount); 
        
      System.assertEquals(priceCurrency, abacusProductPrices[1].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[1].customerGroupNumber);
      System.assertEquals(p.priceSampleSize10, abacusProductPrices[1].seriesPrice);
      System.assertEquals(49, abacusProductPrices[1].seriesToAmount); 
        /*
      System.assertEquals(priceCurrency, abacusProductPrices[2].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[2].customerGroupNumber);
      System.assertEquals(p.priceSampleSize50, abacusProductPrices[2].seriesPrice);
      System.assertEquals(2499, abacusProductPrices[2].seriesToAmount);   */
    }
    
    // get abacus product prices for moq 51
    @isTest static void testAbacusProductPriceFactoryListWithDataMoq51() {   
      MapProductPrices p = new MapProductPrices();
      p.name = 'test-04';
      p.maxMapPricing = 51;
      p.priceSampleSize1 = 10;
      p.priceSampleSize10 = 20;
      p.priceSampleSize50 = 30;
      p.priceSampleSize100 = 40;
        
      String priceCurrency = 'USD';
      Integer customerGroupNumber = 101;
        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(p, customerGroupNumber, priceCurrency, 1.0, 1000);

      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(3, abacusProductPrices.size());
      
      System.assertEquals(priceCurrency, abacusProductPrices[0].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[0].customerGroupNumber);
      System.assertEquals(p.priceSampleSize1, abacusProductPrices[0].seriesPrice);
      System.assertEquals(9, abacusProductPrices[0].seriesToAmount); 
        
      System.assertEquals(priceCurrency, abacusProductPrices[1].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[1].customerGroupNumber);
      System.assertEquals(p.priceSampleSize10, abacusProductPrices[1].seriesPrice);
      System.assertEquals(49, abacusProductPrices[1].seriesToAmount);   

      System.assertEquals(priceCurrency, abacusProductPrices[2].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[2].customerGroupNumber);
      System.assertEquals(p.priceSampleSize50, abacusProductPrices[2].seriesPrice);
      System.assertEquals(50, abacusProductPrices[2].seriesToAmount); 
        /*
      System.assertEquals(priceCurrency, abacusProductPrices[3].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[3].customerGroupNumber);
      System.assertEquals(p.priceSampleSize100, abacusProductPrices[3].seriesPrice);
      System.assertEquals(2499, abacusProductPrices[3].seriesToAmount); */
    }
    
    // get abacus product prices for moq 100
    @isTest static void testAbacusProductPriceFactoryListWithDataMoq100() {   
      MapProductPrices p = new MapProductPrices();
      p.name = 'test-05';
      p.maxMapPricing = 100;
      p.priceSampleSize1 = 10;
      p.priceSampleSize10 = 20;
      p.priceSampleSize50 = 30;
      p.priceSampleSize100 = 40;
        
      String priceCurrency = 'USD';
      Integer customerGroupNumber = 101;
        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(p, customerGroupNumber, priceCurrency, 1.0, 1000);
 
      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(3, abacusProductPrices.size());
      
      System.assertEquals(priceCurrency, abacusProductPrices[0].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[0].customerGroupNumber);
      System.assertEquals(p.priceSampleSize1, abacusProductPrices[0].seriesPrice);
      System.assertEquals(9, abacusProductPrices[0].seriesToAmount); 
        
      System.assertEquals(priceCurrency, abacusProductPrices[1].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[1].customerGroupNumber);
      System.assertEquals(p.priceSampleSize10, abacusProductPrices[1].seriesPrice);
      System.assertEquals(49, abacusProductPrices[1].seriesToAmount);   
      
      System.assertEquals(priceCurrency, abacusProductPrices[2].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[2].customerGroupNumber);
      System.assertEquals(p.priceSampleSize50, abacusProductPrices[2].seriesPrice);
      System.assertEquals(99, abacusProductPrices[2].seriesToAmount);  
        /*        
      System.assertEquals(priceCurrency, abacusProductPrices[3].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[3].customerGroupNumber);
      System.assertEquals(p.priceSampleSize100, abacusProductPrices[3].seriesPrice);
      System.assertEquals(2499, abacusProductPrices[3].seriesToAmount); */
    }
    
    // get abacus product prices for moq 101
    @isTest static void testAbacusProductPriceFactoryListWithDataMoq101() {   
      MapProductPrices p = new MapProductPrices();
      p.name = 'test-06';
      p.maxMapPricing = 101;
      p.priceSampleSize1 = 10;
      p.priceSampleSize10 = 20;
      p.priceSampleSize50 = 30;
      p.priceSampleSize100 = 40;
        
      String priceCurrency = 'USD';
      Integer customerGroupNumber = 101;
        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(p, customerGroupNumber, priceCurrency, 1.0, 1000);

      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(4, abacusProductPrices.size());
      
      System.assertEquals(priceCurrency, abacusProductPrices[0].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[0].customerGroupNumber);
      System.assertEquals(p.priceSampleSize1, abacusProductPrices[0].seriesPrice);
      System.assertEquals(9, abacusProductPrices[0].seriesToAmount); 
        
      System.assertEquals(priceCurrency, abacusProductPrices[1].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[1].customerGroupNumber);
      System.assertEquals(p.priceSampleSize10, abacusProductPrices[1].seriesPrice);
      System.assertEquals(49, abacusProductPrices[1].seriesToAmount);   
      
      System.assertEquals(priceCurrency, abacusProductPrices[2].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[2].customerGroupNumber);
      System.assertEquals(p.priceSampleSize50, abacusProductPrices[2].seriesPrice);
      System.assertEquals(99, abacusProductPrices[2].seriesToAmount);  
        
      System.assertEquals(priceCurrency, abacusProductPrices[3].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[3].customerGroupNumber);
      System.assertEquals(p.priceSampleSize100, abacusProductPrices[3].seriesPrice);
      System.assertEquals(100, abacusProductPrices[3].seriesToAmount);  
    }
    
     // get abacus product prices for moq 250
    @isTest static void testAbacusProductPriceFactoryListWithDataMoq250() {   
      MapProductPrices p = new MapProductPrices();
      p.name = 'test-07';
      p.maxMapPricing = 250;
      p.priceSampleSize1 = 10;
      p.priceSampleSize10 = 20;
      p.priceSampleSize50 = 30;
      p.priceSampleSize100 = 40;
      p.priceSampleSize250 = 50;
        
      String priceCurrency = 'USD';
      Integer customerGroupNumber = 101;
        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(p, customerGroupNumber, priceCurrency, 1.0, 1000);

      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(4, abacusProductPrices.size());
      
      System.assertEquals(priceCurrency, abacusProductPrices[0].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[0].customerGroupNumber);
      System.assertEquals(p.priceSampleSize1, abacusProductPrices[0].seriesPrice);
      System.assertEquals(9, abacusProductPrices[0].seriesToAmount); 
        
      System.assertEquals(priceCurrency, abacusProductPrices[1].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[1].customerGroupNumber);
      System.assertEquals(p.priceSampleSize10, abacusProductPrices[1].seriesPrice);
      System.assertEquals(49, abacusProductPrices[1].seriesToAmount);   
      
      System.assertEquals(priceCurrency, abacusProductPrices[2].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[2].customerGroupNumber);
      System.assertEquals(p.priceSampleSize50, abacusProductPrices[2].seriesPrice);
      System.assertEquals(99, abacusProductPrices[2].seriesToAmount);  
        
      System.assertEquals(priceCurrency, abacusProductPrices[3].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[3].customerGroupNumber);
      System.assertEquals(p.priceSampleSize100, abacusProductPrices[3].seriesPrice);
      System.assertEquals(249, abacusProductPrices[3].seriesToAmount);  
        /*
      System.assertEquals(priceCurrency, abacusProductPrices[4].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[4].customerGroupNumber);
      System.assertEquals(p.priceSampleSize250, abacusProductPrices[4].seriesPrice);
      System.assertEquals(2499, abacusProductPrices[4].seriesToAmount);  */
    }
    
    
    // get abacus product prices for moq 500
    @isTest static void testAbacusProductPriceFactoryListWithDataMoq500() {   
      MapProductPrices p = new MapProductPrices();
      p.name = 'test-07';
      p.maxMapPricing = 500;
      p.priceSampleSize1 = 10;
      p.priceSampleSize10 = 20;
      p.priceSampleSize50 = 30;
      p.priceSampleSize100 = 40;
      p.priceSampleSize250 = 50;
      p.priceSampleSize500 = 60;
        
      String priceCurrency = 'USD';
      Integer customerGroupNumber = 101;
        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(p, customerGroupNumber, priceCurrency, 1.0, 1000);

      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(5, abacusProductPrices.size());
      
      System.assertEquals(priceCurrency, abacusProductPrices[0].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[0].customerGroupNumber);
      System.assertEquals(p.priceSampleSize1, abacusProductPrices[0].seriesPrice);
      System.assertEquals(9, abacusProductPrices[0].seriesToAmount); 
        
      System.assertEquals(priceCurrency, abacusProductPrices[1].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[1].customerGroupNumber);
      System.assertEquals(p.priceSampleSize10, abacusProductPrices[1].seriesPrice);
      System.assertEquals(49, abacusProductPrices[1].seriesToAmount);   
      
      System.assertEquals(priceCurrency, abacusProductPrices[2].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[2].customerGroupNumber);
      System.assertEquals(p.priceSampleSize50, abacusProductPrices[2].seriesPrice);
      System.assertEquals(99, abacusProductPrices[2].seriesToAmount);  
        
      System.assertEquals(priceCurrency, abacusProductPrices[3].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[3].customerGroupNumber);
      System.assertEquals(p.priceSampleSize100, abacusProductPrices[3].seriesPrice);
      System.assertEquals(249, abacusProductPrices[3].seriesToAmount);  
        
      System.assertEquals(priceCurrency, abacusProductPrices[4].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[4].customerGroupNumber);
      System.assertEquals(p.priceSampleSize250, abacusProductPrices[4].seriesPrice);
      System.assertEquals(499, abacusProductPrices[4].seriesToAmount);  
        /*
      System.assertEquals(priceCurrency, abacusProductPrices[5].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[5].customerGroupNumber);
      System.assertEquals(p.priceSampleSize500, abacusProductPrices[5].seriesPrice);
      System.assertEquals(2499, abacusProductPrices[5].seriesToAmount);  */
    }
    
    // get abacus product prices for moq 1000
    @isTest static void testAbacusProductPriceFactoryListWithDataMoq1000() {   
      MapProductPrices p = new MapProductPrices();
      p.name = 'test-07';
      p.maxMapPricing = 1000;
      p.priceSampleSize1 = 10;
      p.priceSampleSize10 = 20;
      p.priceSampleSize50 = 30;
      p.priceSampleSize100 = 40;
      p.priceSampleSize250 = 50;
      p.priceSampleSize500 = 60;
      p.priceSampleSize1000 = 70;
        
      String priceCurrency = 'USD';
      Integer customerGroupNumber = 101;
        
      List<AbacusProductPrices> abacusProductPrices = ProductPricesAbacusCtrl.abacusProductPriceFactoryList(p, customerGroupNumber, priceCurrency, 1.0, 1000);

      System.assertNotEquals(null, abacusProductPrices); 
      System.assertEquals(6, abacusProductPrices.size());
      
      System.assertEquals(priceCurrency, abacusProductPrices[0].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[0].customerGroupNumber);
      System.assertEquals(p.priceSampleSize1, abacusProductPrices[0].seriesPrice);
      System.assertEquals(9, abacusProductPrices[0].seriesToAmount); 
        
      System.assertEquals(priceCurrency, abacusProductPrices[1].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[1].customerGroupNumber);
      System.assertEquals(p.priceSampleSize10, abacusProductPrices[1].seriesPrice);
      System.assertEquals(49, abacusProductPrices[1].seriesToAmount);   
      
      System.assertEquals(priceCurrency, abacusProductPrices[2].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[2].customerGroupNumber);
      System.assertEquals(p.priceSampleSize50, abacusProductPrices[2].seriesPrice);
      System.assertEquals(99, abacusProductPrices[2].seriesToAmount);  
        
      System.assertEquals(priceCurrency, abacusProductPrices[3].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[3].customerGroupNumber);
      System.assertEquals(p.priceSampleSize100, abacusProductPrices[3].seriesPrice);
      System.assertEquals(249, abacusProductPrices[3].seriesToAmount);  
        
      System.assertEquals(priceCurrency, abacusProductPrices[4].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[4].customerGroupNumber);
      System.assertEquals(p.priceSampleSize250, abacusProductPrices[4].seriesPrice);
      System.assertEquals(499, abacusProductPrices[4].seriesToAmount);  
        
      System.assertEquals(priceCurrency, abacusProductPrices[5].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[5].customerGroupNumber);
      System.assertEquals(p.priceSampleSize500, abacusProductPrices[5].seriesPrice);
      System.assertEquals(999, abacusProductPrices[5].seriesToAmount);  
         /*     
      System.assertEquals(priceCurrency, abacusProductPrices[6].priceCurrency);
      System.assertEquals(customerGroupNumber, abacusProductPrices[6].customerGroupNumber);
      System.assertEquals(p.priceSampleSize1000, abacusProductPrices[6].seriesPrice);
      System.assertEquals(2499, abacusProductPrices[6].seriesToAmount);  */
    }
    
    //------------------------- mapProductPricesFactory ----------------------------------------------------------------
 
    // get map products prices with empty input should return an object
	@isTest static void testMapProductPricesFactoryWithEmptyData() {        

      MapProductPrices mapProductPrice = ProductPricesAbacusCtrl.mapProductPricesFactory(null, null);
      System.assertNotEquals(null, mapProductPrice); 
      
      ProductPrices__c pp = new ProductPrices__c();
      mapProductPrice = ProductPricesAbacusCtrl.mapProductPricesFactory(pp, null);
      System.assertNotEquals(null, mapProductPrice); 
        
      Product2 p = new Product2();
      mapProductPrice = ProductPricesAbacusCtrl.mapProductPricesFactory(null, p);
      System.assertNotEquals(null, mapProductPrice); 
    
      mapProductPrice = ProductPricesAbacusCtrl.mapProductPricesFactory(pp, p);
      System.assertNotEquals(null, mapProductPrice); 
	}
    
    // get map products prices for product price and product should be mapped correctly
	@isTest static void testMapProductPricesFactoryWithData() {           
        String testName = 'test-price';
        String testProductName = 'test-product';
        String testOrderingNumber = 'test-01-00-02';
        Date testValidFrom = Date.newInstance( 2020,1,15);
    
        ProductPrices__c pp = new ProductPrices__c();
       
        pp.Name = testName;
        pp.Product_Name__c = testProductName;
        pp.Ordering_Number__c = testOrderingNumber;
        pp.Valid_From__c = testValidFrom;
    
        
        Integer testMoq = 10;
        String testProductStatus = 'Mass Production';
        Integer testProductKonditionsnummer1 = 1000;
        Integer testProductKonditionsnummer2 = 1001;
        Integer testProductKonditionsnummer3 = 1002;
        String testDescription = 'test \rdescription \n teil 2';
        String testProductCenter = 'Cellular';
        String testCellularTech = 'TestCellTech';
        String testPositioningTech = 'TestPosTech';
        String testShortRangeTech = 'TestSHOTech';
        Boolean testShopActive = true;
    
        Product2 p = new Product2();
        p.Packaging_Size__c = testMoq;
        
        p.Product_Status__c = testProductStatus;
        p.Abacus_Konditionsnummer_101__c = testProductKonditionsnummer1;
        p.Abacus_Konditionsnummer_102__c = testProductKonditionsnummer2;
        p.Abacus_Konditionsnummer_103__c = testProductKonditionsnummer3;
        p.description = testDescription;
        p.Product_Center__c = testProductCenter;
        p.Cellular_Technology__c = testCellularTech;
        p.Positioning_Engine__c = testPositioningTech;
        p.Short_Range_Technology__c = testShortRangeTech;
        p.Shop_Active__c = testShopActive;
        
        MapProductPrices mapProductPrice = ProductPricesAbacusCtrl.mapProductPricesFactory(pp, p);
        System.assertNotEquals(null, mapProductPrice); 
        System.assertEquals(pp.id, mapProductPrice.id); 
        System.assertEquals('/'+pp.id, mapProductPrice.link); 
        System.assertEquals(testName, mapProductPrice.name); 
        System.assertEquals(testProductName, mapProductPrice.productName); 
        System.assertEquals(testOrderingNumber, mapProductPrice.orderingNumber); 
        System.assertEquals(testValidFrom, mapProductPrice.validFrom); 
        System.assertEquals(null, mapProductPrice.priceSampleSize1);
        System.assertEquals(null, mapProductPrice.priceSampleSize10);
        System.assertEquals(null, mapProductPrice.priceSampleSize50);
        System.assertEquals(null, mapProductPrice.priceSampleSize100);
        System.assertEquals(null, mapProductPrice.priceSampleSize250);
        System.assertEquals(null, mapProductPrice.priceSampleSize500);
        System.assertEquals(null, mapProductPrice.priceSampleSize1000);
    
        System.assertEquals(testMoq, mapProductPrice.moq); 
        System.assertEquals(p.id, mapProductPrice.productId); 
        System.assertEquals('/' + p.id, mapProductPrice.productLink); 
        System.assertEquals(testProductStatus, mapProductPrice.productStatus); 
        System.assertEquals(testProductKonditionsnummer1, mapProductPrice.konditionsnummer_101); 
        System.assertEquals(testProductKonditionsnummer2, mapProductPrice.konditionsnummer_102); 
        System.assertEquals(testProductKonditionsnummer3, mapProductPrice.konditionsnummer_103); 
        System.assertEquals('test  description   teil 2', mapProductPrice.description); 
        System.assertEquals(testProductCenter, mapProductPrice.productCenter); 
        System.assertEquals(testCellularTech, mapProductPrice.technology); 
        System.assertEquals(testShopActive, mapProductPrice.soldInWebShop); 
        
        p.Product_Center__c = 'Positioning';
        mapProductPrice = ProductPricesAbacusCtrl.mapProductPricesFactory(pp, p);
        System.assertEquals(testPositioningTech, mapProductPrice.technology); 
        
        p.Product_Center__c = 'Short Range';
        mapProductPrice = ProductPricesAbacusCtrl.mapProductPricesFactory(pp, p);
        System.assertEquals(testShortRangeTech, mapProductPrice.technology); 
	}
    
    // get map products prices for product price and product should be mapped correctly
	@isTest static void testMapProductPricesFactoryWithData2() {           
        String testName = 'test-price-2';
        String testProductName = 'test-product-2';
        String testOrderingNumber = 'test-42-00-02';
        Date testValidFrom = Date.newInstance( 2019,4,5);
    	Decimal testPrice1 = 10.04;
        Decimal testPrice10 = 20.04;
        Decimal testPrice50 = 0.0000;
        Decimal testPrice100 = 99.2413;
        Decimal testPrice250 = 82.2413;
        Decimal testPrice500 = 78.2413;
        Decimal testPrice1000 = 68.2413;
        ProductPrices__c pp = new ProductPrices__c();
       
        pp.Name = testName;
        pp.Product_Name__c = testProductName;
        pp.Ordering_Number__c = testOrderingNumber;
        pp.Valid_From__c = testValidFrom;
        pp.Price_USD_Sample_Size_1__c = testPrice1;
        pp.Price_USD_Sample_Size_10__c = testPrice10;
        pp.Price_USD_Sample_Size_50__c = testPrice50;
        pp.Price_USD_Sample_Size_100__c = testPrice100;
        pp.Price_USD_Sample_Size_250__c = testPrice250;
        pp.Price_USD_Sample_Size_500__c = testPrice500;
        pp.Price_USD_Sample_Size_1000__c = testPrice1000;
    
        
        Integer testMoq = 150;
        String testProductStatus = 'Mass Production';
        Integer testProductKonditionsnummer1 = 2000;
        Integer testProductKonditionsnummer2 = 3001;
        Integer testProductKonditionsnummer3 = 4002;
        String testDescription = 'test \rdescription \n teil 2';
        String testProductCenter = 'Short Range';
        String testShortRangeTech = 'TestSHOTech';
        Boolean testShopActive = true;
    
        Product2 p = new Product2();
        p.Packaging_Size__c = testMoq;
        
        p.Product_Status__c = testProductStatus;
        p.Abacus_Konditionsnummer_101__c = testProductKonditionsnummer1;
        p.Abacus_Konditionsnummer_102__c = testProductKonditionsnummer2;
        p.Abacus_Konditionsnummer_103__c = testProductKonditionsnummer3;
        p.description = testDescription;
        p.Product_Center__c = testProductCenter;
        p.Short_Range_Technology__c = testShortRangeTech;
        p.Shop_Active__c = testShopActive;
        
        MapProductPrices mapProductPrice = ProductPricesAbacusCtrl.mapProductPricesFactory(pp, p);
        System.assertNotEquals(null, mapProductPrice); 
        System.assertEquals(pp.id, mapProductPrice.id); 
        System.assertEquals('/'+pp.id, mapProductPrice.link); 
        System.assertEquals(testName, mapProductPrice.name); 
        System.assertEquals(testProductName, mapProductPrice.productName); 
        System.assertEquals(testOrderingNumber, mapProductPrice.orderingNumber); 
        System.assertEquals(testValidFrom, mapProductPrice.validFrom); 
        System.assertEquals(testPrice1, mapProductPrice.priceSampleSize1);
        System.assertEquals(testPrice10, mapProductPrice.priceSampleSize10);
        System.assertEquals(null, mapProductPrice.priceSampleSize50);
        System.assertEquals(testPrice100, mapProductPrice.priceSampleSize100);
        System.assertEquals(testPrice250, mapProductPrice.priceSampleSize250);
        System.assertEquals(testPrice500, mapProductPrice.priceSampleSize500);
        System.assertEquals(testPrice1000, mapProductPrice.priceSampleSize1000);
    
        System.assertEquals(testMoq, mapProductPrice.moq); 
        System.assertEquals(p.id, mapProductPrice.productId); 
        System.assertEquals('/' + p.id, mapProductPrice.productLink); 
        System.assertEquals(testProductStatus, mapProductPrice.productStatus); 
        System.assertEquals(testProductKonditionsnummer1, mapProductPrice.konditionsnummer_101); 
        System.assertEquals(testProductKonditionsnummer2, mapProductPrice.konditionsnummer_102); 
        System.assertEquals(testProductKonditionsnummer3, mapProductPrice.konditionsnummer_103); 
        System.assertEquals('test  description   teil 2', mapProductPrice.description); 
        System.assertEquals(testProductCenter, mapProductPrice.productCenter); 
        System.assertEquals(testShortRangeTech, mapProductPrice.technology); 
        System.assertEquals(testShopActive, mapProductPrice.soldInWebShop); 
	}
    
   
    
    //------------------------- abacusProductPriceFactory ----------------------------------------------------------------
 
    // get map products prices with empty input should return an object
	@isTest static void testAbacusProductPriceFactoryWithEmptyData() {        
      AbacusProductPrices abacusProductPrice = ProductPricesAbacusCtrl.abacusProductPriceFactory(null, null, null, null, null, null);
      System.assertNotEquals(null, abacusProductPrice);  
      System.assertEquals('', abacusProductPrice.conditionNumber);
      System.assertEquals('Gruppe', abacusProductPrice.customerCategory);
      System.assertEquals('Gruppe', abacusProductPrice.productCategory);
      System.assertNotEquals(null, abacusProductPrice.startDate); 
      
      MapProductPrices mpp = new MapProductPrices();
      abacusProductPrice = ProductPricesAbacusCtrl.abacusProductPriceFactory(mpp, null, null, null, null, null);
      System.assertNotEquals(null, abacusProductPrice); 
      System.assertEquals('', abacusProductPrice.conditionNumber);
      System.assertEquals('Gruppe', abacusProductPrice.customerCategory);
      System.assertEquals('Gruppe', abacusProductPrice.productCategory);
      System.assertNotEquals(null, abacusProductPrice.startDate); 
	}
    
     // get map products prices with empty input should return an object
	@isTest static void testAbacusProductPriceFactoryWithData() {        
	  Decimal testKonditionsnummer = 3000;
      String testPriceCurrency = 'USD';
      Integer testCustomerGroup = 100;
      Decimal testSeriesToAmount = 9;
      Decimal testSeriesPrice = 100.576;
        
      String testProductId = 'test-id';
      String testProductLink = '/test-id';
      String testLink = '/test-link';
      String testName = 'test-name';
      String testOrderingNumber = 'test-04-00-02';
   
      
      MapProductPrices mpp = new MapProductPrices();
      mpp.validFrom = Date.newInstance( 2019,4,5);
      mpp.productId = testProductId;
      mpp.productLink = testProductLink;
      mpp.link = testLink;
      mpp.name = testName;
      mpp.orderingNumber = testOrderingNumber;
        
      AbacusProductPrices abacusProductPrice = ProductPricesAbacusCtrl.abacusProductPriceFactory(mpp, testKonditionsnummer, testPriceCurrency, testCustomerGroup, testSeriesToAmount, testSeriesPrice);
        
      System.assertNotEquals(null, abacusProductPrice); 
      System.assertEquals('3000', abacusProductPrice.conditionNumber);
      System.assertEquals('Gruppe', abacusProductPrice.customerCategory);
      System.assertEquals('Gruppe', abacusProductPrice.productCategory);
      System.assertEquals(testPriceCurrency, abacusProductPrice.priceCurrency);
      System.assertEquals(testCustomerGroup, abacusProductPrice.customerGroupNumber);
      System.assertEquals(testSeriesToAmount, abacusProductPrice.seriesToAmount);
      System.assertNotEquals(null, abacusProductPrice.startDate);
      System.assertEquals('05.04.2019', abacusProductPrice.startDate);
      System.assertEquals(testProductId, abacusProductPrice.productId);
      System.assertEquals('test-name-100-9', abacusProductPrice.id);
      System.assertEquals(testLink, abacusProductPrice.link);
      System.assertEquals(testName, abacusProductPrice.name);
      System.assertEquals(testOrderingNumber, abacusProductPrice.orderingNumber);
	}
}
@isTest
public class ProductPricesTestDataFactory {
    
    public static void setupConversionRates() {          
        ProductPricesCurrencyConversionRates__c conversionRates = new ProductPricesCurrencyConversionRates__c(Name = 'NEO-M8P', Conversion_Rate_EUR__c = 0.880 , Conversion_Rate_CHF__c = 0.990, Conversion_Rate_JPY__c = 110.100);
    
        insert conversionRates;
    }
       
    public static List<Product2> createMinimalProduct() {
        List<Product2> testProducts = new List<Product2>();
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2');
        testProducts.add(testProduct);
        insert testProducts;
        
        return testProducts;
    }
    
    public static List<Product2> createProduct() {
        List<Product2> testProducts = new List<Product2>();
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', MAP_pricing__c = TRUE,  Abacus_Konditionsnummer_101__c = 1000, Abacus_Konditionsnummer_102__c = 1001, Abacus_Konditionsnummer_103__c = 1003, Product_Status__c= 'Mass Production', Product_Center__c = 'Positioning', Positioning_Engine__c ='u-blox M8', Packaging_Size__c = 250, max_MAP_pricing__c = '250', Shop_Active__c = true  );
        testProducts.add(testProduct);
        insert testProducts;
        
        return testProducts;
    }
    
    public static List<Product2> createProductMapPricingFalse() {
        List<Product2> testProducts = new List<Product2>();
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', MAP_pricing__c = FALSE,  Abacus_Konditionsnummer_101__c = 1000, Abacus_Konditionsnummer_102__c = 1001, Abacus_Konditionsnummer_103__c = 1003, Product_Status__c= 'Mass Production', Product_Center__c = 'Positioning', Positioning_Engine__c ='u-blox M8', Packaging_Size__c = 250, max_MAP_pricing__c = '250', Shop_Active__c = true  );
        testProducts.add(testProduct);
        insert testProducts;
        
        return testProducts;
    }
    
    public static List<Product2> createProductWithStatusObsolete() {
        List<Product2> testProducts = new List<Product2>();
        Product2 testProduct = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', MAP_pricing__c = TRUE, Abacus_Konditionsnummer_101__c = 1000, Abacus_Konditionsnummer_102__c = 1001, Abacus_Konditionsnummer_103__c = 1003, Product_Status__c= 'Obsolete', Product_Center__c = 'Positioning', Positioning_Engine__c ='u-blox M8', Packaging_Size__c = 250, max_MAP_pricing__c = '250', Shop_Active__c = true  );
        testProducts.add(testProduct);
        insert testProducts;
        
        return testProducts;
    }
    
     public static List<Product2> createProductsWithMapPricingFalseWithoutMaxMapPricing() {
        List<Product2> testProducts = new List<Product2>();
 		Product2 testProduct   = new Product2(Name = 'NEO-M8P',   Type_No__c= 'NEO-M8P-0-10',     ProductCode= 'NEO-M8P-0',     Abacus_Konditionsnummer_101__c = 1000, Abacus_Konditionsnummer_102__c = 1001, Abacus_Konditionsnummer_103__c = 1003, Product_Status__c= 'Obsolete',        Product_Center__c = 'Positioning', Positioning_Engine__c ='u-blox M8', Packaging_Size__c = 250, Shop_Active__c = false, MAP_pricing__c = FALSE );
 		Product2 testProduct2  = new Product2(Name = 'NEO-M8P',   Type_No__c= 'NEO-M8P-0-11',     ProductCode= 'NEO-M8P-0',     Abacus_Konditionsnummer_101__c = 1000, Abacus_Konditionsnummer_102__c = 1001, Abacus_Konditionsnummer_103__c = 1003, Product_Status__c= 'Mass Production', Product_Center__c = 'Positioning', Positioning_Engine__c ='u-blox M8', Packaging_Size__c = 250, Shop_Active__c = false, MAP_pricing__c = FALSE );
 		Product2 testProduct3  = new Product2(Name = 'NEO-M8P',   Type_No__c= 'NEO-M8P-2-11',     ProductCode= 'NEO-M8P-2',     Abacus_Konditionsnummer_101__c = 1000, Abacus_Konditionsnummer_102__c = 1001, Abacus_Konditionsnummer_103__c = 1003, Product_Status__c= 'Mass Production', Product_Center__c = 'Positioning', Positioning_Engine__c ='u-blox M8', Packaging_Size__c = 250, Shop_Active__c = true,  MAP_pricing__c = FALSE  );
	 
 		Product2 testProduct4  = new Product2(Name = 'NINA-B111', Type_No__c= 'NINA-B111-03B-00', ProductCode= 'NINA-B111-03B', Abacus_Konditionsnummer_101__c = 4577, Abacus_Konditionsnummer_102__c = 4557, Abacus_Konditionsnummer_103__c = 4597, Product_Status__c= 'Mass Production', Product_Center__c = 'Short Range', Short_Range_Technology__c ='BT Low Energy', Packaging_Size__c = 500,  Shop_Active__c = true, MAP_pricing__c = FALSE  );
 
 		Product2 testProduct5  = new Product2(Name = 'ZED-F9T',   Type_No__c= 'ZED-F9T-00B-00',   ProductCode= 'ZED-F9T-00B',   Abacus_Konditionsnummer_101__c = 4619, Abacus_Konditionsnummer_102__c = 4612, Abacus_Konditionsnummer_103__c = 4626, Product_Status__c= 'Initial Production', Product_Center__c = 'Positioning', Positioning_Engine__c ='u-blox F9', Packaging_Size__c = 250, Shop_Active__c = true, MAP_pricing__c = FALSE  );
         
        testProducts.add(testProduct);
        testProducts.add(testProduct2);
        testProducts.add(testProduct3);
        testProducts.add(testProduct4);
        testProducts.add(testProduct5);
   
        
        insert testProducts;
        
        return testProducts;
    }
    
    public static List<Product2> createProductsMax() {
        List<Product2> testProducts = new List<Product2>();
 		Product2 testProduct   = new Product2(Name = 'NEO-M8P',   Type_No__c= 'NEO-M8P-0-10',     ProductCode= 'NEO-M8P-0',     Abacus_Konditionsnummer_101__c = 1000, Abacus_Konditionsnummer_102__c = 1001, Abacus_Konditionsnummer_103__c = 1003, Product_Status__c= 'Obsolete',        Product_Center__c = 'Positioning', Positioning_Engine__c ='u-blox M8', Packaging_Size__c = 250, max_MAP_pricing__c='250', Shop_Active__c = false, MAP_pricing__c = FALSE );
 		Product2 testProduct2  = new Product2(Name = 'NEO-M8P',   Type_No__c= 'NEO-M8P-0-11',     ProductCode= 'NEO-M8P-0',     Abacus_Konditionsnummer_101__c = 1000, Abacus_Konditionsnummer_102__c = 1001, Abacus_Konditionsnummer_103__c = 1003, Product_Status__c= 'Mass Production', Product_Center__c = 'Positioning', Positioning_Engine__c ='u-blox M8', Packaging_Size__c = 250, max_MAP_pricing__c='250', Shop_Active__c = false, MAP_pricing__c = TRUE );
 		Product2 testProduct3  = new Product2(Name = 'NEO-M8P',   Type_No__c= 'NEO-M8P-2-11',     ProductCode= 'NEO-M8P-2',     Abacus_Konditionsnummer_101__c = 1000, Abacus_Konditionsnummer_102__c = 1001, Abacus_Konditionsnummer_103__c = 1003, Product_Status__c= 'Mass Production', Product_Center__c = 'Positioning', Positioning_Engine__c ='u-blox M8', Packaging_Size__c = 250, max_MAP_pricing__c='250', Shop_Active__c = true,  MAP_pricing__c = TRUE  );
	 
 		Product2 testProduct4  = new Product2(Name = 'NINA-B111', Type_No__c= 'NINA-B111-03B-00', ProductCode= 'NINA-B111-03B', Abacus_Konditionsnummer_101__c = 4577, Abacus_Konditionsnummer_102__c = 4557, Abacus_Konditionsnummer_103__c = 4597, Product_Status__c= 'Mass Production', Product_Center__c = 'Short Range', Short_Range_Technology__c ='BT Low Energy', Packaging_Size__c = 500, max_MAP_pricing__c='500', Shop_Active__c = true, MAP_pricing__c = TRUE  );
 
 		Product2 testProduct5  = new Product2(Name = 'ZED-F9T',   Type_No__c= 'ZED-F9T-00B-00',   ProductCode= 'ZED-F9T-00B',   Abacus_Konditionsnummer_101__c = 4619, Abacus_Konditionsnummer_102__c = 4612, Abacus_Konditionsnummer_103__c = 4626, Product_Status__c= 'Initial Production', Product_Center__c = 'Positioning', Positioning_Engine__c ='u-blox F9', Packaging_Size__c = 250, max_MAP_pricing__c='250', Shop_Active__c = true, MAP_pricing__c = TRUE  );
 
 		Product2 testProduct6  = new Product2(Name = 'ZED-F9T',   Type_No__c= 'ZED-F9T-00B-01',   ProductCode= 'ZED-F9T-00B',   Abacus_Konditionsnummer_101__c = 4619, Abacus_Konditionsnummer_102__c = 4612, Abacus_Konditionsnummer_103__c = 4626, Product_Status__c= 'In Development', Product_Center__c = 'Positioning', Positioning_Engine__c ='u-blox F9', Packaging_Size__c = 250, max_MAP_pricing__c='250', Shop_Active__c = false, MAP_pricing__c = TRUE  );
 
		Product2 testProduct7  = new Product2(Name = 'ZOE-M8B',   Type_No__c= 'ZOE-M8B-0-10',     ProductCode= 'ZOE-M8B-0',     Abacus_Konditionsnummer_101__c = 3123, Abacus_Konditionsnummer_102__c = 3043, Abacus_Konditionsnummer_103__c = 3204, Product_Status__c= 'Mass Production', Product_Center__c = 'Positioning', Positioning_Engine__c ='u-blox M8', Packaging_Size__c = 1000, max_MAP_pricing__c='1000', Shop_Active__c = true, MAP_pricing__c = TRUE  );
 
 		Product2 testProduct8  = new Product2(Name = 'TOBY-L220', Type_No__c= 'TOBY-L220-02S-00', ProductCode= 'TOBY-L220-02S', Abacus_Konditionsnummer_101__c = 2838, Abacus_Konditionsnummer_102__c = 2716, Abacus_Konditionsnummer_103__c = 2960, Product_Status__c= 'Mass Production', Product_Center__c = 'Cellular', Cellular_Technology__c ='LTE-multi', Packaging_Size__c = 150, max_MAP_pricing__c='250', Shop_Active__c = true, MAP_pricing__c = TRUE  );
 
 		Product2 testProduct9  = new Product2(Name = 'TOBY-L220', Type_No__c= 'TOBY-L220-62S-00', ProductCode= 'TOBY-L220-62S', Abacus_Konditionsnummer_101__c = 2839, Abacus_Konditionsnummer_102__c = 2717, Abacus_Konditionsnummer_103__c = 2961, Product_Status__c= 'Mass Production', Product_Center__c = 'Cellular', Cellular_Technology__c ='LTE-only', Packaging_Size__c = 150, max_MAP_pricing__c='250', Shop_Active__c = true, MAP_pricing__c = TRUE  );
 
 		Product2 testProduct10 = new Product2(Name = 'LARA-R202', Type_No__c= 'LARA-R202-02B-01', ProductCode= 'LARA-R202-02B', Abacus_Konditionsnummer_101__c = 2768, Abacus_Konditionsnummer_102__c = 2646, Abacus_Konditionsnummer_103__c = 2890, Product_Status__c= 'Obsolete',      Product_Center__c = 'Cellular', Cellular_Technology__c ='LTE-multi', Packaging_Size__c = 150, max_MAP_pricing__c='250', Shop_Active__c = false, MAP_pricing__c = TRUE  );
 		Product2 testProduct11 = new Product2(Name = 'LARA-R202', Type_No__c= 'LARA-R202-02B-02', ProductCode= 'LARA-R202-02B', Abacus_Konditionsnummer_101__c = 2768, Abacus_Konditionsnummer_102__c = 2646, Abacus_Konditionsnummer_103__c = 2890, Product_Status__c= 'In Definition', Product_Center__c = 'Cellular', Cellular_Technology__c ='LTE-multi', Packaging_Size__c = 150, max_MAP_pricing__c='250', Shop_Active__c = true,  MAP_pricing__c = TRUE  );
 		Product2 testProduct12 = new Product2(Name = 'LARA-R202', Type_No__c= 'LARA-R202-02B-03', ProductCode= 'LARA-R202-02B', Abacus_Konditionsnummer_101__c = 2768, Abacus_Konditionsnummer_102__c = 2646, Abacus_Konditionsnummer_103__c = 2890, Product_Status__c= 'End of Life',   Product_Center__c = 'Cellular', Cellular_Technology__c ='LTE-multi', Packaging_Size__c = 150, max_MAP_pricing__c='250', Shop_Active__c = true,  MAP_pricing__c = TRUE  );
 
 		Product2 testProduct13 = new Product2(Name = 'EVK-N200',  Type_No__c= 'EVK-N200-02B-00',  ProductCode= 'EVK-N200-02B',  Abacus_Konditionsnummer_101__c = 3237, Abacus_Konditionsnummer_102__c = 3212, Abacus_Konditionsnummer_103__c = 3262, Product_Status__c= 'End of Life',   Product_Center__c = 'Cellular', Cellular_Technology__c ='CIoT', Packaging_Size__c = 1, max_MAP_pricing__c='1', Shop_Active__c = true, MAP_pricing__c = TRUE);
        
        testProducts.add(testProduct);
        testProducts.add(testProduct2);
        testProducts.add(testProduct3);
        testProducts.add(testProduct4);
        testProducts.add(testProduct5);
        testProducts.add(testProduct6);
        testProducts.add(testProduct7);
        testProducts.add(testProduct8);
        testProducts.add(testProduct9);
        testProducts.add(testProduct10);
        testProducts.add(testProduct11);
        testProducts.add(testProduct12);
        testProducts.add(testProduct13);
        
        insert testProducts;
        
        return testProducts;
    }
    
    
    public static List<ProductPrices__c> createProductPrice() {
        List<ProductPrices__c> testProductsPrices = new List<ProductPrices__c>();
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000,	Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        testProductsPrices.add(testProductPrice);
        insert testProductsPrices;
        
        return testProductsPrices;
    }
    
    public static List<ProductPrices__c> createProductPriceWithOneEmptyPrice() {
        List<ProductPrices__c> testProductsPrices = new List<ProductPrices__c>();
        ProductPrices__c testProductPrice = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000,	Price_USD_Sample_Size_10__c=0.0000, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        testProductsPrices.add(testProductPrice);
        insert testProductsPrices;
        
        return testProductsPrices;
    }
    
    public static List<ProductPrices__c> createProductPrices() {
        List<ProductPrices__c> testProductsPrices = new List<ProductPrices__c>();
        ProductPrices__c testProductPrice   = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000,	Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890, Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        testProductsPrices.add(testProductPrice);
        ProductPrices__c testProductPrice2  = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-20', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 19.0000,	Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 24.6890, Valid_From__c = Date.newInstance( 2020,1,20) );
        testProductsPrices.add(testProductPrice2);
        ProductPrices__c testProductPrice3  = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-07', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 10.0000,	Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 34.6890, Valid_From__c = Date.newInstance( 2020,1,7) );
        testProductsPrices.add(testProductPrice3);
        ProductPrices__c testProductPrice4  = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-06', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 13.0000,	Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 64.6890, Valid_From__c = Date.newInstance( 2020,1,6) );
        testProductsPrices.add(testProductPrice4);
        ProductPrices__c testProductPrice5  = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-05', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 14.0000,	Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 74.6890, Valid_From__c = Date.newInstance( 2020,1,5) );
        testProductsPrices.add(testProductPrice5);
        ProductPrices__c testProductPrice6  = new ProductPrices__c(Name = 'NEO-M8P-2-2019-12-09', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 155.0000,	Price_USD_Sample_Size_10__c=154.4815, 	Price_USD_Sample_Size_50__c = 153.1390, Price_USD_Sample_Size_100__c= 84.6890, Valid_From__c = Date.newInstance( 2019,12,9) );
        testProductsPrices.add(testProductPrice6);
    
        insert testProductsPrices;
        
        return testProductsPrices;
    }
    
    public static List<ProductPrices__c> createProductPricesMax() {
        List<ProductPrices__c> testProductsPrices = new List<ProductPrices__c>();
       	ProductPrices__c testProductPrice    = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-09', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 149.0000,	Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 94.6890,	Price_USD_Sample_Size_250__c= 90.2145, 	Price_USD_Sample_Size_500__c=80.5781, Price_USD_Sample_Size_1000__c = 75.5294, Valid_From__c = Date.newInstance( 2020,1,9) );
        ProductPrices__c testProductPrice2   = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-20', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 19.0000,	Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 24.6890, Valid_From__c = Date.newInstance( 2020,1,20) );
        ProductPrices__c testProductPrice3   = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-07', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 10.0000,	Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 34.6890, Valid_From__c = Date.newInstance( 2020,1,7) );
        ProductPrices__c testProductPrice4   = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-06', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 13.0000,	Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 64.6890, Valid_From__c = Date.newInstance( 2020,1,6) );
        ProductPrices__c testProductPrice5   = new ProductPrices__c(Name = 'NEO-M8P-2-2020-01-05', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 14.0000,	Price_USD_Sample_Size_10__c=114.4815, 	Price_USD_Sample_Size_50__c = 104.1390, Price_USD_Sample_Size_100__c= 74.6890, Valid_From__c = Date.newInstance( 2020,1,5) );
        ProductPrices__c testProductPrice6   = new ProductPrices__c(Name = 'NEO-M8P-2-2019-12-09', Product_Name__c= 'NEO-M8P-2', Ordering_Number__c='NEO-M8P-2', Price_USD_Sample_Size_1__c = 155.0000,	Price_USD_Sample_Size_10__c=154.4815, 	Price_USD_Sample_Size_50__c = 153.1390, Price_USD_Sample_Size_100__c= 84.6890, Valid_From__c = Date.newInstance( 2019,12,9) );
        
        ProductPrices__c testProductPrice7   = new ProductPrices__c(Name = 'NEO-M8P-0-2020-01-09', Product_Name__c= 'NEO-M8P-0', Ordering_Number__c='NEO-M8P-0', Price_USD_Sample_Size_1__c = 149.0000,	Price_USD_Sample_Size_10__c=99.5190, 	Price_USD_Sample_Size_50__c = 90.5940, Price_USD_Sample_Size_100__c= 82.3515, Valid_From__c = Date.newInstance( 2020,1,9) );

        ProductPrices__c testProductPrice8   = new ProductPrices__c(Name = 'NINA-B111-03B-2019-12-012', Product_Name__c= 'NINA-B111', Ordering_Number__c='NINA-B111-03B', Price_USD_Sample_Size_1__c = 148.0000,	Price_USD_Sample_Size_10__c=91.5990, 	Price_USD_Sample_Size_50__c = 81.3941, Price_USD_Sample_Size_100__c= 73.6515, Valid_From__c = Date.newInstance( 2019,12,12) );
        ProductPrices__c testProductPrice9   = new ProductPrices__c(Name = 'NINA-B111-03B-2020-01-05', Product_Name__c= 'NINA-B111', Ordering_Number__c='NINA-B111-03B', Price_USD_Sample_Size_1__c = 145.0000,	Price_USD_Sample_Size_10__c=91.5090, 	Price_USD_Sample_Size_50__c = 80.3941, Price_USD_Sample_Size_100__c= 72.3515, Valid_From__c = Date.newInstance( 2020,1,5) );
        ProductPrices__c testProductPrice10  = new ProductPrices__c(Name = 'NINA-B111-03B-2020-01-09', Product_Name__c= 'NINA-B111', Ordering_Number__c='NINA-B111-03B', Price_USD_Sample_Size_1__c = 140.0000,	Price_USD_Sample_Size_10__c=90.5090, 	Price_USD_Sample_Size_50__c = 80.3940, Price_USD_Sample_Size_100__c= 72.3515, Valid_From__c = Date.newInstance( 2020,1,9) );
        
        ProductPrices__c testProductPrice11  = new ProductPrices__c(Name = 'ZED-F9T-00B-2020-01-09', Product_Name__c= 'ZED-F9T-00B', Ordering_Number__c='ZED-F9T-00B', Price_USD_Sample_Size_1__c = 199.0000,	Price_USD_Sample_Size_10__c=192.9165, 	Price_USD_Sample_Size_50__c = 175.5390, Price_USD_Sample_Size_100__c= 154.3290, Valid_From__c = Date.newInstance( 2020,1,9) );
        ProductPrices__c testProductPrice12  = new ProductPrices__c(Name = 'ZED-F9T-00B-2020-02-15', Product_Name__c= 'ZED-F9T-00B', Ordering_Number__c='ZED-F9T-00B', Price_USD_Sample_Size_1__c = 299.0000,	Price_USD_Sample_Size_10__c=193.9965, 	Price_USD_Sample_Size_50__c = 185.5490, Price_USD_Sample_Size_100__c= 155.3290, Valid_From__c = Date.newInstance( 2020,2,15) );
        
        ProductPrices__c testProductPrice13  = new ProductPrices__c(Name = 'TOBY-L220-02S-2019-12-03', Product_Name__c= 'TOBY-L220', Ordering_Number__c='TOBY-L220-02S', Price_USD_Sample_Size_1__c = 126.2100,	Price_USD_Sample_Size_10__c=89.4120, 	Price_USD_Sample_Size_50__c = 68.0501, Price_USD_Sample_Size_100__c= 69.1230, Price_USD_Sample_Size_250__c= 67.2145, Price_USD_Sample_Size_500__c=62.4214, Price_USD_Sample_Size_1000__c = 60.4254, Valid_From__c = Date.newInstance( 2019,12,3) );
        ProductPrices__c testProductPrice14  = new ProductPrices__c(Name = 'TOBY-L220-02S-2019-12-05', Product_Name__c= 'TOBY-L220', Ordering_Number__c='TOBY-L220-02S', Price_USD_Sample_Size_1__c = 125.2100,	Price_USD_Sample_Size_10__c=89.4120, 	Price_USD_Sample_Size_50__c = 67.0501, Price_USD_Sample_Size_100__c= 68.1030, Price_USD_Sample_Size_250__c= 65.2145, Price_USD_Sample_Size_500__c=64.5781, Price_USD_Sample_Size_1000__c = 61.5514, Valid_From__c = Date.newInstance( 2019,12,5) );
        ProductPrices__c testProductPrice15  = new ProductPrices__c(Name = 'TOBY-L220-02S-2020-01-09', Product_Name__c= 'TOBY-L220', Ordering_Number__c='TOBY-L220-02S', Price_USD_Sample_Size_1__c = 115.2000,	Price_USD_Sample_Size_10__c=86.4000, 	Price_USD_Sample_Size_50__c = 69.0000, Price_USD_Sample_Size_100__c= 60.0000, Price_USD_Sample_Size_250__c= 59.2145, Price_USD_Sample_Size_500__c=57.5781, Price_USD_Sample_Size_1000__c = 55.5294, Valid_From__c = Date.newInstance( 2020,1,9) );

        ProductPrices__c testProductPrice16  = new ProductPrices__c(Name = 'TOBY-L220-62S-2020-01-09', Product_Name__c= 'TOBY-L220', Ordering_Number__c='TOBY-L220-62S', Price_USD_Sample_Size_1__c = 115.2000,	Price_USD_Sample_Size_10__c=86.4000, 	Price_USD_Sample_Size_50__c = 69.0000, Price_USD_Sample_Size_100__c= 60.0000, Valid_From__c = Date.newInstance( 2020,1,9) );

        ProductPrices__c testProductPrice17  = new ProductPrices__c(Name = 'LARA-R202-02B-2020-01-09', Product_Name__c= 'LARA-R202', Ordering_Number__c='LARA-R202-02B', Price_USD_Sample_Size_1__c = 96.0000,	Price_USD_Sample_Size_10__c=72.0000, 	Price_USD_Sample_Size_50__c = 57.5000, Price_USD_Sample_Size_100__c= 50.0000, Valid_From__c = Date.newInstance( 2020,1,9) );
        ProductPrices__c testProductPrice18  = new ProductPrices__c(Name = 'LARA-R202-02B-2020-01-15', Product_Name__c= 'LARA-R202', Ordering_Number__c='LARA-R202-02B', Price_USD_Sample_Size_1__c = 97.0000,	Price_USD_Sample_Size_10__c=73.0000, 	Price_USD_Sample_Size_50__c = 58.5000, Price_USD_Sample_Size_100__c= 52.0000, Valid_From__c = Date.newInstance( 2020,1,15) );
        
        ProductPrices__c testProductPrice19  = new ProductPrices__c(Name = 'EVK-N200-02B-2020-01-09', Product_Name__c= 'EVK-N2xx', Ordering_Number__c='EVK-N200-02B', Price_USD_Sample_Size_1__c = 399.0000,	Valid_From__c = Date.newInstance( 2020,1,9) );
        ProductPrices__c testProductPrice20  = new ProductPrices__c(Name = 'EVK-N200-02B-2020-01-11', Product_Name__c= 'EVK-N2xx', Ordering_Number__c='EVK-N200-02B', Price_USD_Sample_Size_1__c = 409.0000,	Valid_From__c = Date.newInstance( 2020,1,11) );
    

        testProductsPrices.add(testProductPrice);
        testProductsPrices.add(testProductPrice2);
        testProductsPrices.add(testProductPrice3);
        testProductsPrices.add(testProductPrice4);
        testProductsPrices.add(testProductPrice5);
        testProductsPrices.add(testProductPrice6);
        testProductsPrices.add(testProductPrice7);
        testProductsPrices.add(testProductPrice8);
        testProductsPrices.add(testProductPrice9);
        testProductsPrices.add(testProductPrice10);
        testProductsPrices.add(testProductPrice11);
        testProductsPrices.add(testProductPrice12);
        testProductsPrices.add(testProductPrice13);
        testProductsPrices.add(testProductPrice14);
        testProductsPrices.add(testProductPrice15);
        testProductsPrices.add(testProductPrice16);
        testProductsPrices.add(testProductPrice17);
        testProductsPrices.add(testProductPrice18);
        testProductsPrices.add(testProductPrice19);
        testProductsPrices.add(testProductPrice20);
    
        insert testProductsPrices;
        
        return testProductsPrices;
    }
    
    public static Opp_Product__c createOppProd(Product2 product, Integer annualQuantity, String currencyCode) {
        
        Opportunity opportunity    = new Opportunity(Name ='Test Opportunity 1', CurrencyIsoCode = currencyCode, StageName ='4 Evaluation', CloseDate =  Date.newInstance( 2025,1,11) );
        insert opportunity;
        Opp_Product__c testOppProd = new Opp_Product__c(Product__c = product.id, CurrencyIsoCode = currencyCode, Annual_Quantity__c = annualQuantity, Opportunity__c = opportunity.id );
     
        insert testOppProd;
        
        return testOppProd;
    } 
    
    public static User createTestUser(String fName, String lName)
    {
        Id profId = '00e200000015GYr'; // chatter free user
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        
       
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        Id roleID = '00E20000000urlW'; //Corporate
        
        
        User tuser = new User(  firstname = fName,
                                lastName = lName,
                                email = uniqueName + 'test@u-blox.com',
                                Username = uniqueName + 'test@u-blox.com',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = uniqueName.substring(18, 23),
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = profId
                                );
        insert tuser;
        
        return tuser;
    }
}
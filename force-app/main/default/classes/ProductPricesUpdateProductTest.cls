@isTest
public class ProductPricesUpdateProductTest {

	// updateProducts should update the testProduct
	@isTest static void testUpdateProducts1() { 
 		Product2 testProduct = ProductPricesTestDataFactory.createProduct()[0];
        
     	ProductPricesUpdateProduct a = new ProductPricesUpdateProduct();
        a.updateProducts();
        
        Product2 updatedTestProduct = ProductPricesAbacusCtrl.getProductByProductId(testProduct.id);
        System.assertNotEquals(null, updatedTestProduct); 

        System.assertEquals(3115, updatedTestProduct.Abacus_Konditionsnummer_101__c);
        System.assertEquals(3035, updatedTestProduct.Abacus_Konditionsnummer_102__c);
        System.assertEquals(3195, updatedTestProduct.Abacus_Konditionsnummer_103__c);
	}
    
    // updateProductsSetMapPricingField should update the testProduct
	@isTest static void testUpdateProductsSetMapPricingField() {
        //Init
 		Product2 testProduct = ProductPricesTestDataFactory.createProductMapPricingFalse()[0];
        ProductPricesTestDataFactory.createProductPrice();
        
        //check before
        System.assertEquals(FALSE, testProduct.MAP_pricing__c);
        
        // run update 
     	ProductPricesUpdateProduct a = new ProductPricesUpdateProduct();
        a.updateProductsSetMapPricingFieldStartEnd(0,200);
        
        // Check after
        Product2 updatedTestProduct = ProductPricesAbacusCtrl.getProductByProductId(testProduct.id);
        System.assertNotEquals(null, updatedTestProduct); 

        System.assertEquals(TRUE, updatedTestProduct.MAP_pricing__c);
	}
    
    // updateProductsSetMapPricingField should update the testProduct
	@isTest static void testUpdateProductsSetMapPricingField2() {
        //Init
 		List<Product2> testProducts = ProductPricesTestDataFactory.createProductsWithMapPricingFalseWithoutMaxMapPricing();
        ProductPricesTestDataFactory.createProductPricesMax();
        
        //check before
        for (Product2 currentProduct :testProducts) 
        {
            System.assertEquals(FALSE, currentProduct.MAP_pricing__c);
            System.assertEquals(null, currentProduct.max_MAP_pricing__c);
        }
        
        // run update 
     	ProductPricesUpdateProduct a = new ProductPricesUpdateProduct();
        a.updateProductsSetMapPricingFieldStartEnd(0,200);
        
        // Check after
 		for (Product2 currentProduct :testProducts) 
        {        
            Product2 updatedTestProduct = ProductPricesAbacusCtrl.getProductByProductId(currentProduct.id);
            System.assertNotEquals(null, updatedTestProduct); 
    
            System.assertEquals(TRUE, updatedTestProduct.MAP_pricing__c);
            //System.assertNotEquals(null, updatedTestProduct.max_MAP_pricing__c);
        }
        System.assertEquals(5, testProducts.size());
	}
    
}
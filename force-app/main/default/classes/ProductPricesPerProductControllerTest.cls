@isTest
public class ProductPricesPerProductControllerTest {

	// without test data return an empty list
	@isTest static void testProductPricesPerProductController1() {
	  Id testProductId = ProductPricesTestDataFactory.createProduct()[0].id;
      PageReference myVfPage = Page.ProductPricesPerProduct;
      Test.setCurrentPage(myVfPage);
        
      // Put Id into the current page Parameters
      ApexPages.currentPage().getParameters().put('id', testProductId); 
      
      ProductPricesPerProductController ppppCtrl = new ProductPricesPerProductController();
       
      System.assertNotEquals(null, ppppCtrl.productPrices);
      System.assertEquals(0, ppppCtrl.productPrices.size());
	}
    
    // should return all product prices for selected product
    @isTest static void testProductPricesPerProductController2() {
      Id testProductId = ProductPricesTestDataFactory.createProduct()[0].id;
      ProductPricesTestDataFactory.createProductPrices();
        
      PageReference myVfPage = Page.ProductPricesPerProduct;
      Test.setCurrentPage(myVfPage);
        
      // Put Id into the current page Parameters
      ApexPages.currentPage().getParameters().put('id', testProductId); 
      
      ProductPricesPerProductController ppppCtrl = new ProductPricesPerProductController();
       
      System.assertNotEquals(null, ppppCtrl.productPrices);
      System.assertEquals(6, ppppCtrl.productPrices.size());
	}
    
   

}
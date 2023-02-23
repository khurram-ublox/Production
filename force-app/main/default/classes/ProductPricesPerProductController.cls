public class ProductPricesPerProductController{
    
    public List<ProductPrices__c> productPrices{get; set;}
    public ProductPricesPerProductController()
    {
        String product_code  = '%';
        String test_output = ApexPages.currentPage().getParameters().get('id');
        if(ApexPages.currentPage().getParameters().get('id') != null)
        {
            Product2 product = [SELECT Id, Name, ProductCode FROM Product2
                       WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
            
            product_code = product.ProductCode;
        }
        
        productPrices = new List<ProductPrices__c>();
          
        for (ProductPrices__c p : [Select id, Name,Product_Name__c, Ordering_Number__c, Price_USD_Sample_Size_1__c, Price_USD_Sample_Size_10__c ,Price_USD_Sample_Size_50__c, Price_USD_Sample_Size_100__c, Price_USD_Sample_Size_250__c, Price_USD_Sample_Size_500__c, Price_USD_Sample_Size_1000__c, Valid_From__c from ProductPrices__c where Ordering_Number__c LIKE :product_code ORDER BY Valid_From__c])
        {          
                  
           productPrices.add(p);

        }
    }
    
}
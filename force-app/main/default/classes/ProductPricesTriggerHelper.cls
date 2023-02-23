public with sharing class ProductPricesTriggerHelper {
    
    
    // ---- product helpers  --------------------------------------------------------------------------------------------------------
    
    public static Set<String> afterInsertOrDeleteProductHandler(List<Product2> triggerNew, Map<Id, Product2> triggerNewMap) {
        Set<ID> ids = triggerNewMap.keySet();
        
        Set<String> productCodes = new Set<String>();
        for (Product2 product :triggerNew) {
            Product2 newProduct = triggerNewMap.get(product.ID);         
            productCodes.add(newProduct.ProductCode);
        }

        return productCodes;
    }
    
    public static Set<String> afterUpdateProductHandler(List<Product2> triggerNew, Map<Id, Product2> triggerNewMap, List<Product2> triggerOld, Map<Id, Product2> triggerOldMap) {
        Set<ID> ids = triggerNewMap.keySet();
        
        //system.debug('-------1-------');
        //Set<ID> ids = Trigger.oldMap.keySet();
        Set<String> productCodes = new Set<String>();
        for (Product2 product :triggerNew) {
            //system.debug('-------2-------');
           
            Product2 oldProduct = triggerOldMap.get(product.ID);          
            Product2 newProduct = triggerNewMap.get(product.ID);
            
         
            if(oldProduct.Product_Center__c  != newProduct.Product_Center__c || 
               oldProduct.Product_Series__c  != newProduct.Product_Series__c || 
               oldProduct.Product_Owner__c   != newProduct.Product_Owner__c || 
               oldProduct.Product_Status__c  != newProduct.Product_Status__c || 
               oldProduct.Map_Pricing__c     != newProduct.Map_Pricing__c ||
               oldProduct.max_MAP_pricing__c != newProduct.max_MAP_pricing__c)
            {
                 //system.debug('-------yes-------');
                 productCodes.add(newProduct.ProductCode);
            }
                    
        }
        //system.debug('-------3-------');
        return productCodes;
    }
        
      
    public static void insertupdatedeleteProducthandler(Set<String> productCodes) {        
        List<Product2> products = new list<Product2>();
        if(productCodes.size() > 0){
            products = [SELECT Id, 
                                ProductCode, 
                                Product_Status__c, 
                                Product_Center__c, 
                                Product_Series__c, 
                                Product_Owner__c, 
                                Map_Pricing__c, 
                                max_MAP_pricing__c, 
                                SystemModstamp 
                                FROM Product2 WHERE ProductCode in :productCodes];
        }else return;
        
       // List<Product2> products = [SELECT Id, ProductCode, Product_Status__c, Product_Center__c, Product_Series__c, Product_Owner__c, SystemModstamp FROM Product2 WHERE Id in :ids];
        Map<String, Product2> selectedProducts = new Map<String, Product2>();  // stores for each ProductCode the product with the highest rating
        Map<String, Boolean> productMapPricing = new Map<String, Boolean>();   // stores for each ProductCode if one of the contected products has set Map_Pricing_cc to true
        Map<String, String>  productMinimumMaxMapPricing = new Map<String, String>();  // stores for each ProductCode the minimun max_MAP_pricing__c one of the contected products
        
        if(products.size()>0)
        {
            for (Product2 product :products) 
            {
                if(selectedProducts.get(product.ProductCode) == null) {
                    selectedProducts.put(product.ProductCode, product);
                }
                else 
                {
                    if(ProductPricesTriggerHelper.isProductAHigherRatedThanProductB(product, selectedProducts.get(product.ProductCode))) 
                    {
                        selectedProducts.put(product.ProductCode, product);
                    }
                }               
                
                if(productMapPricing.get(product.ProductCode) == null) {
                    if(product.Map_Pricing__c == True)
                    {
                        productMapPricing.put(product.ProductCode, TRUE);
                    }
                }
                
                if(productMinimumMaxMapPricing.get(product.ProductCode) == null) {
                    productMinimumMaxMapPricing.put(product.ProductCode, product.max_MAP_pricing__c);
                }
                else 
                {
                    if(ProductPricesTriggerHelper.isMaxMapPricingBLowerThanA(productMinimumMaxMapPricing.get(product.ProductCode), product.max_MAP_pricing__c)) 
                    {
                        productMinimumMaxMapPricing.put(product.ProductCode, product.max_MAP_pricing__c);
                    }
                }
            } 
        }
        
        List<ProductPrices__c> productPrices = [SELECT Id, 
                                                        Name, 
                                                        Ordering_Number__c, 
                                                        Product_Center__c, 
                                                        Product_Series__c, 
                                                        Product_Owner__c, 
                                                        Valid_From__c, 
                                                        Map_Pricing_OR__c, 
                                                        Max_MAP_Pricing_Min__c, 
                                                        is_most_recent__c 
                                                        FROM ProductPrices__c 
                                                        WHERE Ordering_Number__c in :productCodes];
        List<ProductPrices__c> modifiedProductPrices = new List<ProductPrices__c>();
        Map<String, ProductPrices__c> mostRecentProductPrices = ProductPricesTriggerHelper.getEvalMostRecentProductPrices(productPrices);
        System.debug('-----------------');
        for (ProductPrices__c productPrice : productPrices) 
        {
            System.debug('-------'+productPrice.Name+'----------');
            Boolean isModified = false;
            if(selectedProducts.containsKey(productPrice.Ordering_Number__c)) 
            {
                Product2 selectedProduct = selectedProducts.get(productPrice.Ordering_Number__c);
                if(productPrice.Product_Center__c != selectedProduct.Product_Center__c || productPrice.Product_Series__c != selectedProduct.Product_Series__c || productPrice.Product_Owner__c  != selectedProduct.Product_Owner__c)
                {
                  productPrice.Product_Center__c = selectedProduct.Product_Center__c;
                  productPrice.Product_Series__c = selectedProduct.Product_Series__c;
                  productPrice.Product_Owner__c  = selectedProduct.Product_Owner__c; 
                  isModified = true;
                }
            }
            else
            {
                if(productPrice.Product_Center__c != null || productPrice.Product_Series__c != null || productPrice.Product_Owner__c  != null)
                {
                    productPrice.Product_Center__c = null;
                    productPrice.Product_Series__c = null;
                    productPrice.Product_Owner__c  = null;
                    isModified = true;
                }
            }
            
            ProductPrices__c selectedMostRecentProductPrice = mostRecentProductPrices.get(productPrice.Ordering_Number__c);
            if(selectedMostRecentProductPrice.Id == productPrice.Id)
            {
                if(productPrice.is_most_recent__c == false) 
                {
                    System.debug('-------set to true----------');
                    productPrice.is_most_recent__c = true;
                    isModified = true;
                }
            }
            else
            {
                if(productPrice.is_most_recent__c == true) 
                {
                    System.debug('-------set to false----------');
                    productPrice.is_most_recent__c = false;
                    isModified = true;
                }
            }
            
            if(productMapPricing.containsKey(productPrice.Ordering_Number__c)) 
            {
                Boolean selectedMapPricing = productMapPricing.get(productPrice.Ordering_Number__c);
                if(productPrice.Map_Pricing_OR__c != selectedMapPricing)
                {
                  productPrice.Map_Pricing_OR__c = selectedMapPricing;
                  isModified = true;
                }
            }
            else
            {
                if(productPrice.Map_Pricing_OR__c == true)
                {
                    productPrice.Map_Pricing_OR__c = false;
                    isModified = true;
                }
            }
            
            if(productMinimumMaxMapPricing.containsKey(productPrice.Ordering_Number__c)) 
            {
                String selectedMaxMapPricing = productMinimumMaxMapPricing.get(productPrice.Ordering_Number__c);
                if(productPrice.Max_MAP_Pricing_Min__c != selectedMaxMapPricing)
                {
                  productPrice.Max_MAP_Pricing_Min__c = selectedMaxMapPricing;
                  isModified = true;
                }
            }
            else
            {
                if(productPrice.Max_MAP_Pricing_Min__c != null)
                {
                    productPrice.Max_MAP_Pricing_Min__c = null;
                    isModified = true;
                }
            }
                
            
            
                
            if(isModified == true) 
            {
                System.debug('-------is modified----------');
                modifiedProductPrices.add(productPrice);        
            }
        }
        
        update modifiedProductPrices;
    }
    
    // ---- product prices helpers --------------------------------------------------------------------------------------------------------
     
    public static Map<String, ProductPrices__c> getEvalMostRecentProductPrices(List<ProductPrices__c> productPrices)
    {
        Map<String, ProductPrices__c> mostRecentProductPrices = new Map<String, ProductPrices__c>();
        for (ProductPrices__c productPrice :productPrices) 
        {
            if(mostRecentProductPrices.containsKey(productPrice.Ordering_Number__c)) 
            {
                ProductPrices__c selectedProductPrice = mostRecentProductPrices.get(productPrice.Ordering_Number__c);
                if(productPrice.Valid_From__c > selectedProductPrice.Valid_From__c) 
                {
                    mostRecentProductPrices.put(productPrice.Ordering_Number__c, productPrice);
                }
            }
            else
            {
                mostRecentProductPrices.put(productPrice.Ordering_Number__c, productPrice);
            }
        }
        
        return mostRecentProductPrices;
    }
    
     public static Set<String> afterInsertUpdateProductPricesGetProductCodes(List<ProductPrices__c> triggerNew, Map<Id, ProductPrices__c> triggerNewMap) {
            
        Set<String> productCodes = new Set<String>();
        for (ProductPrices__c productPrice :triggerNew) {
            ProductPrices__c newProductPrice = triggerNewMap.get(productPrice.ID);         
            productCodes.add(newProductPrice.Ordering_Number__c);
        }

        return productCodes;
    }
    

    
    // --- general helpers  --------------------------------------------------------------------------------------------------------
    
    /**
     * returns a rating for the product based on the Product Status
     * returns 0 if the Product does not contain a Product Status
     *  
     */
    public static Integer rateProductStatus(Product2 product) 
    {
        Integer rate = 0;
        if(product.Product_Status__c != null) 
        {
  
            switch on product.Product_Status__c
            {
                when 'Mass Production' {
                    rate = 10;
                }   
                when 'Initial Production' {     
                    rate = 9;
                }
                when 'Engineering Samples' {        
                    rate = 8;
                }
                when 'Prototypes' {     
                   rate = 7;
                }
                when 'End of Life' {        
                    rate = 6;
                }
                when 'In Development' {     
                    rate = 5;
                }
                when else {       
                    rate = 0;
                }
            }
        }
        
        return rate;
    }
    
    /**
     * compares the Product Status rating of two Products.
     * returns FALSE by default
     * returns TRUE if the rating of ProductA is higher than the rating of ProductB
     * returns TRUE if the rating of ProductA is equal to the rating of ProductB, but ProductA was modified more recently
     */
    public static Boolean isProductAHigherRatedThanProductB(Product2 productA, Product2 productB)
    {
        Boolean check = false;
        Integer ProductARate = rateProductStatus(productA);
        Integer ProductBRate = rateProductStatus(productB);
        if(ProductARate > ProductBRate )
        {
            check = true; 
        }
        else 
        {
            if(ProductARate == ProductBRate) 
            {
                if(productA.SystemModstamp > productB.SystemModstamp)
                {
                     check = true;
                }
            }
        }

        
        return check;
    }
    
    /**
     * compares the Product Status rating of two Products.
     * returns FALSE by default
     * returns TRUE if MaxMapPricingA is higher than MaxMapPricingB
     * returns FALS if MaxMapPricingA is equal to MaxMapPricingB
     */
    public static Boolean isMaxMapPricingBLowerThanA(String maxMapPricingA, String maxMapPricingB)
    {
        Boolean isLower = false;
        Integer maxMapPricingAInt = 0;
        Integer maxMapPricingBInt = 0;
        if(maxMapPricingA != null) 
        {
           maxMapPricingAInt = integer.valueof(maxMapPricingA); 
        }
        
        if(maxMapPricingB != null) 
        {
           maxMapPricingBInt = integer.valueof(maxMapPricingB);
        }
        
        
        if(maxMapPricingAInt > maxMapPricingBInt )
        {
            isLower = true; 
        }
     
        
        return isLower;
    }
}
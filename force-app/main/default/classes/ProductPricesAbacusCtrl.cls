public with sharing class ProductPricesAbacusCtrl {

    //public List<AbacusProductPrices> productPrices{get; set;}
    public ProductPricesAbacusCtrl()
    {
    } 
    
    @AuraEnabled
    /***
     * Id productId - the Id of the product you want to get Product Prices for
     * 
     * takes a product Id and returns Product Prices in the MapProductsPrices type for it
     */
    public static List<MapProductPrices> getProductsPricesByProductId(Id productId)
    {
        Product2 product = getProductByProductId(productId);

        List<MapProductPrices> mapProductPrices = new List<MapProductPrices>();
        if( product != null )
        { 
            List<ProductPrices__c> productPrices = getProductsPricesByProductCode(product.ProductCode);
            for (ProductPrices__c pp :productPrices)
            {
                mapProductPrices.add(mapProductPricesFactory(pp, product));
            }
        }
        
        return mapProductPrices;
    }
    
    public static List<ProductPrices__c> getProductsPricesByProductCode(String productCode)
    {
        List<ProductPrices__c> productPrices = new List<ProductPrices__c>();
      
        productPrices = [Select Id, Name, Product_Name__c, Ordering_Number__c, Price_USD_Sample_Size_1__c, Price_USD_Sample_Size_10__c ,Price_USD_Sample_Size_50__c, Price_USD_Sample_Size_100__c, Price_USD_Sample_Size_250__c, Price_USD_Sample_Size_500__c, Price_USD_Sample_Size_1000__c, Valid_From__c from ProductPrices__c WHERE Ordering_Number__c =: productCode];
        
        return productPrices;
    }
    
      
    @AuraEnabled
    public static List<MapProductPrices> getMapProductsPrices(Id productId)
    {
        System.debug('getMapProductsPrices');
        List<MapProductPrices> data = new List<MapProductPrices>();
        List<String> orderingNumbers = new List<String>(); 
        List<ProductPrices__c> productPrices = new List<ProductPrices__c>();
        if(productId != null)
        {
            Product2 product = getProductByProductId(productId);
            if(product != null) {
                productPrices = getProductsPricesByProductCode(product.ProductCode);
            }
        }
        else
        {
            productPrices = [Select Id, Name, Product_Name__c, Ordering_Number__c, Price_USD_Sample_Size_1__c, Price_USD_Sample_Size_10__c, Price_USD_Sample_Size_50__c, Price_USD_Sample_Size_100__c, Price_USD_Sample_Size_250__c, Price_USD_Sample_Size_500__c, Price_USD_Sample_Size_1000__c, Valid_From__c from ProductPrices__c];
        }
        
        Map<String, ProductPrices__c> productPricesMap = new Map<String, ProductPrices__c>();
        
        for (ProductPrices__c pp :productPrices)
        {
            if(productPricesMap.containsKey(pp.Ordering_Number__c))
            {
                if(productPricesMap.get(pp.Ordering_Number__c).Valid_From__c < pp.Valid_From__c)  
                {
                    productPricesMap.put(pp.Ordering_Number__c, pp);
                }
            }
            else
            {
                productPricesMap.put(pp.Ordering_Number__c, pp);
            }
            //data.add(pp);
        }
        
        for(String mapKey: productPricesMap.keySet())
        {
            orderingNumbers.add( productPricesMap.get(mapKey).Ordering_Number__c);
        }
        
        List<Product2> products = [Select Id, Name, ProductCode, Description, Product_Center__c, Packaging_Size__c, MAP_pricing__c, max_MAP_pricing__c,
                                   Positioning_Engine__c, Cellular_Technology__c, Short_Range_Technology__c, Abacus_Konditionsnummer_101__c, 
                                   Abacus_Konditionsnummer_102__c, Abacus_Konditionsnummer_103__c, Product_Status__c, Shop_Active__c from Product2 WHERE ProductCode IN: orderingNumbers ];
        
        for(String mapKey: productPricesMap.keySet())
        {
            Product2 selectedProduct = null;
            
            for (Product2 product :products)
            {
                if(product.ProductCode == productPricesMap.get(mapKey).Ordering_Number__c)
                {
                    if(selectedProduct == null)
                    {
                        selectedProduct = product;
                    }
                    else
                    {
                        if(product.MAP_pricing__c == true && selectedProduct.MAP_pricing__c == true)
                        {
                            if(product.Product_Status__c == 'Engineering Samples' || 
                               product.Product_Status__c == 'Production Ready'|| 
                               product.Product_Status__c == 'Initial Production' || 
                               product.Product_Status__c == 'Mass Production' || 
                               product.Product_Status__c == 'End of Life')
                            {
                                if(!(
                                       selectedProduct.Product_Status__c == 'Engineering Samples' || 
                                       selectedProduct.Product_Status__c == 'Production Ready'|| 
                                       selectedProduct.Product_Status__c == 'Initial Production' ||  
                                       selectedProduct.Product_Status__c == 'Mass Production' || 
                                       selectedProduct.Product_Status__c == 'End of Life')
                                    )
                                {
                                    selectedProduct = product;
                                }
                            }
                        }
                        
                        if(product.MAP_pricing__c == true && selectedProduct.MAP_pricing__c == false)
                        {
                            selectedProduct = product;
                        }
                    }
                 
                }
            } 
            if(selectedProduct != null && selectedProduct.MAP_pricing__c == true) {
              data.add(mapProductPricesFactory(productPricesMap.get(mapKey),selectedProduct)); 
            }
        }
        System.debug('getMapProductsPrices END');
        return data;    
    }
    
    @AuraEnabled
    public static List<MapProductPrices> getProductsPrices()
    {
        System.debug('getProductsPrices');
        List<MapProductPrices> data = new List<MapProductPrices>();
        List<String> orderingNumbers = new List<String>(); 
        List<ProductPrices__c> productPrices = [Select Id, Name, Product_Name__c, Ordering_Number__c, Price_USD_Sample_Size_1__c, Price_USD_Sample_Size_10__c, Price_USD_Sample_Size_50__c, Price_USD_Sample_Size_100__c, Price_USD_Sample_Size_250__c, Price_USD_Sample_Size_500__c, Price_USD_Sample_Size_1000__c, Valid_From__c from ProductPrices__c];
      
        for (ProductPrices__c pp :productPrices)
        {
            orderingNumbers.add(pp.Ordering_Number__c);
            //data.add(pp);
        }
        List<Product2> products = [Select Id, Name, ProductCode, Description, Product_Center__c, Packaging_Size__c, MAP_pricing__c, max_MAP_pricing__c,
                                   Positioning_Engine__c, Cellular_Technology__c, Short_Range_Technology__c, Abacus_Konditionsnummer_101__c,
                                   Abacus_Konditionsnummer_102__c, Abacus_Konditionsnummer_103__c, Product_Status__c, Shop_Active__c from Product2 WHERE ProductCode IN: orderingNumbers ];
        
        for (ProductPrices__c productPrice :productPrices)
        {
            for (Product2 product :products)
            {
                if(product.ProductCode == productPrice.Ordering_Number__c)
                {
                   data.add(mapProductPricesFactory(productPrice,product));
                }
            } 
           
        }
        System.debug('getProductsPrices END');
        return data;    
    }
      
    @AuraEnabled
    public static List<MapProductPrices> getProductsByProductPriceId(Id productPriceId)
    {
        List<MapProductPrices> mapProducts = new List<MapProductPrices>();
        
        List<ProductPrices__c> productPrices = [Select Id, Name, Product_Name__c, Ordering_Number__c, Price_USD_Sample_Size_1__c, Price_USD_Sample_Size_10__c, Price_USD_Sample_Size_50__c, Price_USD_Sample_Size_100__c, Price_USD_Sample_Size_250__c, Price_USD_Sample_Size_500__c, Price_USD_Sample_Size_1000__c, Valid_From__c from ProductPrices__c Where Id =:productPriceId];
        if( !productPrices.isEmpty() && (productPrices.size() == 1))
        {
           List<Product2> products = [Select Id, Name, ProductCode, Description, Product_Center__c, Packaging_Size__c, MAP_pricing__c, max_MAP_pricing__c,
                        Positioning_Engine__c, Cellular_Technology__c, Short_Range_Technology__c, Abacus_Konditionsnummer_101__c,
                        Abacus_Konditionsnummer_102__c, Abacus_Konditionsnummer_103__c, Product_Status__c, Shop_Active__c from Product2 WHERE ProductCode =: productPrices.get(0).Ordering_Number__c ];
            
           for(Product2 product: products)
           {
                mapProducts.add(mapProductPricesFactory(productPrices.get(0), product));
           }
        }
      
        return mapProducts;    
    }
    
    @AuraEnabled
    public static Product2 getProductByProductId(Id productId)
    {
        Product2 product;
        
        List<Product2> products = [Select Id, Name, ProductCode, Description, Product_Center__c, Packaging_Size__c, MAP_pricing__c, max_MAP_pricing__c, Positioning_Engine__c, Cellular_Technology__c, Short_Range_Technology__c, Abacus_Konditionsnummer_101__c, Abacus_Konditionsnummer_102__c, Abacus_Konditionsnummer_103__c, Product_Status__c, Shop_Active__c from Product2 WHERE Id =: productId ];
        if( !products.isEmpty() && (products.size() == 1))
        {
            product = products.get(0);
        }
        
        return product;    
    }
    
    @AuraEnabled
    public static List<ProductPriceForCaclulator> getProductPriceCalculatorDataByOppProdId(Id oppProdId)
    {
        List<ProductPriceForCaclulator> data = new List<ProductPriceForCaclulator>();
        List<Opp_Product__c> oppProduct = [Select Id, Product__c, CurrencyIsoCode, Annual_Quantity__c  from Opp_Product__c Where Id =: oppProdId];
        
        if(oppProduct != null && oppProduct.size() >= 1 ) 
        {
            List<Product2> products = [Select Id, Name, ProductCode, Description, MAP_pricing__c, max_MAP_pricing__c from Product2 WHERE Id =: oppProduct[0].Product__c ];
             
            List<ProductPrices__c> productPrices = [Select Id, Name, Ordering_Number__c, Price_USD_Sample_Size_1__c, Price_USD_Sample_Size_10__c ,Price_USD_Sample_Size_50__c, Price_USD_Sample_Size_100__c, Price_USD_Sample_Size_250__c, Price_USD_Sample_Size_500__c, Price_USD_Sample_Size_1000__c, Valid_From__c from ProductPrices__c Where Ordering_Number__c =:products[0].ProductCode];
            
            ProductPricesCurrencyConversionRates__c obj = [select id, Conversion_Rate_EUR__c, Conversion_Rate_CHF__c, Conversion_Rate_JPY__c from ProductPricesCurrencyConversionRates__c];
            //system.debug(obj);
            Double rateEUR = obj.Conversion_Rate_EUR__c;
          
            for(ProductPrices__c pp : productPrices)
            {
                ProductPriceForCaclulator pCal = new ProductPriceForCaclulator();
                pCal.amount = oppProduct[0].Annual_Quantity__c;
                pCal.priceCurrency = oppProduct[0].CurrencyIsoCode;
                pCal.priceMod = 1;
                if(oppProduct[0].CurrencyIsoCode == 'EUR')
                {
                    pCal.priceMod = obj.Conversion_Rate_EUR__c;
                }
                if(oppProduct[0].CurrencyIsoCode == 'CHF')
                {
                    pCal.priceMod = obj.Conversion_Rate_CHF__c;
                }
                if(oppProduct[0].CurrencyIsoCode == 'JPY')
                {
                    pCal.priceMod = obj.Conversion_Rate_JPY__c;
                }
                pCal.priceSampleSize1 = pp.Price_USD_Sample_Size_1__c;
                pCal.priceSampleSize10 = pp.Price_USD_Sample_Size_10__c;
                pCal.priceSampleSize50 = pp.Price_USD_Sample_Size_50__c;
                pCal.priceSampleSize100 = pp.Price_USD_Sample_Size_100__c;
                pCal.priceSampleSize250 = pp.Price_USD_Sample_Size_250__c;
                pCal.priceSampleSize500 = pp.Price_USD_Sample_Size_500__c;
                pCal.priceSampleSize1000 = pp.Price_USD_Sample_Size_1000__c;
                pCal.validFrom = pp.Valid_From__c;
                 
                data.add(pCal);
            }
        }
      
        return data;    
    }
    /*
    @AuraEnabled
    public static List<AbacusProductPrices> getAbacusProductsPricesByProductId(Id productId, Boolean allProducts)
    {
        List<AbacusProductPrices> abacusProductPrices = new List<AbacusProductPrices>();
        List<MapProductPrices> mapProductPrices = getMapProductsPrices(productId);
        
        ProductPricesCurrencyConversionRates__c obj = [select id, Conversion_Rate_EUR__c from ProductPricesCurrencyConversionRates__c];
        //system.debug(obj);
        Double rateEUR = obj.Conversion_Rate_EUR__c;
        
       
        for(MapProductPrices element: mapProductPrices)
        {
            if(allProducts == true || element.productStatus == 'Engineering Samples' || element.productStatus == 'Production Ready'|| element.productStatus == 'Initial Production' || element.productStatus == 'Mass Production' || element.productStatus == 'End of Life')
            {
                abacusProductPrices.addAll(abacusProductPriceFactoryList(element, 101, 'USD', 1.0, element.konditionsnummer_101));   
            }
        } 
 
        for(MapProductPrices element: mapProductPrices)
        {
            if(allProducts == true || element.productStatus == 'Engineering Samples' || element.productStatus == 'Production Ready'|| element.productStatus == 'Initial Production' || element.productStatus == 'Mass Production' || element.productStatus == 'End of Life')
            {
                abacusProductPrices.addAll(abacusProductPriceFactoryList(element, 102, 'EUR', rateEUR, element.konditionsnummer_102));
            }
        } 
        
        for(MapProductPrices element: mapProductPrices)
        {
            if(allProducts == true || element.productStatus == 'Engineering Samples' || element.productStatus == 'Production Ready'|| element.productStatus == 'Initial Production' || element.productStatus == 'Mass Production' || element.productStatus == 'End of Life')
            {
                abacusProductPrices.addAll(abacusProductPriceFactoryList(element, 103, 'USD', 1.0, element.konditionsnummer_103));
            }
        } 
        
        return abacusProductPrices;
    }*/
    
    @AuraEnabled
    public static List<AbacusProductPrices> getAbacusProductsPrices(Id productId, Boolean allProducts)
    {
        List<AbacusProductPrices> abacusProductPrices = new List<AbacusProductPrices>();
        List<MapProductPrices> mapProductPrices;
        if(productId != null)
        {
            mapProductPrices = getProductsPricesByProductId(productId);
        }
        else
        {
            mapProductPrices = getProductsPrices();
        }
               
        ProductPricesCurrencyConversionRates__c obj = [select id, Conversion_Rate_EUR__c from ProductPricesCurrencyConversionRates__c];
        //system.debug(obj);
        Double rateEUR = obj.Conversion_Rate_EUR__c;
        
       
        for(MapProductPrices element: mapProductPrices)
        {
            if(allProducts == true || ((element.productStatus == 'Engineering Samples' || element.productStatus == 'Production Ready'|| element.productStatus == 'Initial Production' || element.productStatus == 'Mass Production' || element.productStatus == 'End of Life') && element.soldInWebShop == true))              
            {
                abacusProductPrices.addAll(abacusProductPriceFactoryList(element, 101, 'USD', 1.0, element.konditionsnummer_101));   
            }
        } 
 
        for(MapProductPrices element: mapProductPrices)
        {
            if(allProducts == true || ((element.productStatus == 'Engineering Samples' || element.productStatus == 'Production Ready'|| element.productStatus == 'Initial Production' || element.productStatus == 'Mass Production' || element.productStatus == 'End of Life') && element.soldInWebShop == true))
            {
                abacusProductPrices.addAll(abacusProductPriceFactoryList(element, 102, 'EUR', rateEUR, element.konditionsnummer_102));
            }
        } 
        
        for(MapProductPrices element: mapProductPrices)
        {
            if(allProducts == true || ((element.productStatus == 'Engineering Samples' || element.productStatus == 'Production Ready'|| element.productStatus == 'Initial Production' || element.productStatus == 'Mass Production' || element.productStatus == 'End of Life') && element.soldInWebShop == true))
            {
                abacusProductPrices.addAll(abacusProductPriceFactoryList(element, 103, 'USD', 1.0, element.konditionsnummer_103));
            }
        } 
                         
        return abacusProductPrices;
    }
    
    @AuraEnabled
    public static List<Product2> getProductByProductPrice(ProductPrices__c pp)
    {
        if(pp != null) {
            return [Select Id, Name, ProductCode, Description, Product_Center__c, Packaging_Size__c,  MAP_pricing__c, max_MAP_pricing__c, Positioning_Engine__c, Cellular_Technology__c, Short_Range_Technology__c, Abacus_Konditionsnummer_101__c, Abacus_Konditionsnummer_102__c, Abacus_Konditionsnummer_103__c, Product_Status__c, Shop_Active__c from Product2 WHERE ProductCode =: pp.Ordering_Number__c ];
        }
        else
        {
            return null;
        }
    }
    
    @TestVisible private static List<AbacusProductPrices> abacusProductPriceFactoryList(MapProductPrices p, Integer customerGroup,  String priceCurrency, Decimal priceMod, Decimal konditionsnummer)
    {
        List<AbacusProductPrices> abacusProductPrices = new List<AbacusProductPrices>();         
        if(p!= null && p.maxMapPricing != null)        
        {
            /*Decimal maxSeriesToAmount = 2499;
            
            if(p.priceSampleSize1 != NULL && p.priceSampleSize10 != NULL && p.moq >= 1 && p.moq >= 10)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, 9, p.priceSampleSize1 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            } 
            
            if(p.priceSampleSize1 != NULL && p.priceSampleSize10 == NULL && p.priceSampleSize50 == NULL && p.priceSampleSize100 == NULL && p.priceSampleSize250 == NULL && p.priceSampleSize500 == NULL && p.priceSampleSize1000 == NULL)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, maxSeriesToAmount, p.priceSampleSize1 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize10 != NULL && p.priceSampleSize50 != NULL)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, 49, p.priceSampleSize10 * priceMod  );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize10 != NULL && p.priceSampleSize50 == NULL && p.priceSampleSize100 == NULL && p.priceSampleSize250 == NULL && p.priceSampleSize500 == NULL && p.priceSampleSize1000 == NULL)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, maxSeriesToAmount, p.priceSampleSize10 * priceMod  );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize50 != NULL && p.priceSampleSize100 != NULL)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, 99, p.priceSampleSize50 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize50 != NULL && p.priceSampleSize100 == NULL && p.priceSampleSize250 == NULL && p.priceSampleSize500 == NULL && p.priceSampleSize1000 == NULL)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, maxSeriesToAmount, p.priceSampleSize50 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize100 != NULL && p.priceSampleSize250 != NULL )
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, 249, p.priceSampleSize100 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize100 != NULL && p.priceSampleSize250 == NULL && p.priceSampleSize500 == NULL && p.priceSampleSize1000 == NULL)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, maxSeriesToAmount, p.priceSampleSize100 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize250 != NULL && p.priceSampleSize500 != NULL)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, 499, p.priceSampleSize250 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize250 != NULL && p.priceSampleSize500 == NULL && p.priceSampleSize1000 == NULL)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, maxSeriesToAmount, p.priceSampleSize250 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
                       
            if(p.priceSampleSize500 != NULL && p.priceSampleSize1000 != NULL)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, 999, p.priceSampleSize500 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize500 != NULL && p.priceSampleSize1000 == NULL)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, maxSeriesToAmount, p.priceSampleSize500 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize1000 != NULL)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, 2499, p.priceSampleSize1000 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }*/
            
            if(p.priceSampleSize1 != NULL && p.priceSampleSize1 != NULL  && p.priceSampleSize1 != 0.0000 && p.maxMapPricing >= 1 && p.maxMapPricing >= 10)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, 9, p.priceSampleSize1 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            } 
            
            if(p.priceSampleSize1 != NULL && p.priceSampleSize1 != 0.0000 && p.maxMapPricing >= 1 && p.maxMapPricing < 10)
            {
                Decimal maxMapPricing = p.maxMapPricing-1;
                if(maxMapPricing == 0)
                {
                    maxMapPricing = 1;
                }
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, maxMapPricing, p.priceSampleSize1 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize10!= NULL && p.priceSampleSize50 != NULL && p.priceSampleSize10 != 0.0000 && p.maxMapPricing > 10 && p.maxMapPricing >= 50)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, 49, p.priceSampleSize10 * priceMod  );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize10!= NULL && p.maxMapPricing > 10 && p.priceSampleSize10 != 0.0000 && p.maxMapPricing < 50)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, p.maxMapPricing-1, p.priceSampleSize10 * priceMod  );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize50 != NULL && p.priceSampleSize100 != NULL && p.priceSampleSize50 != 0.0000 &&  p.maxMapPricing > 50 && p.maxMapPricing >= 100)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, 99, p.priceSampleSize50 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize50 != NULL &&  p.maxMapPricing > 50 && p.priceSampleSize50 != 0.0000 && p.maxMapPricing < 100)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, p.maxMapPricing-1, p.priceSampleSize50 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize100 != NULL && p.priceSampleSize250 != NULL && p.priceSampleSize100 != 0.0000 && p.maxMapPricing > 100 && p.maxMapPricing >= 250)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, 249, p.priceSampleSize100 * priceMod  );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            if(p.priceSampleSize100 != NULL &&  p.maxMapPricing > 100 && p.priceSampleSize100 != 0.0000 && p.maxMapPricing < 250)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, p.maxMapPricing-1, p.priceSampleSize100 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize250 != NULL && p.priceSampleSize500 != NULL && p.priceSampleSize250 != 0.0000 && p.maxMapPricing > 250 && p.maxMapPricing >= 500)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, 499, p.priceSampleSize250 * priceMod  );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            if(p.priceSampleSize250 != NULL &&  p.maxMapPricing > 250 && p.priceSampleSize250 != 0.0000 && p.maxMapPricing < 500)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, p.maxMapPricing-1, p.priceSampleSize250 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            
            if(p.priceSampleSize500 != NULL && p.priceSampleSize1000 != NULL && p.priceSampleSize500 != 0.0000 && p.maxMapPricing > 500 && p.maxMapPricing >= 1000)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, 999, p.priceSampleSize500 * priceMod  );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
            if(p.priceSampleSize500 != NULL &&  p.maxMapPricing > 500 && p.priceSampleSize500 != 0.0000 && p.maxMapPricing < 1000)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, p.maxMapPricing-1, p.priceSampleSize500 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }

            if(p.priceSampleSize1000 != NULL && p.priceSampleSize1000 != 0.0000 && p.maxMapPricing > 1000)
            {
                AbacusProductPrices temp_product_prices_abacus =  abacusProductPriceFactory(p, konditionsnummer, priceCurrency , customerGroup, p.maxMapPricing-1, p.priceSampleSize1000 * priceMod );
                abacusProductPrices.add(temp_product_prices_abacus );
            }
        }
        System.debug(abacusProductPrices);
        return abacusProductPrices;
    }
    
    @TestVisible private static MapProductPrices mapProductPricesFactory(ProductPrices__c pp, Product2 product)
    {
        MapProductPrices temp = new MapProductPrices();
        if( pp != null ) {
            temp.id = pp.Id;
            temp.link = '/' + pp.Id;
            temp.name = pp.Name;
            temp.productName = pp.Product_Name__c;
            temp.orderingNumber = pp.Ordering_Number__c;
            temp.validFrom = pp.Valid_From__c;
            temp.moq = 1;
            if(pp.Price_USD_Sample_Size_1__c != null && pp.Price_USD_Sample_Size_1__c != 0.0000)
            {
                temp.priceSampleSize1 = pp.Price_USD_Sample_Size_1__c;
            }
            else
            {
               temp.priceSampleSize1 = null;
            }
            
            if(pp.Price_USD_Sample_Size_10__c != null && pp.Price_USD_Sample_Size_10__c != 0.0000)
            {
                temp.priceSampleSize10 = pp.Price_USD_Sample_Size_10__c;
            }
            else
            {
               temp.priceSampleSize10 = null;
            }
            
            if(pp.Price_USD_Sample_Size_50__c != null && pp.Price_USD_Sample_Size_50__c != 0.0000)
            {
                temp.priceSampleSize50 = pp.Price_USD_Sample_Size_50__c;
            }
            else
            {
               temp.priceSampleSize50 = null;
            }
            
            if(pp.Price_USD_Sample_Size_100__c != null && pp.Price_USD_Sample_Size_100__c != 0.0000)
            {
                temp.priceSampleSize100 = pp.Price_USD_Sample_Size_100__c;
            }
            else
            {
               temp.priceSampleSize100 = null;
            }
            
            if(pp.Price_USD_Sample_Size_250__c != null && pp.Price_USD_Sample_Size_250__c != 0.0000)
            {
                temp.priceSampleSize250 = pp.Price_USD_Sample_Size_250__c;
            }
            else
            {
               temp.priceSampleSize250 = null;
            }
            
            if(pp.Price_USD_Sample_Size_500__c != null && pp.Price_USD_Sample_Size_500__c != 0.0000)
            {
                temp.priceSampleSize500 = pp.Price_USD_Sample_Size_500__c;
            }
            else
            {
               temp.priceSampleSize500 = null;
            }
            
            if(pp.Price_USD_Sample_Size_1000__c != null && pp.Price_USD_Sample_Size_1000__c != 0.0000)
            {
                temp.priceSampleSize1000 = pp.Price_USD_Sample_Size_1000__c;
            }
            else
            {
               temp.priceSampleSize1000 = null;
            }
        }
        
        if(product != null)
        {
            temp.moq = product.Packaging_Size__c;
            temp.productId = product.id;
            temp.productLink = '/' + product.id;
            temp.productStatus = product.Product_Status__c;
            temp.konditionsnummer_101 = product.Abacus_Konditionsnummer_101__c;
            temp.konditionsnummer_102 = product.Abacus_Konditionsnummer_102__c;
            temp.konditionsnummer_103 = product.Abacus_Konditionsnummer_103__c;
                    
            temp.description = product.Description;
            if(temp.description != null )
            {
                temp.description = temp.description.replace('\r\n', ' ');
                temp.description = temp.description.replace('\n', ' ');
                temp.description = temp.description.replace('\r', ' ');
            }
            temp.productCenter = product.Product_Center__c;
            if(product.Product_Center__c == 'Cellular')
            {
                temp.technology = product.Cellular_Technology__c;
            }
            if(product.Product_Center__c == 'Positioning')
            {
                temp.technology = product.Positioning_Engine__c;
            }
            if(product.Product_Center__c == 'Short Range')
            {
                temp.technology = product.Short_Range_Technology__c;
            }
            
            temp.soldInWebShop = product.Shop_Active__c;
            temp.mapPricing    = product.MAP_pricing__c;
            if(product.max_MAP_pricing__c != null) {
              temp.maxMapPricing = decimal.valueOf(product.max_MAP_pricing__c);
            }
        }
 
        return temp;
    }
    
    @TestVisible private static AbacusProductPrices abacusProductPriceFactory(MapProductPrices mpp, Decimal konditionsnummer, String priceCurrency, Integer customerGroup, Decimal seriesToAmount, Decimal seriesPrice )
    {
        AbacusProductPrices temp_product_prices_abacus = new AbacusProductPrices();
            
        if(konditionsnummer != null)
        {
           temp_product_prices_abacus.conditionNumber = String.valueOf(konditionsnummer);   
        }
        else
        {
           temp_product_prices_abacus.conditionNumber = ''; 
        }
          
        temp_product_prices_abacus.priceCurrency=  priceCurrency;
        temp_product_prices_abacus.customerCategory=  'Gruppe';
        temp_product_prices_abacus.customerGroupNumber =  customerGroup;
        temp_product_prices_abacus.productCategory=  'Gruppe';
        Datetime myDT = Datetime.now();
        if(mpp != null && mpp.validFrom != NULL)
        {
            Time myTime = Time.newInstance(0, 0, 0, 0);
            myDT = Datetime.newInstance(mpp.validFrom, myTime);
        }
        
        temp_product_prices_abacus.startDate= myDT.format('dd.MM.YYYY');
        if(mpp != null )
        {
            temp_product_prices_abacus.productId = mpp.productId;
            temp_product_prices_abacus.productLink = mpp.productLink;
            temp_product_prices_abacus.id = mpp.name+'-'+customerGroup+'-'+seriesToAmount;
            temp_product_prices_abacus.link = mpp.link;
            temp_product_prices_abacus.name =  mpp.name;
            temp_product_prices_abacus.orderingNumber =  mpp.orderingNumber;
        }
        
        temp_product_prices_abacus.seriesToAmount = seriesToAmount;
        
        if(seriesPrice != null ) { 
            //temp_product_prices_abacus.seriesPrice= seriesPrice;
            temp_product_prices_abacus.seriesPrice= seriesPrice.setScale(2, RoundingMode.HALF_UP);
        }
        return temp_product_prices_abacus;
    }
}
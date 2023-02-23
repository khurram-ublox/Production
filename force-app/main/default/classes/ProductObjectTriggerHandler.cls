public class ProductObjectTriggerHandler {
    public static final String ERROR_MESSAGE = 'Product linked to Abacus. Name, Ordering No, Type No, Status, and Product Text are not modifiable.';
    
    public static void preventUpdateAbacusProduct(map<Id, Product2> ProdMap){
        for(product2  newProd : ProdMap.values()){
            product2 oldProd = (product2) trigger.oldMap.get(newProd.Id);
            if(newProd.From_Abacus__c){
                
                if(newProd.Name!=oldProd.Name){
                    newProd.Name.addError(ERROR_MESSAGE);
                }
                if(newProd.ProductCode!=oldProd.ProductCode){
                    newProd.ProductCode.addError(ERROR_MESSAGE);
                }
                if(newProd.Type_No__c!=oldProd.Type_No__c){
                    newProd.Type_No__c.addError(ERROR_MESSAGE);
                }
                if(newProd.Product_Status__c!=oldProd.Product_Status__c){
                    newProd.Product_Status__c.addError(ERROR_MESSAGE);
                }
                if(newProd.Product_Text_1__c!=oldProd.Product_Text_1__c){
                    newProd.Product_Text_1__c.addError(ERROR_MESSAGE);
                }
                if(newProd.Product_Text_2__c!=oldProd.Product_Text_2__c){
                    newProd.Product_Text_2__c.addError(ERROR_MESSAGE);
                }
            }
        }
    }
    
    // Commenting out this(upsertCustomProduct) method. It is for the removal of custom Product obj. By ufar, 12-6-22.
    /*
    public static List<product__c> upsertCustomProduct(Map<Id,product2> standardProdMap){
        
        //Retrieve All the Fields from the Product Object
        Schema.DescribeSObjectResult prodFields =   Product2.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> prodFieldsMap =   prodFields.fields.getMap();
        
        //Retrieve All the Fields from Product__c Object
        Schema.DescribeSObjectResult cprodFields =   Product__c.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> cprodFieldsMap =   cprodFields.fields.getMap();
        
        List<Product__c> prodList = new List<Product__c>(); // To add the products in Custom Product
        List<Product__c> cProdList = new List<Product__c> ();
        
        List<string> cProdFieldList = new List<string>();
        List<string> prodFieldsList = new List<string>(); // To retrieve all the fields
        
        //Update Changes
        Map<Id,Id> updateCustomProduct = new Map<Id,Id>();
        
        if(!standardProdMap.isEmpty()){
            cProdList = [select Id, Referred_Product__c from Product__c where Id != ''  AND Referred_Product__c =: standardProdMap.keySet() ];
        }
        
        for(Schema.SObjectField checkFieldType : cprodFieldsMap.values()){
            if(!cprodFieldsMap.get(string.valueof(checkFieldType)).getDescribe().isCalculated()){
                cProdFieldList.add(string.valueOf(checkFieldType).toLowerCase());
            }
        }
        
        if(!cProdList.isEmpty()){
            for(Product__c cProd:cProdList){
                updateCustomProduct.put(cProd.Referred_Product__c,cProd.Id);  
            }
        }
        
        for(Schema.SObjectField checkFieldType : prodFieldsMap.values()){
            if(!prodFieldsMap.get(string.valueof(checkFieldType)).getDescribe().isCalculated()){
                prodFieldsList.add((string.valueOf(checkFieldType)).toLowerCase());                    
            }            
        }
        for(Product2 prod:standardProdMap.values()){
            if(prod.BusinessUnit__c == 'Tashang'){
                Product__c prodClone = new Product__c();
                
                for(String fieldNames : prodFieldsList){
                    if(  cProdFieldList.contains(fieldNames.toLowerCase())   ){
                        
                        if(fieldNames.contains('__c')){
                            prodClone.put(fieldNames,prod.get(fieldNames));
                            
                        }else{
                            if(fieldNames == 'ProductCode'){
                                prodClone.put('ProductCode__c',prod.ProductCode);
                            }else if(fieldNames == 'CurrencyIsoCode' ){
                                prodClone.put('CurrencyIsoCode',prod.CurrencyIsoCode);
                            }else if(fieldNames == 'Description'){
                                prodClone.put('Product_Description__c',prod.Description);
                            }else if(fieldNames == 'Family'){
                                prodClone.put('Product_Family__c',prod.Family);
                            }else if(fieldNames == 'Name'){
                                prodClone.put('Name',prod.Name);
                            }else if(fieldNames == 'IsActive'){
                                prodClone.put('IsActive__c',prod.IsActive);
                            }else if(updateCustomProduct.containsKey(prod.Id)){
                                prodClone.Id = updateCustomProduct.get(prod.Id);
                            }
                        }
                        prodClone.Referred_Product__c = prod.Id;
                    }
                }
                prodList.add(prodClone);
            }
        }        
        return prodList;
    }
	
	*/

    //Function check if the product is being clone from existing product record or being newly created.
    @InvocableMethod(Label = 'Product2: After Created/Updated')
    public static List<Boolean> checkProductClone(list<product2> prodRecords){
        List<Boolean> isCloned = new List<Boolean>();
        for(Product2 tempProd : prodRecords){
            if(!String.isEmpty(tempProd.getCloneSourceId()) ){
                isCloned.add(true);
            }
        }
        return isCloned;
    }
}
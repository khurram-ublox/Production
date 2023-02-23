/*
** Check before Product modification
** @rule:
** if product linked to Abacus (connected) prevent user from modifying for
Protected fields:
Product Name, Ordering No, Type No, Product Status, Product Text 1, Product Text 2 
** else OK

2017.12.19 khir: Added logistics to allow them to change Products linked to Abacus

*/

public class BeforeUpdateAbacusProduct{    
    
    public static String profileName=[select u.Profile.Name from user u where u.Id=:UserInfo.getUserId()].Profile.Name;
    public static String errorMessage = 'Product linked to Abacus. Name, Ordering No, Type No, Status, and Product Text are not modifiable.';
    
    public static void beforeUpdateAbacusProduct(List<Product2> listNewProduct,List<Product2> listOldProduct){
        
        //System.debug('=== new Product::: ' + listNewProduct[0]);
        //  System.debug('=== old Product::: ' + listOldProduct[0] );
        
        
        if(listNewProduct != null && listOldProduct != null){
            for(Integer i=0;i<listNewProduct.size();i++){            
                
                Product2 newPro=listNewProduct.get(i);
                Product2 oldPro=listOldProduct.get(i);
                
                System.debug('=== new Product: ' + newPro);
                System.debug('=== old Product: ' + oldPro);
                
                //i.e. linked to Abacus(cannot update Name, Ordering No, Type No, Status, and Product Text)
                //Product linked to Abacus, this field is not modifiable
                if(newPro.From_Abacus__c==true){
                    
                    if(newPro.Name!=oldPro.Name){
                        System.debug('=== update Name error');
                        newPro.Name.addError(errorMessage);
                    }
                    if(newPro.ProductCode!=oldPro.ProductCode){
                        System.debug('=== update ProductCode error');
                        newPro.ProductCode.addError(errorMessage);
                    }
                    if(newPro.Type_No__c!=oldPro.Type_No__c){
                        System.debug('=== update Type_No error');
                        newPro.Type_No__c.addError(errorMessage);
                    }
                    if(newPro.Product_Status__c!=oldPro.Product_Status__c){
                        System.debug('=== update Product_Status error');
                        newPro.Product_Status__c.addError(errorMessage);
                    }
                    if(newPro.Product_Text_1__c!=oldPro.Product_Text_1__c){
                        System.debug('=== update Product_Text_1 error');
                        newPro.Product_Text_1__c.addError(errorMessage);
                    }
                    if(newPro.Product_Text_2__c!=oldPro.Product_Text_2__c){
                        System.debug('=== update Product_Text_2 error');
                        newPro.Product_Text_2__c.addError(errorMessage);
                    }
                }            
            }
        }
    }
    
    /*
    ** Test Methods
    */
    public static testMethod void testBeforeUpdateAbacusNotLinkedProduct(){
        System.debug('======  Not Admin Profile');
        BeforeUpdateAbacusProduct.profileName='xxxxx';        
        Test.startTest();
        isTestLinkedToAbacus = false;
        doTest();
        Test.stopTest();
    }
    
     public static testMethod void testBeforeUpdateAbacusProductLinked(){
        System.debug('======  Not Admin Profile');
        BeforeUpdateAbacusProduct.profileName='xxxxx';        
        Test.startTest();
         isTestLinkedToAbacus = true;
        doTest();
        Test.stopTest();
    }
    
    public static testMethod void testBeforeUpdateAbacusNotLinkedProduct2(){
        delete [select id from Product2 where Type_No__c in: (new String[]{'type123','type456','test','test2'})];
        System.debug('======  Admin Profile');
        BeforeUpdateAbacusProduct.profileName='System Administrator';        
        Test.startTest();
        isTestLinkedToAbacus = false;
        doTest();
        Test.stopTest();
    }
    public static testMethod void testBeforeUpdateAbacusLinkedProduct2(){
        delete [select id from Product2 where Type_No__c in: (new String[]{'type123','type456','test','test2'})];
        System.debug('======  Admin Profile');
        BeforeUpdateAbacusProduct.profileName='System Administrator';        
        Test.startTest();
        isTestLinkedToAbacus = true;
        doTest();
        Test.stopTest();
    }
    
    public static testMethod void testBeforeUpdateAbacusNotLinkedProduct3(){
        System.debug('======  Admin Profile');
        BeforeUpdateAbacusProduct.profileName='Logistics';        
        Test.startTest();
        isTestLinkedToAbacus = false;
        doTest();
        Test.stopTest();
    }
    
    public static testMethod void testBeforeUpdateAbacusLinkedProduct3(){
        System.debug('======  Admin Profile');
        BeforeUpdateAbacusProduct.profileName='Logistics';        
        Test.startTest();
        isTestLinkedToAbacus = true;
        doTest();
        Test.stopTest();
    }
    
    @TestVisible
    private static boolean isTestLinkedToAbacus = false;
    @TestVisible
    private static void doTest(){
        if(isTestLinkedToAbacus)
        	doTestLinkedToAbacus();
        else
            doTestNotLinkedToAbacus();
    }
   
    @TestVisible
    private static void doTestNotLinkedToAbacus(){
        
        List<Product2> listProduct=new List<Product2>();
        listProduct.add(new Product2(Name='Test123', Type_No__c='type123'));
        listProduct.add(new Product2(Name='Test456', Type_No__c='type456', 
                                     ProductCode='456',Product_Status__c='status1',
                                     Product_Text_1__c='ptext1',Product_Text_2__c='ptext2',
                                     From_Abacus__c=true));
        
        insert listProduct;
        System.debug('=== listProduct: ' + [select name,Type_No__c from Product2 where Type_No__c in : (new String[]{'type123','type456'})]);
	
		        
        //not linked to abacus
        try{
            
            listProduct.get(0).Name='test'; 
            update listProduct.get(0);            
            System.debug('--------------- Updated Name');
            
            listProduct.get(0).ProductCode='test';
            update listProduct.get(0);
            System.debug('--------------- Updated ProductCode');
            
            listProduct.get(0).Type_No__c='test';
            update listProduct.get(0);
            System.debug('--------------- Updated Type_No__c');
            
            listProduct.get(0).Product_Status__c='test';
            update listProduct.get(0);
            System.debug('--------------- Updated Product_Status__c');
            
            listProduct.get(0).Product_Text_1__c='test';
            update listProduct.get(0);
            System.debug('--------------- Updated Product_Text_1__c');
            
            listProduct.get(0).Product_Text_2__c='test';
            update listProduct.get(0);
            System.debug('--------------- Updated Product_Text_2__c');
            
            System.debug('--------------- Updated product 1: ' + [select Name,ProductCode,Type_No__c,Product_Status__c,Product_Text_1__c,Product_Text_2__c from Product2 where Id=:listProduct.get(0).Id]);
        }        
        catch(Exception e){
            System.debug('--------------- Error for Product not linked to abacus: '+e);
        }                     

        
    }
    
    @TestVisible
    private static void doTestLinkedToAbacus(){
        
        List<Product2> listProduct=new List<Product2>();
        listProduct.add(new Product2(Name='Test123', Type_No__c='type123'));
        listProduct.add(new Product2(Name='Test456', Type_No__c='type456', 
                                     ProductCode='456',Product_Status__c='status1',
                                     Product_Text_1__c='ptext1',Product_Text_2__c='ptext2',
                                     From_Abacus__c=true));
        
        insert listProduct;
        System.debug('=== listProduct: ' + [select name,Type_No__c from Product2 where Type_No__c in : (new String[]{'type123','type456'})]);
	
		//linked to abacus
        try{
            listProduct.get(1).Name='test2';
            update listProduct.get(1);   
            System.debug('--------------- Updated Name');         
        }
        catch(Exception e){
            listProduct.get(1).Name='Test456';                      
            System.debug('--------------- Update Name Error: '+e);            
        }    
        try{    
            listProduct.get(1).ProductCode='test2';
            update listProduct.get(1);
            System.debug('--------------- Updated ProductCode');
            
        }
        catch(Exception e){
            listProduct.get(1).ProductCode='456';            
            System.debug('--------------- Update ProductCode Error: '+e);
        } 
        try{   
            listProduct.get(1).Type_No__c='test2';
            update listProduct.get(1);
            System.debug('--------------- Updated Type_No');
        }
        catch(Exception e){
            listProduct.get(1).Type_No__c='type456';            
            System.debug('--------------- Update Type_No__c Error: '+e);
        } 
        try{    
            listProduct.get(1).Product_Status__c='test2';
            update listProduct.get(1);
            System.debug('--------------- Updated Product_Status');
        }
        catch(Exception e){
            listProduct.get(1).Product_Status__c='status1';
            System.debug('--------------- Update Product_Status__c Error: '+e);
        }  
        try{  
            listProduct.get(1).Product_Text_1__c='test2';
            update listProduct.get(1);
            System.debug('--------------- Updated Product_Text_1');
        }
        catch(Exception e){
            listProduct.get(1).Product_Text_1__c='ptext1';
            System.debug('--------------- Update Product_Text_1__c Error: '+e);
        }    
        try{
            listProduct.get(1).Product_Text_2__c='test2';
            update listProduct.get(1);
            System.debug('--------------- Updated Product_Text_2');
        }
        catch(Exception e){
            listProduct.get(1).Product_Text_2__c='ptext2';
            System.debug('--------------- Update Product_Text_2__c Error: '+e);
        }
        
        try{
            listProduct.get(1).Remarks__c='test2';
            update listProduct.get(1);
            
            System.debug('>>> updated Remarks__c');
            
        }catch(Exception ex){
            System.debug('>>> never not occur');
        }
        System.debug('--------------- Updated product 2: ' + [select Name,ProductCode,Type_No__c,Product_Status__c,Product_Text_1__c,Product_Text_2__c from Product2 where Id=:listProduct.get(1).Id]);
    }
    
     // Commenting out this(upsertCustomProduct) method. It is for the removal of custom Product obj. By ufar, 12-6-22.
    /*
    
    //Changes Made on 29th Jan 
    public static void upsertCustomProduct(Map<Id,Product2> standardProdMap){
        
        //Retrieve All the Fields from the Product Object
        Schema.DescribeSObjectResult prodFields =   Product2.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> prodFieldsMap =   prodFields.fields.getMap();
        
        //Retrieve All the Fields from Product__c Object
        Schema.DescribeSObjectResult cprodFields =   Product__c.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> cprodFieldsMap =   cprodFields.fields.getMap();
        system.debug('cprodFieldsMap: '+cprodFieldsMap.values());
        
        List<string> standardFieldList = new List<String>(); // To Store list of Standard Fields
        List<string> customFieldList = new List<string>(); // To Store list of Custom Fields
        List<string> prodFieldsList = new List<string>(); // To retrieve all the fields
        List<Product__c> prodList = new List<Product__c>(); // To add the products in Custom Product
        List<Schema.DisplayType> checkDataType = new List<Schema.DisplayType>();
        
        List<string> cProdFieldList = new List<string>();
        //Update Changes
        Map<Id,Id> updateCustomProduct = new Map<Id,Id>();
        Set<Id> sProdId = new Set<Id>();
        sProdId = standardProdMap.keyset();
        system.debug('sProdId: '+sProdId);
        List<Product__c> cProdList = new List<Product__c> ();
        
        cProdList = [select Id, Referred_Product__c from Product__c where Id != ''  AND Referred_Product__c =: sProdId ];
        system.debug('cProdList: '+cProdList.size());
        
        
        if(!cProdList.isEmpty()){
            for(Product__c cProd:cProdList){
                updateCustomProduct.put(cProd.Referred_Product__c,cProd.Id);  
            }
        } 
        system.debug('updateCustomProduct: '+updateCustomProduct);
        
        for(Schema.SObjectField checkFieldType : cprodFieldsMap.values()){
            if(!cprodFieldsMap.get(string.valueof(checkFieldType)).getDescribe().isCalculated()){
                cProdFieldList.add(string.valueOf(checkFieldType));
            }
        }
        
        //Update Completed
        //Add All the Fields in a List and then Seperate Custom and Standard Fields
        for(Schema.SObjectField checkFieldType : prodFieldsMap.values()){
            if(!prodFieldsMap.get(string.valueof(checkFieldType)).getDescribe().isCalculated()){
                prodFieldsList.add(string.valueOf(checkFieldType));
                if((string.valueOf(checkFieldType)).contains('__c') && cProdFieldList.contains(string.valueof(checkFieldType))){
                    customFieldList.add((string.valueOf(checkFieldType)).toLowerCase());
                }else if(!(string.valueOf(checkFieldType)).contains('__c')){
                    standardFieldList.add((string.valueOf(checkFieldType)).toLowerCase());
                }
            }
        }
        
        for(Product2 prod:standardProdMap.values()){
            if(prod.BusinessUnit__c == 'Tashang'){
                Product__c prodClone = new Product__c();
                for(string fieldNames : prodFieldsList)
                {
                    if(fieldNames != 'Id' && customFieldList.contains(fieldNames.toLowerCase())  )
                    {
                        prodClone.put(fieldNames,prod.get(fieldNames));
                    } else if(fieldNames != 'Id' && standardFieldList.contains(fieldNames.toLowerCase()))
                    {
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
                prodList.add(prodClone);
            }
            
        }
        if(!prodList.isempty())
            upsert  prodList;
    }
    
    */
    
}
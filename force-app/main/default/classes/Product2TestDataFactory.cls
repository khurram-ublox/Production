@isTest
public with sharing class Product2TestDataFactory extends TestDataFactory {
    public Product2TestDataFactory() {
        super('Product2');
    }

    public override sObject initializeRecord(){
        Product2 testProduct = createMinimalProduct();
        return testProduct;
    }

    public override sObject createRecord(){
        Product2 testProduct = (Product2)initializeRecord();
        insert testProduct;
        return testProduct;
    }

    public override List<sObject> createBulkRecords(){

        Integer [] maxValues =new Integer[]{1,9,20,49,230,265,560,1022};

        for (Integer i = 0; i < maxValues.size(); i++) {
            Product2 prod = createProductForMaxPrice(maxValues[i]);
            recordsList.add(prod);
        }
        Insert recordsList;
        return recordsList;
    }

    public static Product2 createMinimalProduct() {
        //List<Product2> testProducts = new List<Product2>();
        Product2 testProduct = new Product2(
            Name = 'NEO-M8P',
            Type_No__c= 'NEO-M8P-2-11',
            ProductCode= 'NEO-M8P-2',
            Family = 'ALEX',
            Positioning_Engine__c = 'Not applicable',
            Product_Center__c = 'Positioning',
            Packaging_Size__c = 1000
            //CurrencyIsoCode = 'USD - U.S. Dollar'
            );
        //testProducts.add(testProduct);
        
        return testProduct;
    }

    public static Product2 iprClassProduct() {
        //List<Product2> testProducts = new List<Product2>();
        Product2 testProduct = new Product2(
            Name = 'NEO-M8P',
            Type_No__c= 'NEO-M8P-2-11',
            ProductCode= 'NEO-M8P-2',
            Family = 'ALEX',
            Positioning_Engine__c = 'Not applicable',
            Product_Center__c = 'Positioning',
            Packaging_Size__c = 1000
            //CurrencyIsoCode = 'USD - U.S. Dollar'
            );
        //testProducts.add(testProduct);
        
        return testProduct;
    }

    public Product2 iprTechnologyChanged(Product2 iprTestProduct){
        iprTestProduct.Cellular_Technology__c = 'GPRS';
        iprTestProduct.IPR_Technology__c = 'GSM';
        
        insert iprTestProduct;
        return iprTestProduct;
    }

    public Product2 thing_Stream_Condition(Product2 thingStreamProduct){
        thingStreamProduct.Thingstream_Id__c = 'GPRS';
        
        insert thingStreamProduct;
        return thingStreamProduct;
    }

    public Product2 should_Product_Description_Be_Updated(Product2 descriptionTestProduct){
        descriptionTestProduct.Thingstream_Id__c = 'GPRS';
        descriptionTestProduct.Product_Text_1__c = 'one';
        descriptionTestProduct.Product_Text_2__c = 'two';
        descriptionTestProduct.Product_Text_3__c = 'three';
        
        insert descriptionTestProduct;
        return descriptionTestProduct;
    }

    public Product2 should_Product_Description_Be_Updated2(Product2 descriptionTestProduct){
        descriptionTestProduct.Thingstream_Id__c = 'GPRS';
        descriptionTestProduct.Product_Text_1__c = 'one';
        descriptionTestProduct.Product_Text_2__c = 'two';
        
        insert descriptionTestProduct;
        return descriptionTestProduct;
    }

    public Product2 should_Product_Description_Be_Updated3(Product2 descriptionTestProduct){
        descriptionTestProduct.Thingstream_Id__c = 'GPRS';
        descriptionTestProduct.Product_Text_1__c = 'one';
        descriptionTestProduct.Product_Text_3__c = 'two';
        
        insert descriptionTestProduct;
        return descriptionTestProduct;
    }

    public Product2 product_Decision_Ipr_CostChanged(Product2 changedDecisionProduct){
        IPR_Cost__c iprCost = makeIprCost();

        changedDecisionProduct.Cellular_Technology__c = 'GPRS';
        //changedDecisionProduct.IPR_Technology__c = 'GSM';
        changedDecisionProduct.IPR_Cost__c = iprCost.Id;
        
        insert changedDecisionProduct;
        return changedDecisionProduct;
    }

    public Product2 update_Product_Decision_Ipr_CostChanged(Product2 changedDecisionProduct){
        changedDecisionProduct.IPR_Technology_Changed__c = true;

        update changedDecisionProduct;
        return changedDecisionProduct;
    }

    public Product2 update_Product_Active_Status(Product2 activatedProduct, boolean active){
        activatedProduct.IsActive = active;

        update activatedProduct;
        return activatedProduct;
    }

    public Product2 update_Product_Status(Product2 prodToBeUpdated){
        prodToBeUpdated.Product_Status__c = 'Obsolete';
        prodToBeUpdated.Visible_In_Masterschedule__c = true;
        prodToBeUpdated.Visible_To_Partner__c = true;

        update prodToBeUpdated;
        return prodToBeUpdated;
    }

    public Product2 update_IPR_Checked_Flag(Product2 prodToBeUpdated){
        prodToBeUpdated.IPR_Checked__c = true;
        prodToBeUpdated.IPR_Checked_Date__c = Date.newInstance(2019, 2, 17);

        update prodToBeUpdated;
        return prodToBeUpdated;
    }

    public Product2 update_Comment(Product2 prodToBeUpdated){
        prodToBeUpdated.Comment__c = 'These are the comments for testing';
        prodToBeUpdated.Comment_Updated_Date__c = Date.newInstance(2019, 2, 17);

        update prodToBeUpdated;
        return prodToBeUpdated;
    }

    public Product2 unchecked_Ipr_Checked(Product2 changeIPR){
        IPR_Cost__c iprCost = makeIprCost2();
        changeIPR.IPR_Cost__c = iprCost.Id;

        update changeIPR;
        return changeIPR;
    }

    public static Product2 createProductForMaxPrice(Integer packagingSize) {
        //List<Product2> testProducts = new List<Product2>();
        Product2 testProduct = new Product2(
            Name = 'NEO-M8P',
            Type_No__c= 'NEO-M8P-'+packagingSize+'-11',
            ProductCode= 'NEO-M8P-'+ packagingSize,
            Family = 'ALEX',
            Positioning_Engine__c = 'Not applicable',
            Product_Center__c = 'Positioning',
            Product_Category__c = 'Antennas',
            Packaging_Size__c = packagingSize
            //CurrencyIsoCode = 'USD - U.S. Dollar'
            );
        //testProducts.add(testProduct);
        
        return testProduct;
    }

    public static IPR_Cost__c makeIprCost(){

        IPR_Cost__c iprTestProduct = new IPR_Cost__c();
        
        iprTestProduct.Name = 'IPR Cost';
        iprTestProduct.Consumer_USD__c = 15;
        iprTestProduct.Handset_USD__c = 50;
        iprTestProduct.Other_USD__c = 500;
    
        insert iprTestProduct;
    
        return iprTestProduct;
        
    }

    public static IPR_Cost__c makeIprCost2(){

        IPR_Cost__c iprTestProduct = new IPR_Cost__c();
        
        iprTestProduct.Name = 'IPR Cost 2';
        iprTestProduct.Consumer_USD__c = 20;
        iprTestProduct.Handset_USD__c = 10;
        iprTestProduct.Other_USD__c = 40;
    
        insert iprTestProduct;
    
        return iprTestProduct;
        
    }
}
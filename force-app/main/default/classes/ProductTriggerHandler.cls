/****
Process 1 : Copies Product related information in custom product object
Process 2 : Prevent update product if it's from abacus

***/
public without sharing  Class  ProductTriggerHandler  implements ITrigger 
{    
    //process 1 : upsert product in custom product object
    // Commenting out this cProdList . It is for the removal of custom Product obj. By ufar, 12-6-22.
    /*
    List<product__c> cProdList = new List<product__c>();
    */
    
    //process 2: prevent update abacus account
    //remove 'automatic process' from profile
    public set<String> setProfile = new set<String>{'system administrator','logistics'};
    public static String profileName;
         
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){        
       profileName = [select u.Profile.Name from user u where u.Id=:UserInfo.getUserId()].Profile.Name;
    }
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){}
    
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){

    }
    
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){
        map<Id, Product2> prodMap = (map<Id, Product2>)Trigger.newMap;        
        if(!setProfile.contains(profileName.toLowerCase())){
           ProductObjectTriggerHandler.preventUpdateAbacusProduct(prodMap);
        }
    }
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){}
    
    // Process logic/functioanlities in other classes for after Insert  event 
    public void afterInsert(){                  
        map<Id, Product2> prodMap = (map<Id, Product2>)Trigger.newMap;
         // Commenting out this cProdList . It is for the removal of custom Product obj. By ufar, 12-6-22.
    	/*
        cProdList = ProductObjectTriggerHandler.upsertCustomProduct(prodMap);
        */
        //ProductPricesProductTrigger
        list<Product2> prodList = Trigger.New;
        Set<String> productCodes = ProductPricesTriggerHelper.afterInsertOrDeleteProductHandler(prodList, prodMap);
        ProductPricesTriggerHelper.insertupdatedeleteProducthandler(productCodes);
    }
    
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){        
        map<Id, Product2> prodNewMap = (map<Id, Product2>)Trigger.newMap;
        // Commenting out this cProdList . It is for the removal of custom Product obj. By ufar, 12-6-22.
    	/*
        cProdList = ProductObjectTriggerHandler.upsertCustomProduct(prodNewMap);   
        */
        //ProductPricesProductTrigger
        list<Product2> prodNewList = Trigger.New;
        list<Product2> prodOldList = Trigger.old;
        map<Id, Product2> prodOldMap = (map<Id, Product2>)Trigger.oldMap;
        Set<String> productCodes = ProductPricesTriggerHelper.afterUpdateProductHandler(prodNewList, prodNewMap, prodOldList,prodOldMap);
        ProductPricesTriggerHelper.insertupdatedeleteProducthandler(productCodes);            
    }
    
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){                   
        //ProductPricesProductTrigger
        list<Product2> prodOldList = Trigger.old;
        map<Id, Product2> prodOldMap = (map<Id, Product2>)Trigger.oldMap;
        Set<String> productCodes = ProductPricesTriggerHelper.afterInsertOrDeleteProductHandler(prodOldList, prodOldMap);
        ProductPricesTriggerHelper.insertupdatedeleteProducthandler(productCodes);            
    } 
    
    //Finally do operations to Commit 
    public void finish(){
    	// Commenting out this cProdList . It is for the removal of custom Product obj. By ufar, 12-6-22.
    	/*
        upsert cProdList;
		*/
    }
}
/*
* Title: ProductPricesTriggerHandler
* Description: Class that updates 
*/

public without sharing class ProductPricesTriggerHandler implements ITrigger{
    //process 1 Data :    
    Set<String> productCodes = new Set<String>();
        
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){
        //Process 1
    }
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){
        List<ProductPrices__c> productPriceListNew = (list<ProductPrices__c>)Trigger.New;        
        List<ProductPrices__c> productPriceListOld = (list<ProductPrices__c>)Trigger.Old;
        //Process 1
        if(Trigger.isInsert || Trigger.isUpdate){            
            for(ProductPrices__c tempProductPrice : productPriceListNew){                    
                productCodes.add(tempProductPrice.Ordering_Number__c);
            }
        }else if(Trigger.isDelete){
            for(ProductPrices__c tempProductPrice : productPriceListOld){                      
                productCodes.add(tempProductPrice.Ordering_Number__c);
            }
        }
    }
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){
    }
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){
    }
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){
    }
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
        //Process 1 Logic : calling Helper to get 
        ProductPricesTriggerHelper.insertupdatedeleteProducthandler(productCodes);
    }
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){        
        ProductPricesTriggerHelper.insertupdatedeleteProducthandler(productCodes);            
    }
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){
        //Process 1 Logic : calling Helper to get 
            ProductPricesTriggerHelper.insertupdatedeleteProducthandler(productCodes);
    } 
    //Finally do operations to Commit 
    public void finish(){
        //Process 1 Result Commit
        
    }
}
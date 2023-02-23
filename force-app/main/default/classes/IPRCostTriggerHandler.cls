public without sharing class IPRCostTriggerHandler implements ITrigger { 
    list<Product2> productsToUpdate = new list<Product2>();

    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){}
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){}
    
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){}

    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
        IPRCostHelper helper = new IPRCostHelper();
        productsToUpdate = helper.getProductsUpdate((set<Id>)trigger.newMap.keySet());
    }
    
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){}

    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){
        IPRCostHelper helper = new IPRCostHelper();
        productsToUpdate = helper.getProductsUpdate((set<Id>)trigger.newMap.keySet());           
    } 

    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){}

    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){} 
    
    //Finally do operations to Commit 
    public void finish(){
        update productsToUpdate;
    }
}
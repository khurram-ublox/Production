public with sharing class OpportunityLineItemTriggerHandler implements ITrigger {
    private static final string PREMIUM_IPR_COVERAGE_CONST = 'Premium coverage';
    private static final string PRIME_IPR_COVERAGE_CONST = 'Prime coverage';
    private static final set<string> IPR_COVERAGE_CONSTS_SET = new set<string>{
        PREMIUM_IPR_COVERAGE_CONST,
        PRIME_IPR_COVERAGE_CONST
    };
        
    private void calculatePriceDifference(list<OpportunityLineItem> quoteProducts){
        map<Id, OpportunityLineItem> premiumItemsMap = new map<Id, OpportunityLineItem>();
        map<Id, OpportunityLineItem> primeItemsMap = new map<Id, OpportunityLineItem>();
        list<OpportunityLineItem> premiumProductsToUpdate = new list<OpportunityLineItem>();
        set<Id> opportunityIdSet = new set<Id>();
        
        for(OpportunityLineItem item : quoteProducts){
            opportunityIdSet.add(item.OpportunityId);
        }
        for(OpportunityLineItem item : [Select Id,
                                            Product2Id,
                                            UnitPrice,
                                            IPR_Coverage__c,
                                            Premium_Product_Price_Difference__c 
                                            from OpportunityLineItem 
                                            where OpportunityId =:opportunityIdSet 
                                            AND IPR_Coverage__c IN : IPR_COVERAGE_CONSTS_SET 
                                            limit 100]){
            if(item.IPR_Coverage__c == PREMIUM_IPR_COVERAGE_CONST){
                premiumItemsMap.put(item.Product2Id,item);
            }else if(item.IPR_Coverage__c == PRIME_IPR_COVERAGE_CONST){
                primeItemsMap.put(item.Product2Id,item);
            }                                    
        }
        for(Id key : premiumItemsMap.keySet()){
            if(primeItemsMap.get(key) != null){
                premiumItemsMap.get(key).Premium_Product_Price_Difference__c = premiumItemsMap.get(key).UnitPrice - primeItemsMap.get(key).UnitPrice;
                premiumProductsToUpdate.add(premiumItemsMap.get(key));
            }
        }
        if(premiumProductsToUpdate.size() > 0){
            database.update(premiumProductsToUpdate,false);
        }
    }

    public void prepareBefore(){}
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){}
            
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){}
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){}
    
    // Process logic/functioanlities in other classes for before insert  event
    public void beforeInsert(){}

    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
        list<OpportunityLineItem > lineItems = (list<OpportunityLineItem>)trigger.new;
        calculatePriceDifference(lineItems);
    }
 
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){}
 
    // Process logic/functioanlities in other classes for after Delete event
    public void afterDelete(){}        
         
    //Finally do operations to Commit 
    public void finish(){}
}
public without sharing class OppProductTriggerHandler implements ITrigger{
     
    list<Opportunity> OpportunityToUpdate = new list<Opportunity>();
    // Commenting out this oppProductsToUpdate list. It is for the removal of custom Product obj. By ufar, 12-6-22.
	/*
    list<Opp_Product__c> oppProductsToUpdate = new list<Opp_Product__c>();
	*/
    // Prepare the data for catering to Before Trigger events
     public void prepareBefore(){}
    

     public void prepareAfter(){}
     
     // Process logic/functioanlities in other classes for before Insert event  
     public void beforeInsert(){}
 
     // Process logic/functioanlities in other classes for after Update  event
     public void afterInsert(){
    // Commenting out this(updateProduct) method call. It is for the removal of custom Product obj. By ufar, 12-6-22.
	/*    
        oppProductsToUpdate = oppProductTriggerHelper.updateProduct((map<Id,Opp_Product__c>)Trigger.newMap);
	*/
        OpportunityToUpdate = oppProductTriggerHelper.updateProductRankings((map<Id,Opp_Product__c>)Trigger.newMap);
     }
 
     // Process logic/functioanlities in other classes for before Update  event
     public void beforeUpdate(){}
     
     // Process logic/functioanlities in other classes for after Update  event
     public void afterUpdate(){
 
        map<Id, Opp_Product__c> changedMap = new  map<Id, Opp_Product__c>();
        map<Id, Opp_Product__c> changedProdMap = new  map<Id, Opp_Product__c>();
            
        // Look only for products which have changed there Ranking__c
        List<Opp_Product__c> obj = (List<Opp_Product__c>)Trigger.new;
        for(Opp_Product__c n: obj){
            Opp_Product__c o = (Opp_Product__c)Trigger.oldMap.get(n.Id);
            
            // compare new ranking and product in i with old ranking and product from the oldMap.
            // check whether No_Opp_Update__c is not changed. If not, its Opportunity will be updated. 
            // This was created to prevent updating Opportunity after Opportunity was set to Lost.
            
            if(n.No_Opp_Update__c == o.No_Opp_Update__c 
                && (n.Ranking__c != o.Ranking__c || n.Product__c != o.Product__c)){ 
                // updating parent Opportunity 
                changedMap.put(n.Id, n);                
            } 
            if(((n.Product__c != o.Product__c) && n.Product__c != null)){
                changedProdMap.put(n.Id,n);
            }              
            if(n.Calculate_CogsBudget__c){
                changedProdMap.put(n.Id,n);
            }            
        }                 
        if (!changedMap.isEmpty()){
            OpportunityToUpdate = oppProductTriggerHelper.updateProductRankings(changedMap);
        } 
        if (!changedProdMap.isEmpty() && oppProductTriggerHelper.isFirstTime) {
            oppProductTriggerHelper.isFirstTime = false;
    	// Commenting out this(updateProduct) method call. It is for the removal of custom Product obj. By ufar, 12-6-22.
		/* 
            oppProductsToUpdate = oppProductTriggerHelper.updateProduct(changedProdMap);
		*/    
		}
     }
     // Process logic/functioanlities in other classes for before Delete event
     public void beforeDelete(){}    
     
     // Process logic/functioanlities in other classes for after Delete  event
     public void afterDelete(){
         OpportunityToUpdate = oppProductTriggerHelper.updateProductRankings((map<Id,Opp_Product__c>)Trigger.oldMap);
     }
 
     //Finally do operations to Commit
     public void finish(){
         update OpportunityToUpdate;
    // Commenting out this(oppProductsToUpdate) update list. It is for the removal of custom Product obj. By ufar, 12-6-22.
	/* 
         update oppProductsToUpdate;
	*/
     }
}
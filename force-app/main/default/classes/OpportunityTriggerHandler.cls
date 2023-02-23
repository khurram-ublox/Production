public without sharing class OpportunityTriggerHandler implements ITrigger{    
    list<Partner_Role__c> partnerRoleToUpdate = new list<Partner_Role__c>();
    OpportunityHelper oppHelper;
    String parterUserType = 'PowerPartner';

    public OpportunityTriggerHandler(){
        if(oppHelper == NULL){
            oppHelper = new OpportunityHelper();
        }
    }
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){}
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){}
    
    // Process logic/functioanlities in other classes for before Insert event 
    public void beforeInsert(){
        String currentUserType = userInfo.getUserType();
            if(currentUserType != parterUserType){
            updateOpportunityOwner.execute((list<Opportunity>)Trigger.new);
        }
        oppHelper.opportunityOwnerUpdate((list<Opportunity>)Trigger.new);
        PopulateOpportunityAccount.execute((list<Opportunity>)Trigger.new);    
    }

    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){
        oppHelper.opportunityOwnerUpdate((list<Opportunity>)Trigger.new);
    }
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){}
    
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){}
 
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){        
        oppHelper.updateOppProductStatus((map<Id, Opportunity>)Trigger.newMap, (map<Id, Opportunity>)Trigger.oldMap);
        partnerRoleToUpdate = oppHelper.updatePartnerRole((set<Id>)Trigger.newMap.keySet());
    }
 
    // Process logic/functioanlities in other classes for after Delete event
    public void afterDelete(){}
     
    //Finally do operations to Commit 
    public void finish(){        
        update partnerRoleToUpdate;
    }
}
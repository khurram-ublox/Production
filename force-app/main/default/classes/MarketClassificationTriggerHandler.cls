/****
Process 1 : prevent user from deactivating records that are being referenced in Account/lead/opportunity objects.
***/
public Class MarketClassificationTriggerHandler implements ITrigger
{
    
    static List<Id> marketClassificationIds = new List<Id>();
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){
        if(!trigger.isInsert){
            List<Market_Classification__c> marketClassObjOld = (list<Market_Classification__c>)Trigger.old;
            
            for(Market_Classification__c tempMarketClassificationObj : MarketClassObjOld){
                if(Trigger.isUpdate){
                    Market_Classification__c marketClassObjNew = (Market_Classification__c)Trigger.newMap.get(tempMarketClassificationObj.Id);
                    if(marketClassObjNew.IsActive__c != tempMarketClassificationObj.IsActive__c && !marketClassObjNew.IsActive__c){
                        marketClassificationIds.add(tempMarketClassificationObj.Id);
                    }
                }
                if(Trigger.isDelete){
                    if(tempMarketClassificationObj.isActive__c){
                        marketClassificationIds.add(tempMarketClassificationObj.Id);
                    }
                }
            }
        }
    }
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){
    }
    
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){
    }
    
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){
        List<Market_Classification__c> MarketClassObjLst = (list<Market_Classification__c>)Trigger.New;
        MarketClassificationTriggerHelper.isMarketClassificationReferenced(marketClassificationIds,MarketClassObjLst);
        
    }
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){
        List<Market_Classification__c> MarketClassObjLst = (list<Market_Classification__c>)Trigger.old;
        MarketClassificationTriggerHelper.isMarketClassificationReferenced(marketClassificationIds,MarketClassObjLst);
    }
    
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
    }
    
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){
    }
    
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){
    } 
    //Finally do operations to Commit 
    public void finish(){
        
    }
}
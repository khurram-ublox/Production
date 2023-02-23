public class MarketClassificationTriggerHelper {
    
    /*
     * check if there are any associated accounts/leads/opportunites and prevent deactivating the record if there are any.
     */
    public static void isMarketClassificationReferenced(List<Id> marketClassificationIds, List<Market_Classification__c> marketClassificationList){
        
        List<Market_Classification__c> marketClassificationLst = new List<Market_Classification__c>();
        if(marketClassificationIds.size() > 0){
            try{
                marketClassificationLst = [SELECT Id ,(SELECT Id from Opportunities__r),(SELECT Id from accounts__r), (SELECT Id from Leads__r) from Market_classification__c where id =: marketClassificationIds];
            }catch(QueryException e){
                system.debug('An error has occurred'+e.getMessage());
            }
        }
        map<Id,Boolean> marketClassIdMap = new map<Id,Boolean>();
        
        for(Market_Classification__c tempMarketClassificationObj :  marketClassificationLst){
            
            if(tempMarketClassificationObj.opportunities__r.size()>0 || tempMarketClassificationObj.Accounts__r.size()>0 || tempMarketClassificationObj.Leads__r.size()>0 ){
                marketClassIdMap.put(tempMarketClassificationObj.Id, true);
            }
        }
        for(Market_Classification__c tempMarketClassificationObj :  marketClassificationList){
            if(marketClassIdMap.containsKey(tempMarketClassificationObj.Id)){
                tempMarketClassificationObj.AddError(Label.Market_Classification_Message);
            }
        }
    }
    
}
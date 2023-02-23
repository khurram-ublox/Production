trigger ReplacePicklistApplicationTypeValuesForOpps on Opportunity (before insert, before update) {

    Map<String, NewApplicationType__c> appTypeMap = NewApplicationType__c.getAll();
    Map<String, String> appTypeMapping = new Map<String, String>();
    
    for(String t : appTypeMap.keySet()){
        String newAppType = appTypeMap.get(t).New_App_type__c;
        appTypeMapping.put(t, newAppType);
       
    }
    
    for(Opportunity opp : Trigger.new){
        
        String keyToSearch = opp.Application_Type__c;
        String pickMarketValue = opp.Market_formula__c;
        String keyResultFound = appTypeMapping.get(keyToSearch);
        
        opp.New_Application_Type__c = keyResultFound;  
        opp.New_Market__c           = pickMarketValue;
        
    }
   
}
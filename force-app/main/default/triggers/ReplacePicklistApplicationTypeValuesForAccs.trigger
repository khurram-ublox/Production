trigger ReplacePicklistApplicationTypeValuesForAccs on Account (before insert, before update) {

    Map<String, NewApplicationType__c> appTypeMap = NewApplicationType__c.getAll();
    Map<String, String> appTypeMapping = new Map<String, String>();
    
    for(String t : appTypeMap.keySet()){
        String newAppType = appTypeMap.get(t).New_App_type__c;
        appTypeMapping.put(t, newAppType);
       
    }
    
    for(Account acc : Trigger.new){
        
        String keyToSearch = acc.Application_Type__c;
        String pickMarketValue = acc.Market_formula__c;
        String keyResultFound = appTypeMapping.get(keyToSearch);
        
        acc.New_Application_Type__c = keyResultFound;  
        acc.New_Market__c           = pickMarketValue;
        
    }
    
}
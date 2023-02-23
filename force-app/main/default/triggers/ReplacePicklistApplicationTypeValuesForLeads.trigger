trigger ReplacePicklistApplicationTypeValuesForLeads on Lead(before insert, before update) {

    Map<String, NewApplicationType__c> appTypeMap = NewApplicationType__c.getAll();
    Map<String, String> appTypeMapping = new Map<String, String>();
    
    for(String t : appTypeMap.keySet()){
        String newAppType = appTypeMap.get(t).New_App_type__c;
        appTypeMapping.put(t, newAppType);
        
    }
    
    for(Lead eachLead : Trigger.new){
        
        String keyToSearch = eachLead.Application__c;        
        String keyResultFound = appTypeMapping.get(keyToSearch);
        eachLead.New_Application_Type__c = keyResultFound;  
        
    }
    
}
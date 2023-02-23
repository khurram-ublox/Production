public class LeadTriggerHandler implements ITrigger{
    list<Lead> toUpdate = new List<Lead>();
    
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){}
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){}
    
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){
        //Data set for 'change Office On Lead' in before insert. 
        Set<String> setCountryCode = new Set<String>(); //set ISO_Code
        Set<String> setStateCode = new Set<String>();
        Map<String,String> mapCountryUbOffice = new Map<String,String>();
        list<Lead> leads = (list<Lead>)trigger.new;
        
        for(Lead lead : leads) {
            if(lead.Country != null) setCountryCode.add(lead.Country); //set ISO_Code
            if(lead.State != null) setStateCode.add(lead.State);//State Code
        }
        
        // one query for getting iso codes
        if(setCountryCode.size() > 0 || setStateCode.size() > 0 ){ //.size()>0
            for(Country__c c : [select uB_Office__c, ISO_Code__c 
                                    from Country__c 
                                    where ISO_Code__c IN : setCountryCode 
                                    OR State_Code__c IN : setStateCode]) {
                mapCountryUbOffice.put(c.ISO_Code__c,c.uB_Office__c);
            }
        }
        if(mapCountryUbOffice.size() > 0){ 
            for(Lead lead : Leads)  { 
                // update leads ub_Office if country is found
                String ubOff = mapCountryUbOffice.get(lead.Country);   
                if(ubOff!=null) lead.uB_Office__c = ubOff;
            }
        }
    }

    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
        list<Lead> leads = (list<Lead>)trigger.new;
        map<Id, Lead> leadsMap = (map<Id, Lead>)trigger.newMap;
        String path = System.URL.getCurrentRequestUrl().getPath();     
        if(UserInfo.getUserId() == '00557000006eQYEAA2' && path.contains('/services/Soap/u/')){     //apiuser@u-blox.com  -> 005D0000003wh71IAA  
            User apiuser = [SELECT Id FROM User where Username like 'salesforce@u-blox.com%' LIMIT 1];  
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule= true;       
            for(Lead l : leads) {
                // only for api
                if(l.OwnerId == apiuser.Id) {
                    l.setOptions(dmo);
                    toUpdate.add(l);
                }
            }
        }        
        AssistNow.updateTokens(leadsMap.keySet());
    }

    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){}

    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){}

    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){}    
    
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){}

    //Finally do operations to Commit 
    public void finish(){        
        update toUpdate;
    }  
}
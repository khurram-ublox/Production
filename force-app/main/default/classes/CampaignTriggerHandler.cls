public without sharing class CampaignTriggerHandler implements ITrigger {       
    list<CampaignMemberStatus> statusesToAdd = new list<CampaignMemberStatus>();       
    
            
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){}
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){}
    
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){}

    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
        set<Id> campaignIds = new set<Id>();
        map<Id,Id> memberStatusMap = new map<Id,Id>();
        
        for(Campaign c : (list<Campaign>)trigger.new){
            campaignIds.add(c.Id);
        }
    
        for(CampaignMemberStatus cstatus : [select Id,campaignId from CampaignMemberStatus 
                                                    where campaignId = :campaignIds 
                                                    AND Label IN ('Pending','Opened','Bounced','Unsubscribed','Clicked')]){
            memberStatusMap.put(cstatus.campaignId,cstatus.Id);
        }        
        
        for(ID key : campaignIds){                        
            if(memberStatusMap == null || memberStatusMap.get(key) == null){
                // Add new campain member statuses            
                statusesToAdd.add(new CampaignMemberStatus(campaignId = key, Label = 'Pending', IsDefault = true));
                statusesToAdd.add(new CampaignMemberStatus(campaignId = key, Label = 'Opened'));
                statusesToAdd.add(new CampaignMemberStatus(campaignId = key, Label = 'Bounced'));
                statusesToAdd.add(new CampaignMemberStatus(campaignId = key, Label = 'Unsubscribed'));
                statusesToAdd.add(new CampaignMemberStatus(campaignId = key, Label = 'Clicked')); 
            }
        }
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
        insert statusesToAdd;
    }
}
public Class ContentVersionTriggerHandler implements ITrigger
{
    
    // Process 1 Data : map topic name as key (Category and Type) and contentVersion
    Map<String,Set<String>> allTopicsContent = null;
    List<TopicAssignment> allTopicAssignment = null;                       
    
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){
          
    }
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){  
        
        String userType = UserInfo.getUserType();
        if((Trigger.isInsert || Trigger.isUpdate) && !userType.EqualsIgnoreCase(ContentVersionObjectHelper.COMMUNITY_USER_TYPE))
        {        
            allTopicsContent = new Map<String,Set<String>>();
            for(sObject conObj : Trigger.New)
            {
                ContentVersion con = (ContentVersion)conObj;
                if(con.Category__c!=null)
                {
                    String catName = con.Category__c.toLowerCase();
                    if(!allTopicsContent.containsKey(catName))
                        allTopicsContent.put(catName,new Set<String>());
                    allTopicsContent.get(catName).add(con.id);    
                }
                if(con.Type__c!=null)
                {
                    String typeName = con.Type__c.toLowerCase();
                    if(!allTopicsContent.containsKey(typeName))
                        allTopicsContent.put(typeName,new Set<String>());
                    allTopicsContent.get(typeName).add(con.id);    
                }
            }
        }        
    }
    
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){
    }
    
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){
    }
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){        
    }
    
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
            allTopicAssignment =  ContentVersionObjectHelper.createContentVersionTopic(allTopicsContent,Trigger.newMap);
    }
    
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){        
            allTopicAssignment =  ContentVersionObjectHelper.createContentVersionTopic(allTopicsContent,Trigger.newMap);
    }
    
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){
    } 
    //Finally do operations to Commit 
    public void finish(){        
        //Process 1 Result Commit  
        // Putting this in try Catch as if any error will come it should not stop the transaction
        //        
        try{
            if(allTopicAssignment!=null && allTopicAssignment.size()>0)
                Database.upsert(allTopicAssignment); 
        }catch(Exception ex){
            System.debug('Exception-->>'+ex.getMessage());
        }        
    }
}
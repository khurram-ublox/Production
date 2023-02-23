public Class ContentVersionObjectHelper{
    
    public static string COMMUNITY_USER_TYPE = 'CspLitePortal';
    // Create TopicAssignment for available Topics and ContentVersion
    public static List<TopicAssignment> createContentVersionTopic(Map<String,Set<String>> allTopicsContent,Map<Id,sObject> cvMap)
    {
        List<TopicAssignment> allTopicAssignment = null;
        if(allTopicsContent!=null && allTopicsContent.size()>0)
        {
            
            allTopicAssignment = new List<TopicAssignment>();
            for(Topic tObj : [select id,Name from topic where Name IN: allTopicsContent.keySet() AND NetworkId = NULL]){
                
                String tObjName = tObj.Name.toLowerCase();
                if(allTopicsContent.containsKey(tObjName))
                {
                    for(String cId : allTopicsContent.get(tObjName))
                    {
                        allTopicAssignment.add(new TopicAssignment(EntityId=((ContentVersion)cvMap.get(cId)).ContentDocumentId,TopicId=tObj.id));
                    }
                }
            }           
        }
        return allTopicAssignment;
    }
}
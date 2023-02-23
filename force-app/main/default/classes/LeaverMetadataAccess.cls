public without sharing class LeaverMetadataAccess {
    @AuraEnabled
    public static List<sObject> getSOQLResult(String soqlStr)
    {
        return Database.query(soqlStr);
    }
    @AuraEnabled
    public static void deleteScheduleJobs(String userId)
    {
        List<CronTrigger> listCronTrigger = [select Id from CronTrigger 
        where OwnerId =: userId];
		If (listCronTrigger.size() > 0)
		{
			for (Integer i = 0; i < listCronTrigger.size(); i++)
			    System.abortJob(listCronTrigger[i].Id);	
		}
    }
    
}
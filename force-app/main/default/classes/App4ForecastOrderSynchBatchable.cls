public inherited sharing class App4ForecastOrderSynchBatchable implements Database.Batchable<sObject>
{
    public String query;
  
    public  App4ForecastOrderSynchBatchable()
        
    {
        query = '';
        query = 'Select Id From Billings__c Where a4a_needs_Update__c = True';
    }
    
    public Database.QueryLocator start(
        Database.BatchableContext  BC){

        return  Database.getQueryLocator(query);
            
    }
    
    public void execute(Database.BatchableContext info, List<sObject> scope) 
    {
        Database.SaveResult[] updateResult = Database.update(scope,false);
        
    }   
    
    public void finish(Database.BatchableContext info) {
        
    }
}
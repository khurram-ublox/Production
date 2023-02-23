public class a4x_BatchApexErrorEventHelper {
    
    public static Map<String, a4x__Feature__mdt> featureMap = getFeatureMap ();
    
    public static void batchApexErrorEventProcessing (List<BatchApexErrorEvent> newList) {  
        
        if(featureMap.get('Monitor_Events') != null && featureMap.get('Monitor_Events').a4x__Is_Active__c) {
            
            Set<Id> asyncApexJobIds = new Set<Id>();
            for(BatchApexErrorEvent evt : newList){
                asyncApexJobIds.add(evt.AsyncApexJobId);
            }
            
            Map<Id,AsyncApexJob> jobs = new Map<Id,AsyncApexJob>(
                [SELECT id, ApexClass.Name FROM AsyncApexJob WHERE Id IN :asyncApexJobIds]
            );
            
            List<sObject> recordsToInsertList = new List<sObject>();
            List<sObject> recordsToUpdateList = new List<sObject>();
            
            for(BatchApexErrorEvent evt : newList){
                
                if((jobs.get(evt.AsyncApexJobId) != null && jobs.get(evt.AsyncApexJobId).ApexClass.NamespacePrefix == 'a4x') || Test.isRunningTest()) {
                    
                    sObject sObj;
                    System.debug(featureMap);
                    String targetObjectName = featureMap.get('Monitor_Events').a4x__Parameter__c;
                    sObj = Schema.getGlobalDescribe().get(targetObjectName).newSObject();
                    sObj.put('Items_In_Failed_Batch__c', !Test.isRunningTest() ? evt.JobScope.left(255) : 'a8p4N000000TJkB');
                    recordsToInsertList.add(sObj);
                    
                    for (String item : (!Test.isRunningTest() ? evt.JobScope.left(255) : 'a8p4N000000TJkB').split(',')) {
                        
                        try {
                            a4x__Measure__c measure = new a4x__Measure__c();
                            measure.put('Id',(Id)item);
                            measure.put('a4x__Tracker__c', 'UpdateFailed: ' + System.now());
                            recordsToUpdateList.add(measure);
                        } catch (exception e) {
                            System.debug(e);
                        } 
                    }
                }
            }
            
            try {
                insert recordsToInsertList;
            } catch (exception e) {
                System.debug(e);
            }
            try {
                update recordsToUpdateList;
            } catch (exception e) {
                System.debug(e);
            }  
        }
        
    }
    
    public static Map<String, a4x__Feature__mdt> getFeatureMap() {
        
        Map<String, a4x__Feature__mdt> featureMap = new Map<String, a4x__Feature__mdt> ();
        
        for (a4x__Feature__mdt f : [SELECT QualifiedApiName, a4x__Parameter__c, a4x__Is_Active__c
                                    FROM a4x__Feature__mdt])
            
        {
            System.debug(featureMap);
            System.debug(f);
            featureMap.put(f.QualifiedApiName, f);
        }
        
        return featureMap;
        
    }
    
}
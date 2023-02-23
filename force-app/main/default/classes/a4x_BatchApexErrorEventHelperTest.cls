@isTest
private class a4x_BatchApexErrorEventHelperTest {
    
    @isTest 
    static void unitTestBatchApexErrorEventTriggerTest() {
        
        System.debug(a4x_BatchApexErrorEventHelper.featureMap);
        
        a4x_BatchApexErrorEventHelper.featureMap.put('Monitor_Events', new a4x__Feature__mdt(QualifiedApiName = 'Monitor_Events', a4x__Parameter__c = 'a4x_Monitoring_Event__c', a4x__Is_Active__c = True));
        
        // Publish Event
        BatchApexErrorEvent batchApexErrorEvent = new BatchApexErrorEvent(AsyncApexJobId = 'axy1p00000yNjZ1');
        
        Test.startTest();
        Database.SaveResult sr1 = EventBus.publish(batchApexErrorEvent);

        // Verify that the publish was successful
        System.assertEquals(true, sr1.isSuccess());        
        Test.stopTest();  
    }
}
/**
* @description Helper class for Order Trigger.
*/

public inherited sharing class OrderTriggerHelper {
    
    public static void orderProcessingApp4Forecast (List<Billings__c> newList, Map<Id, Billings__c> newMap, List<Billings__c> oldList, Map<Id, Billings__c> oldMap) {
        
        // Order Processing App4Forecast 
        a4x__app4forecast__c orgDefaults = a4x__app4forecast__c.getOrgDefaults();
        Map<Id,String> eventsMap = new Map <Id,String> ();
        List<a4x__Measure_Event__e> measureEvents = New List<a4x__Measure_Event__e>();
        
        // Before Insert
        if (Trigger.isBefore && Trigger.isInsert) {
            for (Billings__c o: newList) {
                o.a4a_Measure_Filter__c = o.a4a_Measure_Filter_Formula__c;
            }
        }
        
        // After Insert
        if (Trigger.isAfter && Trigger.isInsert) {
            for (Billings__c o: newList) {
                if(o.a4a_Measure_Filter__c == true) {
                    eventsMap.put(o.Id,'orderUpserted');
                }
            }
        }    
        
        // Before Update
        if (Trigger.isBefore && Trigger.isUpdate) {   
            for (Billings__c o: newList) {
                
                o.a4a_Measure_Filter__c = o.a4a_Measure_Filter_Formula__c;
                
                // Filter Remains On
                if(o.a4a_Measure_Filter__c == true && oldMap.get(o.Id).a4a_Measure_Filter__c == true){
                    
                    eventsMap.put(o.Id,'orderUpserted');
                    
                }
                
                // Filter On
                if(o.a4a_Measure_Filter__c == true && oldMap.get(o.Id).a4a_Measure_Filter__c == false){
                    eventsMap.put(o.Id,'orderMeasureFilterOn');
                }
                
                // Filter Off
                if(o.a4a_Measure_Filter__c == false && oldMap.get(o.Id).a4a_Measure_Filter__c == true){
                    eventsMap.put(o.Id,'orderMeasureFilterOff');
                } 
                
            }
        }
        
        // Before Delete
        if (Trigger.isBefore && Trigger.isDelete) {
            for (Billings__c o: oldList) {
                eventsMap.put(o.Id,'orderDeleted');
            }    	  
        }
        
        if (eventsMap.size() > 0) {
            for (Id oid : eventsMap.keySet()) {
                measureEvents.add(new a4x__Measure_Event__e(a4x__Triggering_Id__c = oid, a4x__Event_Type__c = eventsMap.get(oid)));
            }
        }
        
        if(measureEvents.size()>0 && orgDefaults.a4x__Measure_Events_Active__c) EventBus.publish(measureEvents); 
    }
    
}
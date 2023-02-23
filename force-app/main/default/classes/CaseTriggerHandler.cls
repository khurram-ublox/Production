public without sharing class CaseTriggerHandler implements ITrigger{

    List<Task> TaskToUpdate = new List <Task>();
    list<Case> casesToUpdate = new list<Case>();
            
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){}
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){}
    
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){
        list<Case> caseList = (list<Case>)trigger.new;
        CaseObjectHelper.populateOpportunityFromCaseRegNumber(caseList);
    }        

    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){}

    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){
        /*list<Case> caseList = (list<Case>)trigger.new;
        map<Id,Case> caseOldMap = (map<Id,Case>)trigger.oldMap;
        CaseObjectHelper.populateOpportunityFromCaseRegNumber(caseList,caseOldMap);*/
    }
    
    // Process logic/functioanlities in other classes for after Update  event
    public void afterUpdate(){

        list<Case> caseList = (list<Case>)trigger.newMap.values();
        map<Id,Case> caseOldMap = (map<Id,Case>)trigger.oldMap;
        map<id,id> caseContactIds = new map<id,id>();
        Id caseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Legal Case').getRecordTypeId();
           
        for (Case i: caseList ) {
            if ((i.ContactId !=  caseOldMap.get(i.Id).ContactId) && (i.RecordTypeId == caseRecType)) {
                caseContactIds.put(i.id,i.ContactId);
            }
        }
       
        if(caseContactIds.size() > 0){
            
            for(Task TaskToCheck : [SELECT Id, 
                                    Subject, 
                                    WhoId, 
                                    WhatId 
                                    FROM Task WHERE WhatId IN: caseContactIds.keySet()
                                    AND ((Subject = 'Email: NDA sent to the customer')
                                    OR (Subject = 'Email: NDA Americas sent to the customer')
                                    OR (Subject = 'Email: LULA-M sent to the customer')
                                    OR (Subject = 'Email: EUS sent to the customer'))]){
                
                TaskToCheck.WhoId = caseContactIds.get(TaskToCheck.WhatId);
                TaskToUpdate.add(TaskToCheck);            
            }
        }
    }
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){}    
    
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){}

    //Finally do operations to Commit
    public void finish(){
        update TaskToUpdate;        
    }
}
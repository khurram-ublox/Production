trigger createCompletedTaskForExhibition on Lead (after insert, after update) {

    List<Lead> SourceLead = [
        SELECT Id, Exhibition__c, Exhibition__r.Name, Exhibition__r.Start_Date__c, ConvertedContactId, ConvertedOpportunityId
        FROM Lead
        WHERE IsConverted = true AND Exhibition__c <> null AND Id IN :Trigger.newMap.keySet()];
    List<Task> TaskToCreate = new List <Task>{};

        for(Lead a: SourceLead){
            Task b = new Task(Subject=a.Exhibition__r.Name+' (created on Lead conversion)',ActivityDate=a.Exhibition__r.Start_Date__c,Status='Completed',Type='Trade show visit',WhoId=a.ConvertedContactId,WhatId=a.ConvertedOpportunityId,Exhibition__c=a.Exhibition__c);
            TaskToCreate.add(b);
        }    
    insert TaskToCreate;

}
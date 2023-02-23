trigger createCompletedTaskForNoOppLead on Lead (after insert, after update) {

    List<Lead> SourceLead = [
        SELECT Id, LeadSource, ConvertedContactId, ConvertedAccountId, Request__c, Project_Name__c, Project_Description__c, New_Application_Type__c, Annual_Quantity__c, Date_Production__c, Products_Of_Interest__c
        FROM Lead
        WHERE IsConverted = true AND ConvertedOpportunityId = null AND LeadSource != 'Digi-Key' AND
        Id IN :Trigger.newMap.keySet()];
    List<Task> TaskToCreate = new List <Task>{};

        for(Lead a: SourceLead){
            /* Create a completed Task only if at least one of the following fields has value. */
            Datetime productionDate = a.Date_Production__c;
            String productionDateFormat = productionDate!=null?productionDate.format('MMMM d,  yyyy'):'';
            if (a.LeadSource != null || 
                a.Project_Name__c != null || 
                a.New_Application_Type__c != null || 
                a.Annual_Quantity__c != null || 
                a.Date_Production__c != null || 
                !(String.isBlank(a.Project_Description__c)) || 
                !(String.isBlank(a.Request__c)) || 
                a.Products_Of_Interest__c != null) {

                    Task b = new Task(Subject='Lead conversion (no Opportunity generated)',ActivityDate=date.today(),Status='Completed',Type='Other',WhoId=a.ConvertedContactId,WhatId=a.ConvertedAccountId,
                                  Description=(a.LeadSource!=null?'Lead source: '+a.LeadSource+'\r\n':'')+
                                                  (a.Project_Name__c!=null?'Project name: '+a.Project_Name__c+'\r\n':'')+
                                                  (a.Project_Description__c!=null?'Project description: '+a.Project_Description__c+'\r\n':'')+
                                                  (a.New_Application_Type__c!=null?'Application: '+a.New_Application_Type__c+'\r\n':'')+
                                                  (a.Annual_Quantity__c!=null?'Planned annual quantity: '+a.Annual_Quantity__c+'\r\n':'')+
                                                  (a.Date_Production__c!=null?'Production start: '+productionDateFormat+'\r\n':'')+
                                                  (a.Products_Of_Interest__c!=null?'Product of interest: '+a.Products_Of_Interest__c+'\r\n':'')+
                                                  (a.Request__c!=null?'Request: '+a.Request__c+'\r\n':''));
                    TaskToCreate.add(b);
            }
        }
    insert TaskToCreate;

}
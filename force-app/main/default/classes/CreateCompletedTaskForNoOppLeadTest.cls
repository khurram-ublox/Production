@isTest
private class CreateCompletedTaskForNoOppLeadTest {
	
	  public static testMethod void testCreateCompletedTaskForNoOppLead()
        {
            Market_Classification__c classification = new Market_Classification__c(
                    IsActive__c = true,
                    Market__c = 'Automotive',
                    Market_Segment__c = 'Autonomous driving');
            Database.insert(classification);
        	
            Lead l = new Lead(LastName='testname', Company='testcompany', Project_Name__c = 'Test Project', IsConverted = false, Country='CH',Market_Classification__c = classification.id,New_Application_Type__c = 'Autonomous driving');
            insert l;
            
          
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(l.id);
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            lc.setDoNotCreateOpportunity(false);
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());

           // Datetime productionDate = l.Date_Production__c;
           // String productionDateFormat = productionDate.format('MMMM d,  yyyy');


           if(l.Project_Name__c != null){

           	Task t = new Task(Subject='Lead conversion (no Opportunity generated)',ActivityDate=date.today(),Status='Completed',Type='Other',WhoId=l.ConvertedContactId,WhatId=l.ConvertedAccountId,

           	Description = l.Project_Name__c!=null?'Project Name: '+l.Project_Name__c+'\r\n':'');
           	
           }
           
            
           
            Lead convertedLead = [SELECT Id, ConvertedContactId FROM Lead WHERE id = :l.id];
            
            
            

            	
            
            


            
        
        } 
	
}
/*
EmailMessage Object Helper class to have methods to assist EmailMessage related operation or process
*/
public class EmailMessageObjectHelper{
    //No need to split the closed case if case type is any from the following
    //    1. Failure Analysis (RMA)
    //    2. Design Review
    //    3. Engineering Job
    //    4. Custom Design
    //reference : IN_SF_MTC-1689
    // get the maping stored in custom metadata against each Case type
    private static map<string, Boolean> caseTypesToSplit(){
        map<string, Boolean> caseTypes = new map<string, Boolean>();
        for(Case_Type__mdt cType :[Select Label,Split_Case__c from Case_Type__mdt]){                     
            caseTypes.put(cType.Label, cType.Split_Case__c);                
        }
        return caseTypes;                
    }

    //Get Case EmailMessage Config custom setting to use in process
    static Case_EmailMessage_Config__c caseEmailConfig = Case_EmailMessage_Config__c.getInstance();
        
    //Check for closed cases and its Process to create new case and attach email message
    public static Map<Id,Case> checkForCloseCaseAndProcessMsg(Map<Id,List<EmailMessage>> caseEmailMsgMap)
    {
        
        Map<Id,Case> allFilteredClosedCaseMap = new Map<Id,Case>();
        Map<Id,Case> oldAndNewCaseToBeCreatedMap = new Map<Id,Case>();
        String dupStatus = CaseObjectHelper.STATUS_DUPLICATE;
        String closedStatus = CaseObjectHelper.STATUS_CLOSED;
        map<string, Boolean> splitCaseByType = caseTypesToSplit();
        map<Id, Boolean> skipCaseSplitByDomain = new map<Id,Boolean>();
        Boolean fromSkipDomain = false;
              
        //don't split the case if message came from domain like bosch.com
        if(!domainstoskip__c.getAll().isEmpty()){   

            for(Id caseId : caseEmailMsgMap.keySet()){
                for(EmailMessage eMessage : caseEmailMsgMap.get(caseId)){
                    for(string domain : domainstoskip__c.getAll().keySet()){                    
                        fromSkipDomain = eMessage.FromAddress.endsWithIgnoreCase(domain);
                        skipCaseSplitByDomain.put(caseId, fromSkipDomain);
                    }
                }
            }
        }        
        
        for(Case cObj : [select id,ClosedDate,Status,AccountId,ContactId,Opportunity__c,Origin,OwnerId,ParentId,Priority,Subject,Type,SuppliedEmail,RecordTypeId from case where id IN: caseEmailMsgMap.keySet() AND (Status =: dupStatus OR Status =: closedStatus)])
        {
            DateTime nowDT = System.DateTime.now();
            Integer daysInt = 0;
            Boolean messageFromSkipDomain = false;
            
            if(caseEmailConfig.Days_For_ClosedCase_Email__c!=null)
                daysInt = (Integer)caseEmailConfig.Days_For_ClosedCase_Email__c;
            DateTime expectedDateTime = cObj.ClosedDate.addDays(daysInt);
            if(!skipCaseSplitByDomain.isEmpty()){
                messageFromSkipDomain = skipCaseSplitByDomain.get(cObj.Id);
            }
                        
            if(nowDT>expectedDateTime && splitCaseByType.get(cObj.Type) && !messageFromSkipDomain){
                allFilteredClosedCaseMap.put(cObj.id,cObj);
            }
        }
        
        Map<Id,Case> allOldNewCaseMap = createNewCaseFromOldAndEmail(allFilteredClosedCaseMap,caseEmailMsgMap);
        populateNewCaseIdInEmailMessage(allOldNewCaseMap,caseEmailMsgMap);
        return allOldNewCaseMap;
    }
    //Create new case from old case and related email message
    public static Map<Id,Case> createNewCaseFromOldAndEmail(Map<Id,Case> oldCaseMap,Map<Id,List<EmailMessage>> caseEmailMsgMap){
        Map<Id,Case> allOldNewCaseMap = new Map<Id,Case>();
        for(Case cObj : oldCaseMap.values())
        {
            EmailMessage em = caseEmailMsgMap.get(cObj.id)[0];
            Case newCaseObj = CaseObjectHelper.createNewCaseFromOld(cObj);
            if(!String.isEmpty(caseEmailConfig.NewCase_From_Close_Business_Hours_Id__c))
                newCaseObj.BusinessHoursId = caseEmailConfig.NewCase_From_Close_Business_Hours_Id__c;
            if(!String.isEmpty(caseEmailConfig.NewCase_RecordType_Id__c))
                newCaseObj.RecordTypeId = caseEmailConfig.NewCase_RecordType_Id__c;
            if(em.TextBody!=null)
                newCaseObj.Description = em.TextBody.length() > 31995 ? em.TextBody.subString(0,31995) :em.TextBody ;
            newCaseObj.Subject = em.Subject;
            allOldNewCaseMap.put(cObj.id,newCaseObj);
        }
        //system.debug('allOldNewCaseMap >>>'+allOldNewCaseMap);
        Database.insert(allOldNewCaseMap.values());
        return allOldNewCaseMap;
    }
    //Populate case id in Email Message to associate email message to new case
    public static void populateNewCaseIdInEmailMessage(Map<Id,Case> allOldNewCaseMap,Map<Id,List<EmailMessage>> caseEmailMsgMap)
    {
        for(ID oldCaseId :allOldNewCaseMap.keySet())
        {
            Case newCaseObj = allOldNewCaseMap.get(oldCaseId);
            for(EmailMessage emailMsgObject : caseEmailMsgMap.get(oldCaseId)){
                emailMsgObject.ParentId = newCaseObj.id;
                emailMsgObject.RelatedToId = newCaseObj.id;
            }
        }
    }
}
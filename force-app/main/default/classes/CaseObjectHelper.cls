/*
Case Object class to have methods to assist case related operation or process
*/
public class CaseObjectHelper {
    public static final string STATUS_CLOSED = 'Closed';
    public static final string STATUS_DUPLICATE = 'Duplicate';
    private static final string PORTAL_CASE = 'u-blox Portal';
    //Create new case from old
    public static Case createNewCaseFromOld(Case cObj)
    {
        Case newCaseObj = new Case();
        newCaseObj.AccountId = cObj.AccountId;
        newCaseObj.ContactId = cObj.ContactId;
        newCaseObj.Description = '';
        newCaseObj.Opportunity__c = cObj.Opportunity__c;
        newCaseObj.Origin = cObj.Origin;
        if(isUserActive(cObj.OwnerId)) {
        	newCaseObj.OwnerId = cObj.OwnerId;   
        }
        newCaseObj.ParentId = cObj.Id;
        newCaseObj.Priority = cObj.Priority;
        newCaseObj.Subject = 'New Case';
        newCaseObj.Type = cObj.Type;
        newCaseObj.SuppliedEmail = cObj.SuppliedEmail;
        
        return newCaseObj;
    }
    
    public static Boolean isUserActive(Id userId) {
        User u;
        try {
        	u = [select id, IsActive from user where id =: userid Limit 1];
        } catch (Exception e) {
            System.debug('Following is the Exception Message:'+e.getMessage());
            return false;
        }
        return u.IsActive;
    }
    
    /*
        Before Insert : Auto Populate the Case with Opportunity by matching the Registration Number
        Community Users who has the permission set : Community: Case Registration Number Access
        in profile can only give Registration Number from Portal        
    */
    public static void populateOpportunityFromCaseRegNumber(list<Case> allCases){
        map<string,Case> caseRegistrationNumsMap = new map<string,Case>();
        
        for(Case ticket : allCases){
            if(ticket.Origin == PORTAL_CASE 
                && !string.isBlank(ticket.Registration_No__c)){
                    caseRegistrationNumsMap.put(ticket.Registration_No__c,ticket);
            }
        }
        updateCaseWithOpportunity(caseRegistrationNumsMap);     
    }

    /*
        Before Update : Auto Populate the Case with Opportunity by matching the Registration Number
        Currently disabled this on request of petri.
    */
/*
    public static void populateOpportunityFromCaseRegNumber(list<Case> allCases, map<Id, Case> oldMap){
        map<string,Case> caseRegistrationNumsMap = new map<string,Case>();
        
        for(Case ticket : allCases){
            if(ticket.Origin == PORTAL_CASE 
                && !string.isBlank(ticket.Registration_No__c)
                && oldMap.get(ticket.Id).Registration_No__c != ticket.Registration_No__c){
                    caseRegistrationNumsMap.put(ticket.Registration_No__c,ticket);
            }
        }
        updateCaseWithOpportunity(caseRegistrationNumsMap);     
    }
*/
    private static void updateCaseWithOpportunity(map<string,Case> caseRegistrationNumsMap){
        if(caseRegistrationNumsMap.size() > 0){
            for(Opportunity opp : [Select Id,Registration_No__c from Opportunity 
                                    where Registration_No__c IN : caseRegistrationNumsMap.keySet()]){
                caseRegistrationNumsMap.get(opp.Registration_No__c).Opportunity__c = opp.Id;
            }
        }
    }    
}
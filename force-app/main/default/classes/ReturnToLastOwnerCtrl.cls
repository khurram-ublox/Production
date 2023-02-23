global without sharing class ReturnToLastOwnerCtrl {

    public ReturnToLastOwnerCtrl(ApexPages.StandardController controller) {

    }
    
    @RemoteAction
    global static Boolean updatedCaseId(String CaseId){

        if(CaseId==null) return false;
        
        Case c = [Select Id,lastModifiedDate,lastModifiedById,Case_Returned__c from Case where id=:CaseId];
        
        String UserId = UserInfo.getUserId();
        string givenTimeDiff = Label.Case_Escalation_Time_Difference_in_Seonds;
        givenTimeDiff = givenTimeDiff == null? '5' : givenTimeDiff;
        Integer requiredTimeDifference = Integer.valueOf(givenTimeDiff);
        DateTime lastReturn = c.Case_Returned__c == null? c.lastModifiedDate.addSeconds(-requiredTimeDifference) : c.Case_Returned__c;

        Long diffInSeconds = utility.getTimeDifferenceInSeconds(DateTime.now(), lastReturn);                
        // Case can not return again to last owner in less than 30 seconds
        if(c.lastModifiedById == UserId && diffInSeconds < requiredTimeDifference){            
            throw new ApexException(Label.Case_Double_Owner_Change_Message);
        }
        
        // creates a CaseTeamMember record for the logged in user         
        CaseTeamMember[] checkctObjlst=[Select id from CaseTeamMember where ParentId=:CaseId and MemberId=:UserId];
        if(checkctObjlst.isEmpty()) {
            CaseTeamMember ctm =new CaseTeamMember(
                ParentId = c.Id,
                MemberId = UserId,
                TeamRoleId = '0B7D0000000CanX' // standard team role (first and only available) 
            );
            insert ctm;
        }else{
            // leave script run until the end
            // return false;
        }
          
        // returns case to the case initiator
        string LastOwnerId;

        for(CaseHistory history : [Select CaseId, 
                    CreatedById, 
                    CreatedDate, 
                    Field, 
                    NewValue, 
                    OldValue 
                    FROM CaseHistory 
                    where CaseId =: CaseId AND Field = 'Owner'
                    order by CreatedDate DESC]){
            
            string oldVal;
            if(history.OldValue != null){
                oldVal = string.valueOf(history.OldValue);                
                if(oldVal.startsWith('005')){
                    list<User> commUser = [Select Id from User where Id=: oldVal AND Profile.Name = 'Community Registered User'];
                    if(commUser.size() > 0) continue;
                    LastOwnerId = oldVal;
                    break;
                }else continue;
            }
        }
                
        if(String.isNotBlank(LastOwnerId)){
            c.OwnerId = LastOwnerId;
            c.Case_Returned__c = system.now();        
            // set flag to trigger notification mail to new owner
            c.Send_Notification_Mail__c = true;        
            update c;            
        }
        else if(!test.isRunningTest()){
            throw new ApexException('Could not find the last owner of the case from history, please escalate the case first');            
        }
        return true;           
    }
}
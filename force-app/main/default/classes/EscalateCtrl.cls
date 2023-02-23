global without sharing class EscalateCtrl {
    private static ServiceCloud_EscalationHandler eHandler = null;
    
    public EscalateCtrl(ApexPages.StandardController controller) {
        
    }
    
    @RemoteAction
    global static Boolean escalateCaseId(String CaseId){ 
        if(CaseId==null) return false;         
        
        Case c = [Select Id,
                    Account.uB_Office__c,                    
                    Account.FAE__r.Name,
                    Account.owner.Name,
                    isDirect__c,
                    OwnerId, 
                    Owner.Name, 
                    Type,
                    Status, 
                    TransferOwnerId__c, 
                    Escalation_Source__c, 
                    Case_Initiator_Source__c, 
                    CreatedById, 
                    Created_By_Partner__c, 
                    Technology__c, 
                    Current_User_Internal__c,
                    is_Escalated_to_L2__c,
                    lastModifiedDate,
                    lastModifiedById
                    from Case where Id=:CaseId];
        
        User u = [Select Id,
                    Name,
                    uB_Office__c, 
                    UserType, 
                    ManagerId, 
                    CaseNextOwnerIDSER__c, 
                    CaseNextOwnerIDCEL__c, 
                    CaseNextOwnerIDSHO__c, 
                    CaseNextOwnerIDPOS__c, 
                    ProfileId,
                    Profile.Name,
                    UserRoleId,
                    UserRole.Name
                    from User where Id=:userinfo.getuserId()];        
        
        //String UserId = UserInfo.getUserId();
        String OwnerId = c.OwnerId;
        string givenTimeDiff = Label.Case_Escalation_Time_Difference_in_Seonds;
        givenTimeDiff = givenTimeDiff == null? '5' : givenTimeDiff;
        Integer requiredTimeDifference = Integer.valueOf(givenTimeDiff);

        Long diffInSeconds = utility.getTimeDifferenceInSeconds(DateTime.now(), c.lastModifiedDate);                
        // Case can not be escalated again in less than 30 seconds for same user
        if(c.Status == 'Escalated' && c.lastModifiedById == u.Id && diffInSeconds < requiredTimeDifference){            
            throw new ApexException(Label.Case_Double_Escalation_Message);
        }
        
        // if member is user add to team member (user-005,queue-00G)
        if( OwnerId.startsWith('005')) {
            // create a CaseTeamMember record for the actual owner of the case        
            Boolean memberExists = [Select COUNT() from CaseTeamMember where ParentId=:CaseId and MemberId=:OwnerId LIMIT 1] > 0;
            if(memberExists == false){ 
                CaseTeamMember ctm =new CaseTeamMember(
                    ParentId = c.Id,
                    MemberId = OwnerId,
                    TeamRoleId = '0B7D0000000CanX' // standard team role (first and only available) 
                );
                insert ctm;
            }
        }
        
        if(eHandler == null){
            eHandler =  new ServiceCloud_EscalationHandler();
        }
        eHandler.setCaseToEscalate(c);
        eHandler.setContextUser(u);
        c = eHandler.escalateCase();        
        if(!Test.isRunningTest()){ 
            update c;
        }
        return true;
    }
}
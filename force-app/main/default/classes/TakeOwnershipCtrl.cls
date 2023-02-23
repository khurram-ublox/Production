global without sharing class TakeOwnershipCtrl {

    public TakeOwnershipCtrl(ApexPages.StandardController controller) {

    }
    
    @RemoteAction
    global static Boolean updatedCaseId(String CaseId){
      
        if(CaseId==null) return false;

        Case c = [Select Id,OwnerId,CreatedById from Case where id=:CaseId];
        
        String OwnerId = c.OwnerId;
		String UserId = UserInfo.getUserId();

        if( OwnerId.startsWith('005') ) {
            // creates a CaseTeamMember record for the actual owner of the case        
            CaseTeamMember[] checkctObjlst=[Select id from CaseTeamMember where ParentId=:CaseId and MemberId=:OwnerId];
            if(checkctObjlst.isEmpty()){
                 CaseTeamMember ctm =new CaseTeamMember(
                    ParentId = c.Id,
                    MemberId = OwnerId,
                    TeamRoleId = '0B7D0000000CanX' // standard team role (first and only available) 
                );
                insert ctm;
            }else{
                // leave script run until the end
                // return false;
            }

        }
        // returns case to the case initiator

        c.OwnerId = UserId;
        c.Status = 'Working';

        update c;
        
        return true;
    }

}
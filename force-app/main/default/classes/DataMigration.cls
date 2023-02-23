public class DataMigration {
    public Map<Id, Id> usersIdMap = new Map<Id, Id> ();
    public Id acc; //Id of the dummy account to which results will be stored
    public Id batchInstanceId1;
    public Id batchInstanceId2;
    public Map<String, List<String>> objectFieldMapping = new Map<String, List<String>>();
	public Map<String, String> objectWhereMapping = new Map<String, String>();
	public Map<String, String> manualSharingQueries = new Map<String, String>();
    public Map<String, List<String>> fieldstoUpdateMapping = new Map<String, List<String>>();
	
    public void EXECUTE() {        
        changeOwner();
        changeManualSharing();
    }
	
	public void ExecuteWithConfig() { 
		populateChangeOwnerConfig();
		populateManualSharingConfig();
        changeOwner();
        changeManualSharing();
    }
	//Call this function before execute
	public void populateChangeOwnerConfig()
	{
		objectFieldMapping.put('Account', new List<String>{'FAE__c', 'Global_Account_Manager__c', 'Previous_Owner__c', 'RAE__c', 'Sales_Admin__c', 'Service_Sales_Manager__c'});
        
        objectFieldMapping.put('Contact',  new List<String>{'OwnerId'});
        
        objectFieldMapping.put('Lead',  new List<String>{'OwnerId', 'Lead_Source_Person_User__c'});
        objectWhereMapping.put('Lead', 'AND IsConverted = False');
        
        objectFieldMapping.put('Case',  new List<String>{'OwnerId', 'Case_Initiator_Source__c', 'Last_Comment_By__c', 'Return_To__c'});
        
        objectFieldMapping.put('Opportunity',  new List<String>{'OwnerId', 'Account_Channel_Manager_Obj__c', 'Account_Owner__c', 'FAE__c', 'Lead_Source_Person_User__c', 'Owner_CEL__c', 'Owner_POS__c', 'Owner_PC_SER__c', 'Owner_SHO__c'});
        
        objectFieldMapping.put('Variable__c',  new List<String>{'OwnerId'});
        objectFieldMapping.put('Competitor_Product_Price__c',  new List<String>{'OwnerId'});
        objectFieldMapping.put('Task',  new List<String>{'OwnerId'});
        
        objectFieldMapping.put('note',  new List<String>{'OwnerId'});
        objectFieldMapping.put('Attachment',  new List<String>{'OwnerId'});
	}
	// parent id in the case team member
    // run in chain
	//Call this function before execute
	public void populateManualSharingConfig()
	{
		// Manaul sharing Job
        String conditions = ' and (RowCause != \'Owner\' and RowCause != \'ImplicitParent\' and RowCause != \'ImplicitChild\')';
        String conditionAccount = ' and (RowCause != \'Owner\' and RowCause != \'ImplicitChild\')';
        String accountShare = 'Select Id, AccountAccessLevel, AccountId, CaseAccessLevel, ContactAccessLevel, OpportunityAccessLevel, RowCause, UserOrGroupId from AccountShare  Where UserorGroupId IN :oldUserIds '+conditionAccount;
        String contactShare = 'Select Id, ContactId, ContactAccessLevel, IsDeleted, RowCause, UserOrGroupId from ContactShare Where UserorGroupId IN :oldUserIds '+conditions;
        String leadShare = 'Select Id, IsDeleted, LeadAccessLevel, LeadId, RowCause, UserOrGroupId from LeadShare Where UserorGroupId IN :oldUserIds '+conditions;
        String caseShare = 'Select Id, CaseAccessLevel, CaseId, IsDeleted, UserOrGroupId from CaseShare Where UserorGroupId IN :oldUserIds '+conditions;
        String opportunityShare = 'Select Id, IsDeleted, OpportunityAccessLevel, OpportunityId, RowCause, UserOrGroupId from OpportunityShare Where UserorGroupId IN :oldUserIds '+conditions;
        String caseTeamMember = 'Select Id, MemberId, ParentId, TeamRoleId, TeamTemplateId, TeamTemplateMemberId from CaseTeamMember Where MemberId IN :oldUserIds';
        String accountTeamMember = 'Select Id, AccountAccessLevel, AccountId, CaseAccessLevel, ContactAccessLevel, CurrencyIsoCode, IsDeleted, OpportunityAccessLevel, PhotoURL, TeamMemberRole, Title, UserId from AccountTeamMember Where UserId IN :oldUserIds';
        
        manualSharingQueries.put('AccountShare', accountShare);
        fieldstoUpdateMapping.put('AccountShare', new List<String>{'UserorGroupId'});
        
        manualSharingQueries.put('ContactShare', contactShare);
        fieldstoUpdateMapping.put('ContactShare', new List<String>{'UserorGroupId'});
        
        manualSharingQueries.put('OpportunityShare', opportunityShare);
        fieldstoUpdateMapping.put('OpportunityShare', new List<String>{'UserorGroupId'});
        
        manualSharingQueries.put('LeadShare', leadShare);
        fieldstoUpdateMapping.put('LeadShare', new List<String>{'UserorGroupId'});
        
        manualSharingQueries.put('CaseShare', caseShare);
        fieldstoUpdateMapping.put('CaseShare', new List<String>{'UserorGroupId'});
        
        manualSharingQueries.put('CaseTeamMember', caseTeamMember);
        fieldstoUpdateMapping.put('CaseTeamMember', new List<String>{'MemberId'});
        
        manualSharingQueries.put('AccountTeamMember', accountTeamMember);
        fieldstoUpdateMapping.put('AccountTeamMember', new List<String>{'UserId'});        
	}
	
    public void changeOwner() {
        for (String e : objectFieldMapping.keySet()) {
            String w = objectWhereMapping.get(e) != null ? objectWhereMapping.get(e) : '';
            batchInstanceId1 = Database.executeBatch(new BatchOwnerUpdater(e,objectFieldMapping.get(e),w,acc, usersIdMap));
        }
    }

    // clone record with new user ids
    public void changeManualSharing() {
        for (String e : manualSharingQueries.keySet()) {
            List<String> fieldstoUpdate = fieldstoUpdateMapping.get(e) != null ? fieldstoUpdateMapping.get(e) : new List<String>();
            batchInstanceId2 = Database.executeBatch(new BatchManualSharingUpdater(e,manualSharingQueries.get(e),acc, usersIdMap, fieldstoUpdate));
        }
    }
}
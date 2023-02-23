global with sharing class NewContractCtrl {

    public NewContractCtrl(ApexPages.StandardController controller) {

    }

    @RemoteAction
    global static Boolean execute(String CaseId){

        if(CaseId==null) return false;
        
        Case cl = [SELECT Id, AccountId, Account.Name, Account.OwnerId, Account.Owner.Profile.Name, CreatedDate, Type FROM Case WHERE Id =: CaseId];
        
        String AccountName = cl.Account.Name;
                
        if (AccountName.length() > 64) {
          AccountName = AccountName.substring(0,64);
        }
        String ContractOwnerProfile = cl.Account.Owner.Profile.Name;
        String ContractOwnerId = cl.Account.OwnerId;
        
        List<String> profilesToRestrict = CommonUtils.getRestrictedProfilesForContract();
        Set<String> restrictedProfiles = new Set<String>();
        
        restrictedProfiles.addAll(profilesToRestrict);
        if (restrictedProfiles.contains(ContractOwnerProfile)) {
            ContractOwnerId = UserInfo.getUserId();
        }
        
        
        String CaseCreatedDate = string.valueOf(cl.CreatedDate);
        String CaseType = cl.Type;
        String ContractName = '';
        
        Contract c = new Contract();
            
        if (CaseType == 'Legal (e-NDA)') {
          ContractName  = AccountName + ' - NDA - ' + CaseCreatedDate.substring(0, 4);
          c.Contract_Category__c = 'NDA';
          c.u_blox_Entity__c = 'u-blox AG';
        } else if (CaseType == 'Legal (e-NDA Americas)') {
          ContractName  = AccountName + ' - NDA - ' + CaseCreatedDate.substring(0, 4);
          c.Contract_Category__c = 'NDA';
          c.u_blox_Entity__c = 'u-blox America Inc.';
        } else if (CaseType == 'Legal (e-LULA-M)') {
          ContractName  = AccountName + ' - LULA-M - ' + CaseCreatedDate.substring(0, 4);
          c.Contract_Category__c = 'License Agreement';
          c.u_blox_Entity__c = 'u-blox AG';
        } else if (CaseType == 'Legal (e-LULA-N)') {
          ContractName  = AccountName + ' - LULA-N - ' + CaseCreatedDate.substring(0, 4);
          c.Contract_Category__c = 'License Agreement';
          c.u_blox_Entity__c = 'u-blox AG';
        }else if(CaseType == 'End Use Statement'){
          ContractName  = AccountName + ' - EUS - ' + CaseCreatedDate.substring(0, 4);
          c.Contract_Category__c = 'End Use Statement';
          c.u_blox_Entity__c = 'u-blox AG';
        }
        
        c.Name = ContractName;
        c.OwnerId = ContractOwnerId;
        c.AccountId = cl.AccountId; 
        c.Applicability__c = 'Group';
        c.StartDate = cl.CreatedDate.date();
        c.Contract_Survival_Period_Years__c = 5;
        c.Related_Case__c = CaseId;
        
        insert c;
        return true;
    }
}
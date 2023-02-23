Public Class AccountObjectHelper{
    
    public static List<Contract> getContractsForOwnerWithRestriction(Map<Id,List<Id>> accMapWithOwnerChange,Map<ID,sObject> oldAccountMap)
    {    
        List<Contract> conList = new List<Contract>();
        
        // Get the profile name list from custom setting
        List<string> profilesToRestrict = CommonUtils.getRestrictedProfilesForContract();        
        
        if(accMapWithOwnerChange!=null && accMapWithOwnerChange.size()>0)
        {
            List<ID> accIds = new List<ID>();
            Set<ID> userIds = new Set<ID>();
            
            // Query all user from accMapWithOwnerChange to get profile Name to filter list of accounts 
            for(User userObj :[select id,profileid,profile.name from user where id in: accMapWithOwnerChange.keySet() AND profile.Name in: profilesToRestrict ] )
            {
                if(accMapWithOwnerChange.get(userObj.id)!=null)
                {
                    accIds.addAll(accMapWithOwnerChange.get(userObj.id));
                    userIds.add(userObj.id);
                }        
            }
            
            
            if(accIds.size()>0 && userIds.size()>0)
            {
                // Get all the contracts for selected accounts + Owners and change the OwnerId to older ones
                for(Contract con : [select id,OwnerId,accountId from Contract where accountid in: accIds AND OwnerId in:userIds AND status ='Draft'])
                {
                    con.OwnerId = ((Account) oldAccountMap.get(con.accountId)).OwnerId;
                    conList.add(con);
                }              
            }    
        }
        
        return conList;
    }    
    /*getAccTeamRec method to get Account team record for new global Account Manager for insert purpose.
* Wiki Ticket # 58278
* Date 6/May/2020
*/
    public static List<AccountTeamMember> getAccTeamRec(map<Id,Id> accMap, Boolean isInsert){
        if(isInsert != NULL && !isInsert) {
            // searching accMap in Account Team Member (then we even more shrink the map to have only data we need)           
            for(AccountTeamMember accTM : [Select id, teamMemberRole, account.Global_Account_Manager__c from AccountTeamMember where accountId =: accMap.keySet() and userId =: accMap.values() and TeamMemberRole != 'Global Account Manager']){
                // removing account from the map if user already added
                if( accTM.UserId == accMap.get(accTM.AccountId) ){
                    accMap.remove(accTM.AccountId);
                }
            }
        }
        
        List<AccountTeamMember> insertAccMember = new List<AccountTeamMember>();
        
        // loop through through prepared clean accMap
        for (Id atm_AccountId : accMap.keySet()) {
            Id atm_UserId = accMap.get(atm_AccountId);
            AccountTeamMember accTeamMember = new AccountTeamMember();
            accTeamMember.AccountId = atm_AccountId;
            accTeamMember.UserId = atm_UserId;
            accTeamMember.TeamMemberRole = 'Global Account Manager';
            accTeamMember.AccountAccessLevel = 'Read';
            accTeamMember.CaseAccessLevel = 'Read';
            accTeamMember.OpportunityAccessLevel = 'Read';
            insertAccMember.add(accTeamMember);
        }
        return insertAccMember;
    }
    /*getAccTeamForDel method to get Account team record for ex global Account Manager to delete the record.
* Wiki Ticket # 58278
* Date 6/May/2020
*/
    public static List<AccountTeamMember> getAccTeamForDel(map<Id,Id> accMap){
        List<AccountTeamMember> accTeams = new List<AccountTeamMember>();
        if(accMap != NULL){
            accTeams = [Select id from AccountTeamMember where AccountId =:accMap.keySet() and UserId =:accMap.values() and TeamMemberRole = 'Global Account Manager' ];
        }
        return accTeams;
    }
    
    /*isAccFromDiffrenetRegions method to check either the merging account are from same regions or from different regions.
* 
* Date 5/June/2020
*/
    public static Boolean isAccFromDiffrenetRegions(Map<String,Id> accRegionIdMap){
        Boolean isAccFromDiffRegion = False;
        
        for(Account tempAccount : [SELECT Ub_Office__c FROM Account WHERE Id IN : accRegionIdMap.values()]){
            for(String oldAccRegion : accRegionIdMap.keySet()){
                if(oldAccRegion != tempAccount.uB_Office__c){
                    isAccFromDiffRegion = True;
                }
            }
        }
        return isAccFromDiffRegion;
    }
    
    public static List<Account> updateOwnerEmailFields ( Map<Id,Id> accUserIdMap){
        
        map<Id,String> userIdOwnerEmail = new map<Id,String>();
        map<Id,String> userIdChannelManager = new map<Id,String>();
        map<Id,String> userIdDistributor = new map<Id,String>();
        map<Id,String> userIdEmailChannelManager = new map<Id,String>();
        List<Account> accountsToUpdate = new List<Account>();
        
        List<Account> accList = new List<Account>();
        if(!accUserIdMap.isEmpty()){
            
            
            accList = [SELECT Id, OwnerId, Distributor_Name__c, Channel_Manager__c, Email_Channel_Manager__c, Email_Account_Owner__c FROM Account where Id IN :accUserIdMap.keySet()];
            
            system.debug('in method');
            
            for(User userObj : [SELECT Id,Channel_Manager__c,Distributor_Name__c,Email_Channel_Manager__c,Email from user where ID IN :accUserIdMap.values()]){
                userIdOwnerEmail.put(userObj.Id, userObj.Email);
                userIdChannelManager.put(userObj.Id, userObj.Channel_Manager__c);
                userIdDistributor.put(userObj.Id, userObj.Distributor_Name__c);
                userIdEmailChannelManager.put(userObj.Id, userObj.Email_Channel_Manager__c);
            }
        }
        system.debug('userIdOwnerEmail-->>'+userIdOwnerEmail);
        for(Account accTemp : accList){//
            if( userIdOwnerEmail.containsKey(accTemp.OwnerId) ){
                
                accTemp.Distributor_Name__c = userIdDistributor.get(accTemp.OwnerId);
                accTemp.Channel_Manager__c = userIdChannelManager.get(accTemp.OwnerId);
                accTemp.Email_Channel_Manager__c = userIdEmailChannelManager.get(accTemp.OwnerId);
                accTemp.Email_Account_Owner__c = userIdOwnerEmail.get(accTemp.OwnerId);
                accountsToUpdate.add(accTemp);
            }
        }
        return accountsToUpdate;
    }
    
    Public static void updateAccOwnerCountryBase (List<Account> accLst, List<String> countryList,List<String> setStateCode){
        
        map<String,String> countryMap = new Map<String,String>();
        map<String,String> stateCodeMap = new Map<String,String>();
        
        Map<String,String> UbOfficeStateMap=new Map<String,String>();
        Map<String,String> UbOfficeCountryMap=new Map<String,String>();
        
        if(!CountryList.isEmpty() ||  !setStateCode.isEmpty()){
            
            
            for(Country__c tempCont : [SELECT Id,ISO_Code__c,ub_Office__c,OwnerId,state__c,state_Code__c from Country__c where ISO_Code__c IN :CountryList  OR state_Code__c IN :setStateCode]){
                //country can repeat, but code will not repeat, so set as state code
                if(!String.isEmpty(tempCont.state_Code__c)){
                    
                    stateCodeMap.put(tempCont.state_Code__c,tempCont.OwnerId);
                    //Dealing with Ub Office            
                    UbOfficeStateMap.put(tempCont.state_Code__c,tempCont.uB_Office__c);
                }else
                {
                    countryMap.put(tempCont.ISO_Code__c, tempCont.OwnerId);
                    UbOfficeCountryMap.put(tempCont.ISO_Code__c,tempCont.uB_Office__c);
                }
                
            }
        }
        for(Account acc : accLst )
        {
            if( !String.isEmpty( stateCodeMap.get(acc.shippingState )) ){
                
                acc.OwnerId = stateCodeMap.get(acc.shippingState);
            } else if(!String.isEmpty( countryMap.get(acc.ShippingCountry))){
                
                acc.OwnerId = countryMap.get(acc.ShippingCountry);
            }
            if(!String.isEmpty(UbOfficeStateMap.get(acc.ShippingState)) ){
                acc.uB_Office__c=UbOfficeStateMap.get(acc.ShippingState);   
            }else if(!String.isEmpty(UbOfficeCountryMap.get(acc.ShippingCountry))){
                acc.uB_Office__c=UbOfficeCountryMap.get(acc.ShippingCountry);   
            }
            system.debug('acc.OwnerId--->>>'+acc.OwnerId);
            system.debug('acc.uB_Office__c-->>'+acc.uB_Office__c);
        }
    }
    
    public static List<Contact> updateVisitingAddressCheckBox(Set<Id> accIds ){
        List<Contact> accContacts = new List<Contact>();
        if(!accIds.isEmpty()){
            
            
            for(Contact tempCon : [SELECT Visiting_Address_changed__c from Contact where AccountId IN :accIds]){
                tempCon.Visiting_Address_changed__c = true;
                accContacts.add(tempCon);
            }
        }
        return accContacts;
    }
    
    
    public static void checkCompetitor(List<Account> accLst, Set<String> compName,Set<String> compNameSub,Set<String> compNameExt ){
        
        
        List<String> Nam = new List<String>();
        if(!compName.isEmpty() || !compNameSub.isEmpty() || !compNameExt.isEmpty() ){
            for(Competitor__c tempComp : [SELECT Id,Name from Competitor__c where Name = :compName OR Name LIKE :compNameExt OR Name LIKE :compNameSub]){
                Nam.add(tempComp.Name);
            }
            
            String compNameStr = String.valueOf(Nam);
            for(Account tempAcc : accLst){
                
                String accNameSubString = tempAcc.Name.split(' ')[0];
                
                if(compNameStr.containsIgnoreCase(accNameSubString)  ||  compNameStr.containsIgnoreCase(tempAcc.Name)){
                    tempAcc.Potential_Competitor__c = true;
                    system.debug('tempAcc.Potential_Competitor__c00>>'+tempAcc.Potential_Competitor__c);
                }
            }
        }
        
    }
    
    
    public static void preventUpdateAbacusAccount(List<Account> accLst){
        list<User> currentUser=[select isUserSpecial__c, Profile.Name from user where Id=:UserInfo.getUserId()];
        Set<String> setProfile = new Set<String>{'system administrator','automatic process'};
        for(Account acc : accLst )
        {
            Account accOld = (Account) Trigger.oldMap.get(acc.id);
            if(currentUser != null && accOld != null){
                if( !BeforeUpdateAbacusAccount.fromAbacus 
                    && !currentUser[0].isUserSpecial__c 
                    && !setProfile.contains(currentUser[0].profile.Name.toLowerCase()) 
                    && (!String.isBlank(accOld.ShippingStreet) 
                        || !String.isBlank(accOld.ShippingState) 
                        || !String.isBlank(accOld.ShippingCity) 
                        || !String.isBlank(accOld.ShippingPostalCode) 
                        || !String.isBlank(accOld.ShippingCountry))){
                    // address condition can be discussed
                    if(acc.Name!=accOld.Name ){
                        acc.Name.addError(AccountTriggerHandler.errorMessage);
                    }
                    if(acc.Phone!=accOld.Phone ){
                        acc.Phone.addError(AccountTriggerHandler.errorMessage);
                    }
                    if(acc.Fax!=accOld.Fax ){
                        acc.Fax.addError(AccountTriggerHandler.errorMessage);
                    }
                    if(acc.Customer_No__c!=accOld.Customer_No__c ){
                        acc.Customer_No__c.addError(AccountTriggerHandler.errorMessage);
                    }
                }
            }            
        }
    }   
    
}
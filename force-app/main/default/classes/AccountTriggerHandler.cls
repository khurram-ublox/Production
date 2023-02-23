/****
Process 1 : Restrict Profiles to be in contract owner if account owner is changed
Process 2 : Add GAM to Account Teams if it is different than OwnerId, Channel Manager and different ub_office (Ticket #58278 | 6/May/2020)
Process 3 : Can't merge two accounts in different regions
Process 4 : Can't delete record which is linked with Abacus
Process 5 : Reset the visiting address flag for account and related contacts
Process 6 : Update Distributor Name,Channel Manager,Email Channel Manager and Email Account Owner based on Account
owner information.
Process 7 : Can not update Abacus linked accounts
Process 8: update account owner

***/
public Class AccountTriggerHandler implements ITrigger
{
    
    String profileId = userinfo.getProfileId();
    
    // Process 1 Data : map with OwnerId and its related Accounts
    Map<Id,List<Id>> accMapWithOwnerChange = null;
    
    // Process 2 Data : map with Accounts and related Account teams
    Map<Id, Id> accMapGAM = new Map<Id,Id>();
    Map<Id, Id> accMapDelAccTeam = new Map<Id,Id>();
    public static Boolean isInsertContext = null;
    
    // Process 1 Result : All changed contracts for owners with restricted profiles to older ownerId
    List<Contract> restrictedOwnerContracts = null;
    
    // Process 2 Result : Insert Account Teams for new GAMs and delete older account teams for older GAMs
    List<AccountTeamMember> insertAccTeamRec = null;
    List<AccountTeamMember> deleteAccTeamRec = null;
    
    //process 3 Data : getting the wining record ids while merging the accounts
    Map<String,Id> lostAccRegionAndId = new Map<String,Id>();
    Set<Id> lostAccIds = new Set<Id>();
    
    //Process 5
    //Sami-code started date = 30 dec
    Set<Id> accountIds = new Set<Id>();
    List<Contact> accContacts = new List<Contact>();
    
    //Process 6
    map<Id,Id> accIdUserIds = new map<Id,Id>();
    List<Account> accountsToUpdate = new List<Account>();
    //Process 7
    
    public static String errorMessage = 'Account linked to Abacus. Customer No, Phone, Fax, and Credit information are not modifiable.';
    
    
    //Process 8
    List<String> CountryList = new List<String>();
    List<String> setStateCode = new List<String>();
    Map<String,String> mapCountryUbOffice=new Map<String,String>();//key is Country or ISO code and value is UB office       
    integer i=0;
    
    
    //Process 9
    Set<String> compName = new Set<String>();
    Set<String> compNameExt = new Set<String>();
    Set<String> compNameSub = new Set<String>();
    
    public static Boolean isRecursiveTrigger = FALSE;
  public static Boolean isRecursiveTriggerBeforeUpdate = FALSE;
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){
        //Process 3
        List<Account> accLst = (list<Account>)Trigger.New;
        if(Trigger.isInsert){
            //Sami-code started date = 30 dec
            for(Account acc : accLst){
                
                
                
                
                //process 9
                compName.add(acc.Name);
                compNameExt.add(acc.Name+' %');
                String NameSub = acc.Name.split(' ')[0]+' %';
                compNameSub.add( NameSub);
                
                if(String.isNotBlank(acc.ShippingCountry)){
                    CountryList.add(acc.ShippingCountry);
                }
                if(String.isNotBlank(acc.ShippingState)){
                    setStateCode.add(acc.ShippingState);
                }                        
            }
        }else if(Trigger.isUpdate){
            map<Id, Account> oldAccountsMap = (map<Id, Account>)trigger.oldMap;
            for(Account acc : accLst){
                
                //Process 5 Reset flag and add the account id to set
                if (acc.Visiting_Address_changed__c){
                    acc.Visiting_Address_changed__c = false;
                    accountIds.add(acc.Id);
                }
            }
        }
        //Sami-code end date = 30 dec
    }
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){
        accMapWithOwnerChange = new Map<Id,List<Id>>();
        accMapGAM = new Map<Id,Id>();
        accMapDelAccTeam = new Map<Id,Id>();
        List<Account> accLst = (list<Account>)Trigger.New;
        map<Id, Account> oldAccounts = (map<Id, Account>)Trigger.oldMap;
        
        if(!Trigger.isDelete){
            for(Account acc : accLst )
            {
                if(Trigger.isInsert)
                {
                    //Process 6
                    system.debug('acc.Id-->>'+acc.Id);
                    system.debug('acc.ownerId-->>'+acc.ownerId);
                    accIdUserIds.put(acc.Id,acc.ownerId);
                    //Process 2 : Create a map for all the accounts with GAM changed. 
                    isInsertContext = true;
                    Id accGAM = acc.Global_Account_Manager__c;
                    if(accGAM != null && accGAM != acc.OwnerId && accGAM != acc.New_Channel_Manager__c) 
                        accMapGAM.put(acc.Id, acc.Global_Account_Manager__c);
                }
                if(Trigger.isUpdate)
                {
                    
                    //Process 1 : Create a map with OwnerId and its related Accounts
                    if(acc.OwnerId != oldAccounts.get(acc.Id).OwnerId)
                    {
                        accIdUserIds.put(acc.Id,acc.ownerId);
                        if(!accMapWithOwnerChange.containsKey(acc.OwnerId))
                            accMapWithOwnerChange.put(acc.OwnerId,new List<Id>());
                        
                        accMapWithOwnerChange.get(acc.OwnerId).add(acc.Id);               
                    }
                    
                    //Process 2 : Create a map for all the accounts with GAM changed.
                    Id accGAM = acc.Global_Account_Manager__c;
                    if(accGAM != oldAccounts.get(acc.Id).Global_Account_Manager__c ){
                        if(accGAM != null && accGAM != acc.OwnerId && accGAM != acc.New_Channel_Manager__c)
                            accMapGAM.put(acc.Id, accGAM);
                        accMapDelAccTeam.put(acc.Id, oldAccounts.get(acc.Id).Global_Account_Manager__c);
                    }
                    
                }
            }
        } else{
            for(Account acct : oldAccounts.values() )
            {
                if(String.isNotBlank(acct.MasterRecordId)) {
                    lostAccRegionAndId.put(acct.uB_Office__c,acct.MasterRecordId);
                    lostAccIds.add(acct.Id);
                }
            }
        }
    }
    
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){
        
        
        AccountObjectHelper.updateAccOwnerCountryBase(Trigger.New,CountryList,setStateCode );
        AccountObjectHelper.checkCompetitor(Trigger.New,compName,compNameExt,compNameSub );
        
    }
    
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){
        if(!isRecursiveTriggerBeforeUpdate){
      //Process 5
        //   The code is modified by Umar Arshad on 22-12-2021. The try catch block has been removed
        //   as it was throwing null exception, instead an if condition is added.
        
        //   Bellow code is commented by Umer Farooq on 22 Feb, 2022.  
        //   Address update in Contact from Account functionality moved in Flow: "Account: After Created/Updated".   
			/*
            Map<String, featuresSetting__c> featureSettings = featuresSetting__c.getAll();
            if(featureSettings.containsKey('Enable Update')){
              boolean updateContactEnabled = featuresSetting__c.getAll().get('Enable Update').flag__c;
              if(updateContactEnabled){
                  accContacts = AccountObjectHelper.updateVisitingAddressCheckBox(accountIds);
                  
              }
            }
            */
      //Process 7
      AccountObjectHelper.preventUpdateAbacusAccount(Trigger.New);
      isRecursiveTriggerBeforeUpdate = true;
    }
        
    }
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){
        //Process 4
        Boolean allowedToDelete = CommonUtils.isAllowedProfileForDelete( profileId.substring(0,15) );
        List<Account> accLst = Trigger.Old;
        for(Account a : accLst ){
            
            if(a.Customer_No__c!=null && !allowedToDelete){
                a.AddError('Abacus account can\'t be deleted. Please contact Salesforce Admin if necessary.');
            }
        }
    }
    
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
        //Process 2 Logic : calling Helper functions to get desired result.
        insertAccTeamRec=AccountObjectHelper.getAccTeamRec(accMapGAM,isInsertContext);
        accountsToUpdate = AccountObjectHelper.updateOwnerEmailFields(accIdUserIds);
        
        //   AccountObjectHelper.updateOwnerEmailFields(Trigger.New,accIdUserIds);
        
    }
    
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){
        if(!isRecursiveTrigger){
            
            
            // Process 1 Logic 
            restrictedOwnerContracts = AccountObjectHelper.getContractsForOwnerWithRestriction(accMapWithOwnerChange,Trigger.oldMap);
            //Process 2 Logic : calling Helper functions to get desired result.
            insertAccTeamRec=AccountObjectHelper.getAccTeamRec(accMapGAM,isInsertContext);
            deleteAccTeamRec=AccountObjectHelper.getAccTeamForDel(accMapDelAccTeam);
            
            accountsToUpdate = AccountObjectHelper.updateOwnerEmailFields(accIdUserIds);
      isRecursiveTrigger = TRUE;
        }
        
        
    }
    
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){
        // Process 3
        if(lostAccRegionAndId.size()>0) {
            Boolean allowedToDelete = CommonUtils.isAllowedProfileForMerge( profileId.substring(0,15) );
            Boolean AccFromDiffRegion = AccountObjectHelper.isAccFromDiffrenetRegions(lostAccRegionAndId);
            for(sObject accObj : Trigger.old)
            {               
                if(lostAccIds.contains(accObj.Id) && AccFromDiffRegion && !allowedToDelete){
                    accObj.addError('Accounts in different u-blox offices can\'t be merged. Please contact Sales Admin, if necessary.');
                }   
            }          
        }
    } 
    //Finally do operations to Commit 
    public void finish(){
        
        //Process 1 Result Commit
        if(restrictedOwnerContracts!=null && restrictedOwnerContracts.size()>0)
        {
            Database.update(restrictedOwnerContracts);
        }
        //Process 2 Result Commit
        if(insertAccTeamRec!=null && insertAccTeamRec.size()>0)
        {
            Database.insert(insertAccTeamRec);
        }
        //Process 2 Result Commit
        if(deleteAccTeamRec!=null && deleteAccTeamRec.size()>0)
        {
            Database.delete(deleteAccTeamRec);
        }
        update accContacts;
        system.debug('accountsToUpdate-->>>'+accountsToUpdate);
    system.debug('accContacts-->>>'+accContacts);
        update  accountsToUpdate;
        
    }
}
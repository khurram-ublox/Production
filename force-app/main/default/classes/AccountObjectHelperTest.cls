@isTest
public with sharing class AccountObjectHelperTest {
    public AccountObjectHelperTest() {}
    
    private static void init()
    {
        TestUtils.createProcessSettingRecord();  
    }
    
    @isTest
    public static void getContractsForOwnerWithRestrictionTest(){
    
        init();
        
        User u = TestUtils.createUserWithProfile('LName','Partner Base Quotation');
        Account acc = TestUtils.createAccountWithOwner(u.id);
        Contract con = TestUtils.createContractWithOwner(acc.id,UserInfo.getUserId());
        Contract conObj = TestUtils.createContractWithAccount(acc.id,'Draft');
        
        Map<Id,List<Id>> accMapWithOwnerChange = new Map<Id,List<Id>>();
        accMapWithOwnerChange.put(u.id,new List<Id>{acc.id});
               
        acc.OwnerId = UserInfo.getUserId();
        
        Map<ID,sObject> oldAccountMap = new Map<ID,sObject>();
        oldAccountMap.put(acc.Id,acc);
        
        Test.starttest();
        List<Contract> contList = AccountObjectHelper.getContractsForOwnerWithRestriction(accMapWithOwnerChange ,oldAccountMap);
        if(contList.size()>0){
            update contList;            
        }
        Test.stoptest();
            
        
        List<Contract> allContracts = [select id,Name from Contract where OwnerId =: u.id];
        System.assertEquals(allContracts.size(),0);            
    }
    
    @isTest
    public static void accountOwnerChangeForPartnerProfileTest(){
        init();
        
        User u = TestUtils.createUserWithProfile('LName','Partner Base Quotation');
        Account acc = TestUtils.createAccountWithOwner(UserInfo.getUserId());
        Contract con = TestUtils.createContractWithOwner(acc.id,acc.OwnerId);
        
        acc.OwnerId = u.id;        
        update acc;
        
        List<Contract> allContracts = [select id,Name from Contract where OwnerId =: u.id];
        System.assertEquals(allContracts.size(),0); 
        
        delete con;
        delete acc;           
    }
    
    @isTest
    public static void accountwithGAM(){
        User u = TestUtils.createUserWithProfile('LName','Partner Base Quotation');
        Account acc = TestUtils.createAccountWithGAM();
        
        map<Id,Id> accMapwithGAM = new Map<Id,Id>();
        accMapwithGAM.put(acc.Id, acc.Global_Account_Manager__c);
        Test.starttest();
		AccountObjectHelper.getAccTeamRec(accMapwithGAM, false );
        Test.stoptest();
    }
    
     @isTest
    public static void mergeAccount(){
        User u = TestUtils.createUserWithProfile('LName','Partner Base Quotation');
        Account accM = TestUtils.createAccountWithGAM();
        Account accdup = TestUtils.createAccountWithGAM();
        
        
        //accMapwithGAM.put(acc.Id, acc.Global_Account_Manager__c);
        Test.starttest();
        system.debug('accdup-->>'+accdup);
        system.debug('accM-->>'+accM);
         Database.MergeResult results = Database.merge(accM, accdup, false);
        system.debug('results-->>'+ results);
		//AccountObjectHelper.getAccTeamRec(accMapwithGAM, false );
        Test.stoptest();
    }
}
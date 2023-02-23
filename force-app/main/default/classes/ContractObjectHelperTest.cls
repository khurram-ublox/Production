@isTest
public with sharing class ContractObjectHelperTest {
    
    @testSetup static void setup() {
        // Create common test accounts
        List<Account> testAccts = new List<Account>();
        List<Contract> contractList = new List<Contract>();
        
        for(Integer i=0;i<2;i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i));
        }
        insert testAccts;
        for(Integer i=0;i<2;i++) {
         contractList.add(new Contract (Status = 'Draft', accountId = testAccts[0].Id));   
        }
        
        insert contractList;
        
    }
    @isTest
    public static void deleteContract(){
       
        contract contObj = [Select id, status from contract where status = 'Draft' limit 1];
        contObj.Status = 'Activated';
        update contObj;
        Test.starttest();
        contract contObj2 = [Select id, status from contract where id = : contObj.Id limit 1];
        delete contObj2;
        Test.stoptest();
    }
    @isTest
    public static void getContractsForContractCategory(){
        
        List<Contract> contLst = new List<Contract>();
        for(Contract contObj : [Select id, status from Contract where status = 'Draft']){
            contObj.Status = 'Activated';
            contObj.Contract_Category__c = 'NDA';
            contLst.add(contObj);
        }
        update contLst;
        Contract conObj = [Select id, status from contract where id = : contLst[0].id LIMIT 1] ;
        conObj.Status = 'Ended';
        update conObj;
        
        Test.starttest();
        contract contObj2 = [Select id, status from contract where id = : contLst[0].id limit 1];
        contObj2.status = 'Activated';
        update contObj2;
        Test.stoptest();
    }
    
    @isTest
    public static void getContractsPartnerAgreementCategory(){
        
        List<Contract> contLst = new List<Contract>();
        for(Contract contObj : [Select id, status from Contract where status = 'Draft']){
            //Contract tempContr
            integer index=0;
            if(index== 0){
                contObj.Status = 'Activated';
                contObj.Contract_Category__c = 'Solution Partner Program Agreement';
                
            }else if(index== 1){
                contObj.Status = 'Activated';
                contObj.Contract_Category__c = 'Service Referral Commission Agreement';
                
            }else if(index== 2){
                contObj.Status = 'Activated';
                contObj.Contract_Category__c = 'Design Partner Program Agreement';
                
            }
            index++;
            contLst.add(contObj);
        }
        system.debug('contLst--->>'+contLst);
        update contLst;
    }

}
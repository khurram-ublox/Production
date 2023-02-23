/*
 * Title: ContractTriggerTest
 * Description: Test class for ContractTrigger
 * Author:  ldra
 * Created:  2019-11-14
 */

@isTest
public class ContractTriggerTest {

    @isTest 
    static void execute() {

        Account a = new Account(Name='Test Acc',uB_Office__c='Corporate');
        insert a;
        
        List<Contract> contracts = new List<Contract>();
        Contract c1 =new Contract();  
        c1.Name='Contract1 NDA';
        c1.AccountId=a.Id;
        c1.Contract_Category__c='NDA';
        // Activated status is not allowed for import;
        c1.Status = 'Draft';
        contracts.add(c1);
        
        Contract c2 =new Contract();  
        c2.Name='Contract2 NDA';
        c2.AccountId=a.Id;
        c2.Contract_Category__c='NDA';
        // Activated status is not allowed for import;
        c2.Status = 'Draft';
        contracts.add(c2);
        
        insert contracts;
        
        Contract c = [SELECT Id FROM Contract WHERE AccountId = :a.Id and Name='Contract1 NDA'];
		c.Status = 'Activated'; 
        update c;
        
        a = [SELECT Id, NDA_Available__c FROM Account WHERE Id = :a.Id];
        System.assertEquals(true, a.NDA_Available__c);

        delete c;
        
        a = [SELECT Id, NDA_Available__c FROM Account WHERE Id = :a.Id];
        System.assertEquals(false, a.NDA_Available__c);  

    }

    
}
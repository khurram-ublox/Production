/*
 * Title: ContractTriggerHandler
 * Description: Class that updates Account, field NDA_Available__c 
 * Author:  ldra
 * Created:  2019-11-14
 */

public class ContractTriggerHandler {
    
    // After insert update Account field: NDA_Available__c 
    public static void contractOnInsert(List<Contract> contracts) {
        Set<id> listToUpdate = new Set<id>();

        for (Contract c : contracts){
            if(c.Status == 'Activated' && c.IsDeleted == false && c.Contract_Category__c == 'NDA') {
                listToUpdate.add(c.AccountId);
            }
        }
		
        if(!listToUpdate.isEmpty()) {
            List<Account> accToUpdate = new List<Account>();  
            for(Account a : [select Id from Account where Id in :listToUpdate and NDA_Available__c = false]) {
                System.debug('To be checked: '+ a.Id);
                a.NDA_Available__c = true;
                accToUpdate.add(a);
            }
            if(!accToUpdate.isEmpty()) update accToUpdate; 
        }
    }
    
    // after update check whether Account contains any NDA contract and if not, uncheck NDA_Available__c 
    public static void contractOnUpdate(List<Contract> contracts, Map<Id, Contract> contractsOld) {
        
        Set<id> listToCheck = new Set<id>();
        Set<id> listToUncheck = new Set<id>();
        
        for (Contract n : contracts){
            Contract o = contractsOld.get(n.Id);

            if(n.Status != o.Status || n.Contract_Category__c != o.Contract_Category__c) {
                if(o.Status == 'Activated' && o.Contract_Category__c == 'NDA') {
                    if(!listToCheck.contains(n.AccountId)) listToUncheck.add(n.AccountId);
                }
                if(n.Status == 'Activated' && n.Contract_Category__c == 'NDA') {
                    listToCheck.add(n.AccountId);
                }
            }
        }

        if(!listToUncheck.isEmpty()) {
            // check if there is another contract that is checked, then remove account from the list
            for(Contract c : [select Id, AccountId from Contract where AccountId in :listToUncheck and IsDeleted = false and Status = 'Activated' and Contract_Category__c = 'NDA']) {
                listToUncheck.remove(c.AccountId);
            }
        }
        
        if(!listToCheck.isEmpty() || !listToUncheck.isEmpty() ) {
            List<Account> accToUpdate = new List<Account>();  
            for(Account a : [select Id, NDA_Available__c from Account where Id in :listToUncheck or Id in :listToCheck]) {
                //System.debug('To be checked: '+ a.Id);
                if(a.NDA_Available__c == true && listToUncheck.contains(a.Id)) a.NDA_Available__c = false;
                if(a.NDA_Available__c == false && listToCheck.contains(a.Id)) a.NDA_Available__c = true;
                accToUpdate.add(a);
            }
            if(!accToUpdate.isEmpty()) update accToUpdate;
        }
    }
    
    // after delete check whether Account contains any NDA contract and if not, uncheck NDA_Available__c 
    public static void contractOnDelete(List<Contract> contracts) {
        
        Set<id> listToUpdate = new Set<id>();
        for (Contract c : contracts){
            if(c.Status == 'Activated' && c.Contract_Category__c == 'NDA') {
                listToUpdate.add(c.AccountId);
            }
        }
 
        if(!listToUpdate.isEmpty()) {
            for(Contract c : [select Id, AccountId from Contract where AccountId in :listToUpdate and IsDeleted = false and Status = 'Activated' and Contract_Category__c = 'NDA']) {
                listToUpdate.remove(c.AccountId);
            }

            List<Account> accToUpdate = new List<Account>();  
            for(Account a : [select Id from Account where Id in :listToUpdate and NDA_Available__c = true]) {
                System.debug('To be checked: '+ a.Id);
                a.NDA_Available__c = false;
                accToUpdate.add(a);
            }
            if(!accToUpdate.isEmpty()) update accToUpdate;
        }
    }
    
}
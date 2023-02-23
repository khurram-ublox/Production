/*******************************************************************************************************
* Class Name  ContractObjectHelper
* Description  Helper class for Contract Trigger to check wheter the related accounts needs to be updated.
* Created Date 5/19/2020
* Last Modified by: KSHA on 24/11/2021
* Change History
*/
Public Class ContractObjectHelper{
    
    private static set<string> AGREEMENTS = new set<string>{
        'Design Partner Program Agreement',
        'Solution Partner Program Agreement',
        'Service Referral Commission Agreement'
    };
    private static map<string, string> AGREEMENT_FIELDS_REFERENCES = new map<string,string>{
        'Design Partner Program Agreement' => 'Design_Partner_Agreement__c',
        'Solution Partner Program Agreement' => 'Solution_Partner_Agreement__c',
        'Service Referral Commission Agreement' => 'Referral_Agreement__c'
    };
    private static map<string, Boolean> STATUS_TOGGLE = new map<string, Boolean>{
        'Activated' => true,
        'Ended' => false
    };

    /* This method is invoked from flow name : Contract: After Created/Updated
    *  This is updating following fields in related Account object of Contract as true/false based on the Contract Status
    *  Design_Partner_Agreement__c, Solution_Partner_Agreement__c and Referral_Agreement__c   
    */     
        
    @InvocableMethod(Label = 'Invoked from Flow Contract:After Created/Updated')
    public static void updateAccounts(List<Contract> contractRecords){        
        map<Id,Account> accToUpdate = new map<Id,Account>();
        set<Id> accountIds = new set<Id>();
        map<Id, string> contractCategories = new map<Id, string>();
        Account acc = new Account();    
        
        for(Contract record : contractRecords){
            accountIds.add(record.AccountId);
            contractCategories.put(record.Id, record.Contract_Category__c);                             
        }
        
        map<Id, Account> accountsMap = new map<Id, Account>([SELECT 
                                Id,
                                Design_Partner_Agreement__c,
                                Referral_Agreement__c,
                                Solution_Partner_Agreement__c, 
                                (SELECT Id,AccountId,Contract_Category__c FROM Contracts 
                                where Contract_Category__c IN:contractCategories.values()
                                AND Id NOT IN:contractCategories.keySet() AND Status = 'Activated')
                                FROM Account WHERE Id IN :accountIds]);       
            
        for(Contract con : contractRecords){
            acc = accountsMap.get(con.AccountId);
            acc.put(AGREEMENT_FIELDS_REFERENCES.get(con.Contract_Category__c),STATUS_TOGGLE.get(con.Status));                                       
            accToUpdate.put(acc.Id,acc);
            
            //don't set the Account field as false if multiple contract are already exists for same category and are active
            for(Contract existingRec : acc.Contracts){
                acc.put(AGREEMENT_FIELDS_REFERENCES.get(existingRec.Contract_Category__c),true);
                accToUpdate.put(acc.Id, acc);
            }
        }
        update accToUpdate.values();
    }
    
    /*******************************************************************************************************
* @description CChecking the Accounts if they needs to be updated
* @param 1 Map of Account Ids and Contract Ids to update contract available field to true
* @param 2 Map of Account Ids and Contract Ids to update contract available field to false
* @param 3 Map of Account Ids and Contract Ids to update NDA available field to true
* @param 4 Map of Account Ids and Contract Ids to update NDA available field to false
* @return returning accounts with updated Contract Available or NDA Available field
* @created date 5/20/2020
* @change history
*/
    public static List<Account> getAccContractNDAUpdate(Map<Id,Id> accContractAvaiCheckMap, Map<Id,Id> accContractAvaiUncheckMap,Map<Id,Id> accContractNDACheckMap, Map<Id,Id> accContractNDAUncheckMap){
        List<Account> accNDAContList = new List<Account>();
        if(!accContractAvaiUncheckMap.isEmpty() || !accContractNDAUncheckMap.isEmpty()){
            for(Contract tempCont : [SELECT Id,Status,Contract_Category__c,AccountId from Contract WHERE ( ( AccountId IN :accContractAvaiUncheckMap.keySet() AND Id NOT IN :accContractAvaiUncheckMap.values() )OR ( AccountId IN :accContractNDAUncheckMap.keySet() AND Id NOT IN :accContractNDAUncheckMap.values() ) )]){
                if(tempCont.Status == CommonUtils.ACTIVATED ){
                    accContractAvaiUncheckMap.remove(tempCont.AccountId);
                    if(tempCont.Contract_Category__c == CommonUtils.NDA_CATEGORY){
                        accContractNDAUncheckMap.remove(tempCont.AccountId);
                    }
                }
            }
        }
        for(Account tempAcc : [SELECT Id,Contract_Available__c, NDA_Available__c FROM Account WHERE Id IN :accContractAvaiCheckMap.keySet() OR Id IN :accContractAvaiUncheckMap.keySet() OR Id IN :accContractNDACheckMap.keySet() OR Id IN :accContractNDAUncheckMap.keySet()]){
            if(!accContractAvaiCheckMap.isEmpty() && accContractAvaiCheckMap.containsKey(tempAcc.Id) && tempAcc.Contract_Available__c == false){
                tempAcc.Contract_Available__c = true;
            }
            if(!accContractNDACheckMap.isEmpty() && accContractNDACheckMap.containsKey(tempAcc.Id) && tempAcc.NDA_Available__c == false){
                tempAcc.NDA_Available__c = true;
            }
            if(!accContractAvaiUncheckMap.isEmpty() && accContractAvaiUncheckMap.containsKey(tempAcc.Id)  && tempAcc.Contract_Available__c == true){
                tempAcc.Contract_Available__c = false;
            }
            if(!accContractNDAUncheckMap.isEmpty() && accContractNDAUncheckMap.containsKey(tempAcc.Id) && tempAcc.NDA_Available__c == true){
                tempAcc.NDA_Available__c = false;
            }
            accNDAContList.add(tempAcc);
            
        }
        return accNDAContList;
    }
    
    
    
}
/*
    Change Request: CR-0122
    Completed By: Gary J Burgin
    Date: 23/06/2011
*/

trigger updateRMAandCaseDistributorName on Account (before update) {
    
    Map<Id,User> users = new Map<Id,User>([select Id, Email, Distributor_Name__c from User]);
    Map<Id,Account> accountsWithNewOwner = new Map<Id,Account>();
    
    for(Account newAccount : trigger.new){
        Account oldAccount = trigger.oldMap.get(newAccount.Id);
        
        //If Owner changed
        if(newAccount.OwnerId != oldAccount.OwnerId){
            accountsWithNewOwner.put(newAccount.Id, newAccount);
        }
    }
    
    if(accountsWithNewOwner.size() > 0){
        
        List<RMA__c> RMAs = [select Id, OwnerId, Distributor_Name__c, Email_Account_Owner__c, Account_Name__r.Id From RMA__c where Account_Name__r.Id in :accountsWithNewOwner.keyset() ];
        List<Case> Cases = [select Id, OwnerId, Distributor_Name__c, Email_Account_Owner__c, AccountId From Case where AccountId in :accountsWithNewOwner.keyset() ];
        List<Design_Review__c> Drs = [select Id, OwnerId, Distributor_Name__c, Email_Account_Owner__c, Account_Name__r.Id From Design_Review__c where Account_Name__r.Id in :accountsWithNewOwner.keyset() ];
        
        for(Account acc : accountsWithNewOwner.values()){
            for(RMA__c rma : RMAs){
                if(acc.Id == rma.Account_Name__r.Id && users.containsKey(acc.OwnerId)){
                    rma.Distributor_Name__c = users.get(acc.OwnerId).Distributor_Name__c;
                    rma.Email_Account_Owner__c = users.get(acc.OwnerId).Email;
                }
            }
            
            for(Case c : Cases){
                if(acc.Id == c.AccountId && users.containsKey(acc.OwnerId)){
                    c.Distributor_Name__c = users.get(acc.OwnerId).Distributor_Name__c;
                    c.Email_Account_Owner__c = users.get(acc.OwnerId).Email;
                }
            }
            
            for(Design_Review__c dr : Drs){
                if(acc.Id == dr.Account_Name__r.Id && users.containsKey(acc.OwnerId)){
                    dr.Distributor_Name__c = users.get(acc.OwnerId).Distributor_Name__c;
                    dr.Email_Account_Owner__c = users.get(acc.OwnerId).Email;
                }
            }
        }
        
        if(RMAs.size() > 0){
            update RMAs;
        }
        if(Cases.size() > 0){
            update Cases;
        }
        if(Drs.size() > 0){
            update Drs;
        }
        
    }

}
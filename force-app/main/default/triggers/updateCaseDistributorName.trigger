/*
    Change Request: CR-0122
    Completed By: Gary J Burgin
    Date: 23/06/2011
*/

trigger updateCaseDistributorName on Case (before insert, before update) {
    
    Map<Id,User> users = new Map<Id,User>([select Id, Email, Distributor_Name__c from User]);
    
    for(Case c : trigger.new){
        Case oldC;
        
        if(trigger.isUpdate) oldC = trigger.oldMap.get(c.Id);
        //If Owner changed
        if(oldC == null || c.Account.OwnerId != oldC.Account.OwnerId){
            if(users.containsKey(c.Account.OwnerId)){
                c.Distributor_Name__c = users.get(c.Account.OwnerId).Distributor_Name__c;
                c.Email_Account_Owner__c = users.get(c.Account.OwnerId).Email;
            }
        }
    }

}
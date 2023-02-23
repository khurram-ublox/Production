/*
    Change Request: CR-0122
    Completed By: Gary J Burgin
    Date: 23/06/2011
*/

trigger updateRMADistributorName on RMA__c (before insert, before update) {

    Map<Id,User> users = new Map<Id,User>([select Id, Email, Distributor_Name__c from User]);
    
    for(RMA__c rma : trigger.new){
        RMA__c oldRma;
        if(trigger.isUpdate) oldRma = trigger.oldMap.get(rma.Id);
        //If Owner changed
        if(oldRma == null || rma.Account_Name__r.OwnerId != oldRma.Account_Name__r.OwnerId){
            if(users.containsKey(rma.Account_Name__r.OwnerId)){
                rma.Distributor_Name__c = users.get(rma.Account_Name__r.OwnerId).Distributor_Name__c;
                rma.Email_Account_Owner__c = users.get(rma.Account_Name__r.OwnerId).Email;
            }
            system.debug('#rma.Distributor_Name__c:' +rma.Distributor_Name__c);
            system.debug('#users.get(rma.OwnerId):' +users.get(rma.Account_Name__r.OwnerId));
        }
    }
    
}
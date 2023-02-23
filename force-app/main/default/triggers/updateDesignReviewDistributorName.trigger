/*
    Change Request: CR-0122 additional item
    Completed By: Gary J Burgin
    Date: 11/07/2011
*/

trigger updateDesignReviewDistributorName on Design_Review__c (before insert, before update) {

    Map<Id,User> users = new Map<Id,User>([select Id, Email, Distributor_Name__c from User]);
    
    for(Design_Review__c dr : trigger.new){
        Design_Review__c oldDr;
        if(trigger.isUpdate) oldDr = trigger.oldMap.get(dr.Id);
        //If Owner changed
        if(oldDr == null || dr.Account_Name__r.OwnerId != oldDr.Account_Name__r.OwnerId){
            if(users.containsKey(dr.Account_Name__r.OwnerId)){
                dr.Distributor_Name__c = users.get(dr.Account_Name__r.OwnerId).Distributor_Name__c;
                dr.Email_Account_Owner__c = users.get(dr.Account_Name__r.OwnerId).Email;
            }
            system.debug('#dr.Distributor_Name__c:' +dr.Distributor_Name__c);
            system.debug('#users.get(dr.OwnerId):' +users.get(dr.Account_Owner__c));
        }
    }
    
}
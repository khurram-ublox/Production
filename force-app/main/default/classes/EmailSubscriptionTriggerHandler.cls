/*
* Title: EmailSubscriptionTriggerHandler
* Description: Class that updates 
*/

public without sharing class EmailSubscriptionTriggerHandler implements ITrigger {
    
    //process 1
    
    map<String,CAU_Email_Subscription__c> EmailEmailSubcriptionMap = new Map<String,CAU_Email_Subscription__c>();
    List<Contact> contList = new List<contact>();
    
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){
        //Process 1
    }
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){
        List<CAU_Email_Subscription__c> EmailSubscriptionList = (list<CAU_Email_Subscription__c>)Trigger.New;
        //Process 1
        if(Trigger.isInsert || Trigger.isUpdate){
            for(CAU_Email_Subscription__c tempEmailSubscription: EmailSubscriptionList){
                if(Trigger.isUpdate){
                   CAU_Email_Subscription__c EmailSubscriptionOld = (CAU_Email_Subscription__c)Trigger.oldMap.get(tempEmailSubscription.Id);
                   
                    if(EmailSubscriptionOld.Email__c != tempEmailSubscription.Email__c 
                        || EmailSubscriptionOld.Customer_email__c != tempEmailSubscription.Customer_email__c
                        || EmailSubscriptionOld.Webinar_email__c != tempEmailSubscription.Webinar_email__c 
                        || EmailSubscriptionOld.Event_email__c != tempEmailSubscription.Event_email__c
                        || EmailSubscriptionOld.Email_Blog__c != tempEmailSubscription.Email_Blog__c 
                        || EmailSubscriptionOld.Email_uCenter__c != tempEmailSubscription.Email_uCenter__c
                        || EmailSubscriptionOld.Email_Magazine__c != tempEmailSubscription.Email_Magazine__c 
                        || EmailSubscriptionOld.Email_Event_Attendance__c != tempEmailSubscription.Email_Event_Attendance__c){
                          
                        EmailEmailSubcriptionMap.put(tempEmailSubscription.Email__c,tempEmailSubscription);
                    }
                }else{
                    EmailEmailSubcriptionMap.put(tempEmailSubscription.Email__c,tempEmailSubscription);
                }
            }
        }
    }
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){
    }
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){
    }
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){
    }
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
        //Process 1 Logic : calling Helper to
        contList = EmailSubscriptionObjectHelper.updateContactSubscriptions(EmailEmailSubcriptionMap);
    }
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){
        contList = EmailSubscriptionObjectHelper.updateContactSubscriptions(EmailEmailSubcriptionMap);
    }
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){
        //Process 2 Logic : calling Helper to get opps having Has_PDF_Attachments__c as false
    } 
    //Finally do operations to Commit 
    public void finish(){
        //Process 1 Result Commit
        update contList;
    }
}
/****
Process 1 : Update duplicate contact's (find contact based on same email) subscription related fields
Process 2 : sends email to to contact owners if phone, email , name changes
Process 1 : Assign the contact to same user as per the accounts owner

***/

public without sharing class ContactTriggerHandler implements ITrigger {       
    list<Contact> contactsToUpdate = new list<Contact>();       
    set<Id> contAccIds = new Set<Id>();
    
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){        
        list<Contact> contLst = (list<Contact>)trigger.new;
        if(trigger.isInsert){
            for(Contact contObj : contLst){                
                if(contObj.accountId != NULL){
                    contAccIds.add(contObj.AccountId);
                }            
            }
        }
    }
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){}
    
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){
        ContactObjectTriggerHandler.updateContactOwner(trigger.new, contAccIds);
    }
    
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){}
    
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){}
    
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){
        list<Contact> contLst = (list<Contact>)trigger.new;
        map<Id, Contact> oldContacts = (map<Id, Contact>)trigger.oldMap;
        map<string, Contact> contactsMap = new map<string, Contact>();
        map<Id,Id> contIdOwnerId = new map<Id,Id>();
        set<string> emailSet = new set<string>();
        set<Id> idSet = new set<Id>();        
        
        //update subscription 
        for(Contact conObj : contLst){
            Contact oldCont = oldContacts.get(conObj.Id);                          
            
            if(conObj.Email != NULL && userinfo.getUserId() == '0052p00000AIuagAAD' //API Marketing Automation 
               && (conObj.HasOptedOutOfEmail != oldCont.HasOptedOutOfEmail 
                   || conObj.Email_address_probably_not_valid__c != oldCont.Email_address_probably_not_valid__c 
                   || conObj.Marketing_Communication_Opt_Out__c != oldCont.Marketing_Communication_Opt_Out__c)){
                       
                       contactsMap.put(conObj.Email, conObj);
                       emailSet.add(conObj.Email);
                       idSet.add(conObj.Id);
                   }
            
            //Sends Email
            if(conObj.LastModifiedById == '00557000006eQYEAA2' // u-blox
               && (conObj.Phone != oldCont.Phone 
                   || conObj.Email != oldCont.Email 
                   || conObj.FirstName != oldCont.FirstName 
                   || conObj.LastName != oldCont.LastName)){
                       contIdOwnerId.put(conObj.Id, conObj.OwnerId);
                   }            
        } 
        contactsToUpdate = ContactObjectTriggerHandler.updateSubscription(contactsMap,emailSet,idSet);
        ContactObjectTriggerHandler.sendEmail(Trigger.New, contIdOwnerId);        
    } 
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){}
    
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){} 
    
    //Finally do operations to Commit 
    public void finish(){
        //update ContactsToUpdate;
        Database.SaveResult[] contactsList = Database.update(ContactsToUpdate, false);
        for (Database.SaveResult sr : contactsList) {
            if (!sr.isSuccess()) {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    
                    for(sObject ContactObj : Trigger.old)
                    {
                        ContactObj.addError('An error has occurred. '+ err.getMessage());
                    }
                }
            }
            
        }
    }
}
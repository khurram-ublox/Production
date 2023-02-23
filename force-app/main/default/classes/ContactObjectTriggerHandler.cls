public class ContactObjectTriggerHandler {
    
    public static list<Contact> updateSubscription(map<String,Contact> contactsMap, set<String> emailSet, set<Id> contIdSet){
        //updateSubscription data
        list<Contact> contactsToUpdate = new list<Contact>();


        Id recTypeId = Schema.sObjectType.Contact.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        
        if(!EmailSet.isEmpty() && !contactsMap.isEmpty() && contactsMap.size()>0){      
            for(Contact duplicate : [SELECT Id,Email,HasOptedOutOfEmail,Marketing_Communication_Opt_Out__c, 
                                     Email_address_probably_not_valid__c FROM Contact WHERE RecordTypeId=:recTypeId 
                                     AND Email IN: emailSet AND Id NOT IN: contIdSet AND Email != NULL FOR UPDATE ]){  
                
               if(contactsMap.get(duplicate.Email)!= NULL){
                                             
                    contactsToUpdate.add(New Contact(
                    Id = duplicate.Id,
                    Marketing_Communication_Opt_Out__c = contactsMap.get(duplicate.Email).Marketing_Communication_Opt_Out__c,
                    HasOptedOutOfEmail = contactsMap.get(duplicate.Email).HasOptedOutOfEmail,
                    Email_address_probably_not_valid__c = contactsMap.get(duplicate.Email).Email_address_probably_not_valid__c
                ));
              }
            }
        }
        return contactsToUpdate;
    }
    
    public static void sendEmail(List<Contact> contacts, Map<Id,Id> mapOwnerEmail){
        
        if(contacts.size()<4) {
            map<Id, Contact> oldContacts = (map<Id, Contact>)trigger.oldMap;
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
                        
            if(mapOwnerEmail.size()>0) {                
                Map<ID,User> mapUsers = new Map<ID,User>([SELECT Email FROM User WHERE Id IN :mapOwnerEmail.values()]);
                
                // Then send emails to owners in the case any change
                for(Contact n : contacts){
                    Contact o =  oldContacts.get(n.Id);
                    String name = n.FirstName+' '+n.LastName;
                    String to = mapUsers.get(mapOwnerEmail.get(n.Id)).Email;
                    String subject = 'Contact ('+name+') has been changed'; 
                    String body = 'The following contact has been changed in Salesforce as the contact updated his details through a webform on u-blox website. Please check.\n\nName: '+name+'\nId: '+n.Id+'\nUrl: '+baseUrl+'/'+n.Id+'\n'; 
                    
                    if(n.FirstName != o.FirstName) body += '\nFirstName: '+o.FirstName+' > '+n.FirstName;
                    if(n.LastName != o.LastName) body += '\nLastName: '+o.LastName+' > '+n.LastName;
                    if(n.Phone != o.Phone) body += '\nPhone: '+o.Phone+' > '+n.Phone;
                    if(n.Email != o.Email) body += '\nEmail: '+o.Email+' > '+n.Email;
                    
                    // don't send if contact owner is Api User (mainly Registered community contacts)
                    if(to!='' && !to.contains(n.LastModifiedById)) SendEmail.toEmail(to, subject, body);
                }
            }
        }
    }
    
    
    //update contact owner same as Account Owner
    public static void updateContactOwner(list<Contact> contLst, set<Id> accountIds){        
        map<Id,Id> accIdOwnerId = new map<Id,Id>();       
        if(!accountIds.isEmpty()){            
            for(Account tempAcc : [SELECT Id, OwnerId from Account where Id IN : accountIds AND Owner.isActive = true]){
                accIdOwnerId.put(tempAcc.Id, tempAcc.ownerId);
            }
            
            for(Contact tempCont : contLst){
                if(accIdOwnerId.containsKey(tempCont.AccountId)){
                    tempCont.OwnerId = accIdOwnerId.get(tempCont.AccountId);
                }
            }
        }       
    } 
}
public class EmailSubscriptionObjectHelper {
    
    //setting the contact subscriptions same as email subscription
    public static List<contact> updateContactSubscriptions( map<String,CAU_Email_Subscription__c> EmailEmailSubcriptionMap ){
        List<contact> contactsToUpdate = new List<Contact>();
        
        if(EmailEmailSubcriptionMap.size() > 0){
            
            Map<String, List<Contact>> EmailcontactMap = new Map<String, List<Contact>>();
            for(Contact tempCont : [SELECT Id ,Email,event_Email__c, HasOptedOutOfEmail FROM Contact WHERE Email = : EmailEmailSubcriptionMap.keySet()]){
                
                if(EmailcontactMap.get(tempCont.email) == null){
                    EmailcontactMap.put(tempCont.email,new list<Contact>{});
                    EmailcontactMap.get(tempCont.email).add(tempCont);
                }else EmailcontactMap.get(tempCont.email).add(tempCont);
                
            }
            
            for(String subscriptionEmailTemp : EmailEmailSubcriptionMap.keySet()){
                
                for(Contact tempContact  : EmailcontactMap.get(subscriptionEmailTemp)){
                    
                    if(EmailEmailSubcriptionMap.get(subscriptionEmailTemp).Customer_email__c 
                        || EmailEmailSubcriptionMap.get(subscriptionEmailTemp).Webinar_email__c
                        || EmailEmailSubcriptionMap.get(subscriptionEmailTemp).Email_uCenter__c 
                        || EmailEmailSubcriptionMap.get(subscriptionEmailTemp).Email_Blog__c
                        || EmailEmailSubcriptionMap.get(subscriptionEmailTemp).Email_Magazine__c 
                        || EmailEmailSubcriptionMap.get(subscriptionEmailTemp).Event_email__c
                        || EmailEmailSubcriptionMap.get(subscriptionEmailTemp).Email_Event_Attendance__c){
                           
                           tempContact.HasOptedOutOfEmail = false;                           
                    }
                    tempContact.Service_Item_3__c =  EmailEmailSubcriptionMap.get(subscriptionEmailTemp).Customer_email__c ;
                    tempContact.Webinar_email__c =  EmailEmailSubcriptionMap.get(subscriptionEmailTemp).Webinar_email__c ;
                    tempContact.Event_email__c =  EmailEmailSubcriptionMap.get(subscriptionEmailTemp).Event_email__c ;
                    tempContact.Email_uCenter__c =  EmailEmailSubcriptionMap.get(subscriptionEmailTemp).Email_uCenter__c ;
                    tempContact.Email_Blog__c =  EmailEmailSubcriptionMap.get(subscriptionEmailTemp).Email_Blog__c ;
                    tempContact.Email_Event_Attendance__c =  EmailEmailSubcriptionMap.get(subscriptionEmailTemp).Email_Event_Attendance__c ;
                    tempContact.Email_Magazine__c =  EmailEmailSubcriptionMap.get(subscriptionEmailTemp).Email_Magazine__c ;
                    
                    contactsToUpdate.add(tempContact);
                }
            }
        }
        return contactsToUpdate;
    }
}
public class EmailSubscription{ 
    
    public static void updateContactSubscriptions(List<CAU_Email_Subscription__c> subscriptions)
    {

        for (CAU_Email_Subscription__c s : subscriptions)
        {
            System.debug(s);
                List<Contact> listToUpdate = new List<Contact>();
            
                for(Contact c : [select Id, Email, HasOptedOutOfEmail From Contact where Email =: s.Email__c]) {
    
                    if(
                        s.Customer_email__c==true || 
                        s.Webinar_email__c==true || 
                        s.Event_email__c==true || 
                        s.Email_uCenter__c==true || 
                        s.Email_Blog__c==true || 
                        s.Email_Event_Attendance__c==true || 
                        s.Email_Magazine__c==true
                    ) {
                        c.HasOptedOutOfEmail = false; 
                    }
                    
                    c.Service_Item_3__c = s.Customer_email__c;
                    c.Webinar_email__c = s.Webinar_email__c;
                    c.Event_email__c = s.Event_email__c;
                    c.Email_uCenter__c = s.Email_uCenter__c;
                    c.Email_Blog__c = s.Email_Blog__c;
                    c.Email_Event_Attendance__c = s.Email_Event_Attendance__c;
                    c.Email_Magazine__c = s.Email_Magazine__c;
                    
                    listToUpdate.add(c);
               }
               if(!listToUpdate.isEmpty()) update listToUpdate;
        }
    }
    
    public static void removeSubscriptions(List<CAU_Email_Subscription__c> subscriptions)
    {
               if(!subscriptions.isEmpty()) delete subscriptions;
    }
}
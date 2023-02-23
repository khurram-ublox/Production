/*
 * Title: Subscription Unregistered
 * Author:  wsha, ldra
 * Created:  2018-10
 * 
 * Class for "Subscription Unregistered" page in the Community portal. It redirects registered user to the login page. If contact exists in SF it shows unsubscription form.
 * After updating subscription options script stores data in CAU_Email_Subscription__c. Then trigger (EmailSubscription) updates fields in Contact object instantly.
 */

public with sharing class SubscriptionManagementUnregistered {
    
    @AuraEnabled
    public static Contact getContactSubscriptions(String email, String last, String id){
        Contact c = new Contact();
        if(UserInfo.getUserType() == 'Guest') {
            // check if user exists
            // User[] u = [SELECT Id, ContactId, Email FROM User WHERE Email =: email AND FirstName =: first AND LastName =: last LIMIT 1];
            //
            User[] u = [SELECT Id, ContactId, Email FROM User WHERE Email =: email AND IsActive = true AND Profile.Name != 'Community Registered User' LIMIT 1];
            if(u.size()==0) {
                // check if contact exists
                Map<String, Object> params = new Map<String, Object>();
                params.put('contactEmail', email);
                params.put('contactLast', last);
                params.put('contactId', id);
                Flow.Interview.Read_Contact_Subscriptions ReadContactSubscriptions = new Flow.Interview.Read_Contact_Subscriptions(params);
                ReadContactSubscriptions.start();
                Object flowResult = ReadContactSubscriptions.getVariableValue('getContactSubscriptions');
                c = (Contact)flowResult;
            }
            
        }

        return c;
    }
    
    @AuraEnabled
    public static Boolean setUserSubscriptions(String subscriptions ){
        Boolean isUpdated = false;

        String[] params = new List<String>();
        if(String.isNotBlank(subscriptions)) {
            for(String eachStr : subscriptions.split(',')) {
                params.add(eachStr);
            }
        }
        return isUpdated;
    }


    @AuraEnabled
    public static Boolean setContactSubscriptions(String email, Boolean ServiceItem, Boolean EventEmail, Boolean Webinar, Boolean uCenter, Boolean Blog, Boolean EventAttendance, Boolean Magazine){
        CAU_Email_Subscription__c c = new CAU_Email_Subscription__c();
        c.Name = email;
        c.Email__c = email;
        c.Customer_email__c = ServiceItem;
        c.Event_email__c = EventEmail;
        c.Webinar_email__c = Webinar;
        
        c.Email_uCenter__c = uCenter;
        c.Email_Blog__c = Blog;
        c.Email_Event_Attendance__c = EventAttendance;
        c.Email_Magazine__c = Magazine;
        
        insert c;
        return true;        
    }
    
}
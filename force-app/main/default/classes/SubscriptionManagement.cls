/*
 * Title: Subscription Registered
 * Author:  wsha, ldra
 * Created:  2018-10
 * 
 * Class for "Subscription Registered" page in the Community portal. Available only for registered users. 
 * It shows User subscription. On update it saves preferences using "Update Contact Subscriptions" flow.
 */

public with sharing class SubscriptionManagement {

    @AuraEnabled
    public static String getUserName() {
        return UserInfo.getUserType();
    }


    @AuraEnabled
    public static User getUserSubscriptions(){
        User u = new User();

        if(UserInfo.getUserType() != 'Guest') {
            // get subscription info only for non u-blox employees and if contact exists!
            u = [SELECT Id, ContactId, Email, Contact.HasOptedOutOfEmail, Contact.Service_Item_3__c, Contact.Event_email__c, Contact.Webinar_email__c, 
                 Contact.Email_Blog__c, Contact.Email_Event_Attendance__c, Contact.Email_Magazine__c, Contact.Email_uCenter__c
                FROM User
                WHERE Id=:UserInfo.getUserId() and ContactId != null and (not Email LIKE '%u-blox.com') ];
        }

        return u;
    }


  /*  @AuraEnabled
    public static Contact getUnregisteredUserSubscriptions(String uEmail){
        Contact isFound;
        Map<String, Object> params = new Map<String, Object>();
        params.put('userEmail', uEmail);
        System.debug('params: '+params);
        Flow.Interview.Read_Contact_Subscriptions ReadContactSubscriptions = new Flow.Interview.Read_Contact_Subscriptions(params);
        ReadContactSubscriptions.start();
        Object flowResult = ReadContactSubscriptions.getVariableValue('getContactSubscriptions');
        isFound = (Contact)flowResult;
        System.debug('contact result: '+ isFound);

        return isFound;
    }*/


    @AuraEnabled
    public static Boolean setUserSubscriptions(Map<String, Object> subscriptions ){
        Boolean isUpdated = false;

        User u = [SELECT Id, Contact.Id FROM User WHERE Id=:UserInfo.getUserId()];
        if(u.Contact.Id == null) return isUpdated;
        
        Contact c = [SELECT Id, Email FROM Contact WHERE Id=:u.Contact.Id];

        Map<String, Object> params = new Map<String, Object>();
        params.put('SubscribedContact', c);
        for(String k : subscriptions.keySet()){
            params.put(k,subscriptions.get(k));
        }

        Flow.Interview.Update_Contact_Subscriptions UpdateContactSubscriptions = new Flow.Interview.Update_Contact_Subscriptions(params);
        UpdateContactSubscriptions.start();
        Object flowResult = UpdateContactSubscriptions.getVariableValue('isUpdatedSuccessfully');
        System.debug('flow result: '+flowResult);
        isUpdated = (Boolean)flowResult;

        return isUpdated;
    }

 /*   @AuraEnabled
    public static Boolean setUserSubscriptions(Map<String, Object> subscriptions ){
        Boolean isUpdated = false;
        User u = [SELECT Id, ContactId, Email FROM User WHERE Id=:UserInfo.getUserId()];
        System.debug('user: '+u);
        System.debug('u.Email: '+u.Email);

        Contact c = [SELECT Id, Email,Event_email__c, Service_Item_3__c, Webinar_email__c
        FROM Contact
        WHERE Email=:u.Email];
        System.debug('Before contact: '+c);

        Map<String, Object> params = new Map<String, Object>();
        for(String k : subscriptions.keySet()){
            c.put(k, subscriptions.get(k));
        }
        System.debug('After contact: '+c);

        try{
            update c;
        }catch (DmlException ex){
            System.debug('The following error has occurred: '+ex.getMessage());
        }

        return isUpdated;
    }*/

}
/**
 * Created by wsha on 15/10/2018.
 */

public with sharing class ReactivateUser {

    @AuraEnabled
    public static User getDeactivatedUser(String uName){

        User u = [SELECT Id, isActive, Email FROM User WHERE Email=:uName];

        return u;
    }

    @AuraEnabled
    public static Boolean reactivateUser(String uName){

        Boolean isReactivated = false;
        String uId;
        User thisUser = new User();

        List<User> u = [SELECT Id, Email, Deactivation_Request__c, isActive FROM User WHERE Email=:uName AND Deactivation_Request__c=true AND isActive=false LIMIT 1];
        System.debug('User: '+u);
        if(u.size()>0){
            uId = String.valueOf(u[0].Id);
            System.debug(uId);

        }


        Map<String, Object> params = new Map<String, Object>();
        params.put('User', u);
        Flow.Interview.Reactivate_User_Flow reactivateUserFlow = new Flow.Interview.Reactivate_User_Flow(params);
        reactivateUserFlow.start();

        List<User> uu = [SELECT isActive FROM User WHERE Id =: uId LIMIT 1];
        isReactivated = uu[0].isActive;

        System.debug('thisUser: '+thisUser + ' ' + 'uu: ' +uu);
        return isReactivated;

    }

}
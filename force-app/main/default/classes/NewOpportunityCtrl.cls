/*
 * Apex Controller for New Opportunity button in Account object in Lightning
 * Author: ldra
 * Date: 27/09/2019
 * */

public class NewOpportunityCtrl {

     @AuraEnabled
     public static Account getAccount(String recordId){
         if(!string.isEmpty(recordId)){
             Account a = [Select Id, CurrencyIsoCode, OwnerId, OppCloseDate__c,Market_Classification__c, New_Application_Type__c, New_Market__c from Account Where id=:recordId];
             return a;
         }
         return null;
     }

     @AuraEnabled
     public static Id save(Opportunity o){
         // Owner is changed in trigger updateOpportunityOwner
         // o.OwnerId = [Select OwnerId from Account Where id=:o.Opportunity_Account__c].OwnerId;
         o.AccountId = o.Opportunity_Account__c;
         upsert o;
         return o.Id;
     }

}
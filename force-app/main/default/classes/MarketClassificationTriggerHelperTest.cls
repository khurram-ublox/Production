@isTest
public class MarketClassificationTriggerHelperTest {

    @isTest
    public static void marketclassificationDeactivate(){
        market_classification__c marketObj = new Market_classification__c();
        marketObj.isActive__c = true;
        marketObj.Name = 'C-Asset tracking and management';
        marketObj.Description__c = 'Battery-powered tracking devices for trailers, containers, pallets, parcels, luggage, livestock, pets, power tools';
        marketObj.Market__c = 'Consumer';
        marketObj.Market_Segment__c = 'Asset tracking and management';
        insert marketObj;
        
        Account accObj = new Account();
        accObj.Name = 'test Account';
        insert accObj;

        List<market_classification__c> marketClassificationList = new List<market_classification__c>();
        List<Account> accList = new List<Account>();
        marketClassificationList=[SELECT Id, isActive__c from Market_Classification__c ];//where name = 'C-Asset tracking and management' LIMIT 1
        
        accList = [SELECT Id from Account where name = 'test Account'];
        accList[0].Market_Classification__c = marketClassificationList[0].Id;
        update accList;
        marketClassificationList[0].isActive__c = false;
        
        list<Database.SaveResult> results = Database.update(marketClassificationList, false);
       
    }
    @isTest
    public static void marketClassificationDeleteScenario1(){
        
        market_classification__c marketObj = new Market_classification__c();
        marketObj.isActive__c = true;
        marketObj.Name = 'C-Asset tracking and management';
        marketObj.Description__c = 'Battery-powered tracking devices for trailers, containers, pallets, parcels, luggage, livestock, pets, power tools';
        marketObj.Market__c = 'Consumer';
        marketObj.Market_Segment__c = 'Asset tracking and management';
        insert marketObj;
        delete marketObj;
    }
}
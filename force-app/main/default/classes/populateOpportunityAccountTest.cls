@isTest
public with sharing class populateOpportunityAccountTest {
    public populateOpportunityAccountTest() {

    }

    
    public static TestMethod void test()
    {
        Account a = new Account();
        a.Name = 'Test Acc';
        a.New_Application_Type__c = 'Mobile robotics';
        insert a;
        
        RecordType rt = [Select Id, Name From RecordType Where SObjectType = 'Opportunity' and Name = 'Opportunity' Limit 1][0];
        
        Opportunity o = new Opportunity();
        o.RecordTypeId = rt.Id;
        o.Name = 'Test Opp';
        o.StageName = 'Prospecting';
        o.CloseDate = System.Today();
        o.AccountId = a.Id;
        // 2016.04.07 khir: Added Description of new Opportunity creation for update of updateStatusOnOppProduct.apxt
        o.Description='test description';
        
        Test.startTest();
            insert o;
        Test.stopTest();
        
        Opportunity updatedOpp = [Select Id, Name, StageName, New_Application_Type__c, New_Market__c, CloseDate, AccountId, Opportunity_Account__c From Opportunity Where Id = :o.Id Limit 1][0];
        
        System.assertEquals(a.Id, updatedOpp.Opportunity_Account__c);
        
        System.assertEquals(a.New_Application_Type__c, updatedOpp.New_Application_Type__c);
        System.assertEquals(a.New_Market__c, updatedOpp.New_Market__c);
    }
}
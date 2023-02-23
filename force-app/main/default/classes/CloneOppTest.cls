@isTest
public with sharing class CloneOppTest {

    public CloneOppTest() {
        
    }

    @isTest
    static void cloneOpportunityTest(){
        Opportunity opp = new Opportunity();
        Product2 product = new Product2();
        OpportunityContactRole oppContactRole = new OpportunityContactRole();
        Opp_Product__c oppProduct = new Opp_Product__c();
        Partner_Role__c partnerRole = new Partner_Role__c();
        string oppId;
        string productId;

        OpportunityTestDataFactory oppTestFactory = new OpportunityTestDataFactory();
        Product2TestDataFactory productTestFactory = new Product2TestDataFactory();
        PartnerRoleTestDataFactory partnerRoleTestFactory = new PartnerRoleTestDataFactory();
        OppProductTestDataFactory oppProductTestFactory = new OppProductTestDataFactory();
        OpportunityContactRoleTestDataFactory oppContactRoleTestFactory = new OpportunityContactRoleTestDataFactory();

        opp = oppTestFactory.oppForOppProduct();
        product = (Product2)productTestFactory.createRecord();
        oppId = opp.Id;
        productId = product.Id;
        oppContactRole = oppContactRoleTestFactory.createRecord(oppId);
        oppProduct = oppProductTestFactory.createRecord(oppId,productId);
        partnerRole = partnerRoleTestFactory.createRecord(opp);

        string newOppId = CloneOpp.cloneOpportunity(oppId);

    }
}
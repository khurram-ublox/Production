@isTest
public with sharing class PartnerRoleTestDataFactory extends TestDataFactory{


    public PartnerRoleTestDataFactory() {
        super('Partner_Role__c');
    }

    public override sObject initializeRecord(){
        Partner_Role__c PAR = new Partner_Role__c();
        // PAR.Opportunity__c = opp.Id;
        // PAR.Opportunity_Account__c = opp.AccountId;
        // PAR.Partner_Account__c = opp.AccountId;
        PAR.Partner_Role__c = '1 Opportunity owner';
        return PAR;
    }

    public override sObject createRecord() {
        Partner_Role__c o = (Partner_Role__c)initializeRecord();
        Insert o;
        return o;
    }

    public Partner_Role__c createRecord(Opportunity oppObj) {

        Partner_Role__c PAR = new Partner_Role__c();
        PAR.Opportunity__c = oppObj.Id;
        PAR.Opportunity_Account__c = oppObj.AccountId;
        PAR.Partner_Account__c = oppObj.AccountId;
        PAR.Partner_Role__c = '1 Opportunity owner';

        Insert PAR;
        return PAR;
    }

    public sObject updateRecord(Partner_Role__c record) {
        update record;
        return record;
    }

    public override List<sObject> createBulkRecords() {
        for (Integer i = 0; i < numberOfRecords; i++) {
            // Opp_Product__c cont = new Opp_Product__c();
            // cont.Name = 'Test Opportunity'+i;
            // recordsList.add(cont);
        }
        Insert recordsList;
        return recordsList;
    }
}
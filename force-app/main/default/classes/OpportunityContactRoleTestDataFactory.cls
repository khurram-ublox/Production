@isTest
public with sharing class OpportunityContactRoleTestDataFactory extends TestDataFactory{

    Contact contact = new Contact();

    public OpportunityContactRoleTestDataFactory() {
        super('OpportunityContactRole');

        ContactTestDataFactory contactTestFactory = new ContactTestDataFactory();

        this.contact = (Contact)contactTestFactory.createRecord();
    }

    public override sObject initializeRecord(){
        OpportunityContactRole ROL = new OpportunityContactRole();
        ROL.ContactId = contact.Id;
        ROL.IsPrimary = true;
        ROL.Role = 'Contact Technical';
        // ROL.OpportunityId = opp.Id;
        return ROL;
    }

    public override sObject createRecord() {
        OpportunityContactRole o = (OpportunityContactRole)initializeRecord();
        Insert o;
        return o;
    }

    public OpportunityContactRole createRecord(string oppId) {
        OpportunityContactRole ROL = new OpportunityContactRole();
        ROL.ContactId = contact.Id;
        ROL.IsPrimary = true;
        ROL.Role = 'Contact Technical';
        ROL.OpportunityId = oppId;

        insert ROL;
        return ROL;
    }

    public sObject updateRecord(OpportunityContactRole record) {
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
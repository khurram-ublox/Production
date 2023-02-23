@isTest
public with sharing class OppProductTestDataFactory extends TestDataFactory{


    public OppProductTestDataFactory() {
        super('Opp_Product__c');
    }

    public override sObject initializeRecord(){
        Opp_Product__c OPR = new Opp_Product__c();
        // OPR.Opportunity__c = opp.Id;
        // OPR.Product__c = product.Id;
        OPR.Annual_Quantity__c = 500;
        OPR.Unit_Price__c = 30;
        OPR.Use_Restriction__c = '2G Consumer';
        OPR.IPR_Coverage__c = 'Full coverage';
        OPR.Status__c = 'Evaluation';

        return (Opp_Product__c)OPR;
    }

    public override sObject createRecord() {
        Opp_Product__c o = (Opp_Product__c)initializeRecord();
        Insert o;
        return o;
    }



    public Opp_Product__c createRecord(string oppId, string productId) {

        Opp_Product__c OPR = new Opp_Product__c();
        OPR.Opportunity__c = oppId;
        OPR.Product__c = productId;
        OPR.Annual_Quantity__c = 500;
        OPR.Unit_Price__c = 30;
        // OPR.Use_Restriction__c = '4G M2M';
        // OPR.IPR_Coverage__c = 'Premium coverage';
        OPR.Status__c = 'Evaluation';

        Insert OPR;
        return OPR;
    }

    public sObject updateRecord(Opp_Product__c record) {
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
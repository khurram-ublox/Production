@isTest
public class CampaignTestDataFactory extends TestDataFactory {

    public CampaignTestDataFactory() {
        super('campaign');
    }

    public override sObject initializeRecord(){
        Campaign c = new Campaign();
        c.name = 'Test Campaign';
        c.Email_Type__c = 'Customer email';
        c.Type = 'Email';
        return c;
    }

    public override sObject createRecord() {
        Campaign c = (Campaign)initializeRecord();
        insert c;
        return c;
    }

    public override List<sObject> createBulkRecords() {
        for (Integer i = 0; i < numberOfRecords; i++) {
            recordsList.add((Campaign)initializeRecord());
        }
        Insert recordsList;
        return recordsList;
    }

}
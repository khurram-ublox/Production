@isTest
public class CampaignMemberTestDataFactory extends TestDataFactory{

    public CampaignMemberTestDataFactory() {
        super('CampaignMember');
    }

    public override sObject initializeRecord(){
        
        CampaignTestDataFactory cTDF= new CampaignTestDataFactory();
        Campaign camp = (Campaign)cTDF.initializeRecord();
        camp.Email_Type__c = 'Investor relation email';
        insert camp;
        
        CampaignMember c = new CampaignMember();
        c.CampaignId = camp.id;
        c.Status = 'Pending';

        return c;
    }

    public override sObject createRecord() {
        CampaignMember c = (CampaignMember)initializeRecord();
        insert c;
        return c;
    }

    public override List<sObject> createBulkRecords() {
        for (Integer i = 0; i < numberOfRecords; i++) {
            recordsList.add((CampaignMember)initializeRecord());
        }
        Insert recordsList;
        return recordsList;
    }
    
    
}
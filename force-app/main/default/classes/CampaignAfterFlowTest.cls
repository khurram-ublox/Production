@isTest
public class CampaignAfterFlowTest {
    @isTest static void CustomerEmailTest() {

        CampaignTestDataFactory campaignFactory = new CampaignTestDataFactory();
        ContactTestDataFactory contactFactory = new ContactTestDataFactory();
        
        String campaignJSON = '[{"name": "Test Campaign1", "Email_Type__c": "Customer email", "Type": "Email"},{"name": "Test Campaign2", "Email_Type__c": "Marketing Communication", "Type": "Email"}]';
        
        Test.startTest();

        Contact cont = (Contact)contactFactory.createRecord();

        Hard_Code_Ids__c settings = Hard_Code_Ids__c.getOrgDefaults();
        settings.Add_all_global__c = cont.Id;
        upsert settings;
        
        Database.SaveResult[] campaignResultList = campaignFactory.createBulkRecordsfromJson(campaignJSON);
        
        List<Id> campIdsList = campaignFactory.getBulkRecordIds();
        
        List<CampaignMember> campMembList = new List<CampaignMember>([select id, CampaignId, ContactId, Status from CampaignMember where CampaignId IN :campIdsList]);

        System.assertEquals(campMembList.size(), campIdsList.size());
        
        // Customer email? created records
        for (campaign camp : (List<campaign>)campaignFactory.getRecordsList()) {
            for (CampaignMember member : campMembList) {
                if (member.campaignId == camp.id) {                    
                    System.assertEquals(member.status, 'Pending');
                }
            }
        }
        Test.stopTest();
    }

    @isTest static void ProductNotificationTest() {

        CampaignTestDataFactory campaignFactory = new CampaignTestDataFactory();
        ContactTestDataFactory contactFactory = new ContactTestDataFactory();
        String campaignJSON = '[{"name": "Test Campaign1", "Email_Type__c": "Product notification", "Type": "Email"},{"name": "Test Campaign2", "Email_Type__c": "Product notification", "Type": "Email"}]';
        
        Test.startTest();

        List<Contact> contactList = contactFactory.createBulkRecords();
        List<Id> contactIdsList = contactFactory.getBulkRecordIds();
        

        Hard_Code_Ids__c settings = Hard_Code_Ids__c.getOrgDefaults();
        settings.Add_ae_cel__c = contactList[0].Id;
        settings.Add_ae_pos__c = contactList[1].Id;
        settings.Add_ae_sho__c = contactList[2].Id;
        settings.Add_ladm_team_americas__c = contactList[3].Id;
        settings.Add_ms_team_global__c = contactList[4].Id;
        settings.Add_ps_cel__c = contactList[5].Id;
        settings.Add_ps_pos__c = contactList[6].Id;
        settings.Add_ps_sho__c = contactList[7].Id;
        settings.Add_q_team_global__c = contactList[8].Id;
        settings.Add_src_team_global__c = contactList[9].Id;
        upsert settings;
        
        Database.SaveResult[] campaignResultList = campaignFactory.createBulkRecordsfromJson(campaignJSON);
        
        List<Campaign> campList = (List<Campaign>)campaignFactory.getRecordsList();
        List<Id> campIdsList = campaignFactory.getBulkRecordIds();
        
        List<CampaignMember> campMembList = new List<CampaignMember>([select id, CampaignId, ContactId, Status from CampaignMember where CampaignId IN :campIdsList]);

        //every campaign creates 9 members
        System.assertEquals(9, campMembList.size()/campList.size());
        // Product notification created records
        for (campaign camp : campList) {
            for (CampaignMember member : campMembList) {
                if (member.campaignId == camp.id) {                    
                    System.assertEquals(member.status, 'Pending');

                }
            }
        }
        Test.stopTest();
    }

}
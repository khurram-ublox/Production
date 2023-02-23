@isTest
public class ContactEmailAlertFlowTest {
    @isTest static void COPRecordTypeStdConditionTest() {
        Test.startTest();
        ContactTestDataFactory factory = new ContactTestDataFactory();
        Database.SaveResult[] output = factory.AssistNow_new_token_generation_Record();
        List<Contact> contactRecordList = [select id, RecordTypeId, MGA_Token__c, MGA__c, ownerId from contact where id IN : factory.getBulkRecordIds()];
        Contact data = factory.updateRecords(contactRecordList[0]);
        List<Task> taskRecordList = [select id, ActivityDate, Description, IsVisibleInSelfService, OwnerId, Priority, Status, Subject, WhoId, WhatId from Task where WhoId = :data.id];
        List<Task> taskRecordListAll = [select id, ActivityDate, Description, IsVisibleInSelfService, OwnerId, Priority, Status, Subject, WhoId from Task];
        for (Contact c : contactRecordList) {
            for (Task t : taskRecordList) {
                if (c.id == t.WhoId) {
                    System.assertEquals(t.ActivityDate, Date.today(), 'Activity date is not set to TodayDate');
                    System.assertEquals(t.Description, 'New AssistNow Token for this Contact has been generated and sent.', 'Description is not set properly');
                    System.assertEquals(t.OwnerId, c.OwnerId, 'Owner must be contact owner');
                    System.assertEquals(t.Priority, 'C', 'Piority must be set to C');
                    System.assertEquals(t.Status, 'Completed', 'Status is not set to Completed');
                    System.assertEquals(t.Subject, 'Contact: AssistNow new token generated', 'Subject is not set properly');
                    System.assertEquals(t.WhoId, c.Id, 'Who Id is not set correctly');
                }
            }
        }

        Test.stopTest();
    }

    @isTest static void AssistNowTokenToDeactivateConditionTest() {
        Test.startTest();
        ContactTestDataFactory factory = new ContactTestDataFactory();
        Database.SaveResult[] output = factory.AssistNow_token_to_deactivate_Record();
        List<Contact> contactRecordList = [select id, RecordTypeId, MGA_Token__c, MGA__c, ownerId from contact where id IN : factory.getBulkRecordIds()];
        List<Task> taskRecordList = [select id, ActivityDate, Description, IsVisibleInSelfService, OwnerId, Priority, Status, Subject, WhoId, WhatId from Task where WhoId IN :contactRecordList];
        List<Task> taskRecordListAll = [select id, ActivityDate, Description, IsVisibleInSelfService, OwnerId, Priority, Status, Subject, WhoId from Task];
        for (Contact c : contactRecordList) {
            for (Task t : taskRecordList) {
                if (c.id == t.WhoId) {
                    System.assertEquals(t.ActivityDate, Date.today(), 'Activity date is not set to TodayDate');
                    System.assertEquals(t.Description, 'The AssistNow Token for this Contact will be deactivated. u-blox SVC Team will inform you as soon as the token has been deactivated.', 'Description is not set properly');
                    System.assertEquals(t.OwnerId, c.OwnerId, 'Owner must be contact owner');
                    System.assertEquals(t.Priority, 'C', 'Piority must be set to C');
                    System.assertEquals(t.Status, 'Completed', 'Status is not set to Completed');
                    System.assertEquals(t.Subject, 'Contact: AssistNow token to deactivate', 'Subject is not set properly');
                    System.assertEquals(t.WhoId, c.Id, 'Who Id is not set correctly');

                }
            }
        }

        Test.stopTest();
    }

    @isTest static void SendeLULAMLinkToContactConditionTest() {
        Test.startTest();
        ContactTestDataFactory factory = new ContactTestDataFactory();
        Database.SaveResult[] output = factory.Send_e_LULA_M_link_to_Contact_Record();
        List<Contact> contactRecordList = [select id, RecordTypeId, MGA_Token__c, MGA__c, ownerId from contact where id IN : factory.getBulkRecordIds()];
        contactRecordList[0].e_LULA_M__c = true;
        Contact data = factory.updateRecords(contactRecordList[0]);
        List<Task> taskRecordList = [select id, ActivityDate, Description, IsVisibleInSelfService, OwnerId, Priority, Status, Subject, WhoId, WhatId from Task where WhoId = :data.id];
        List<Task> taskRecordListAll = [select id, ActivityDate, Description, IsVisibleInSelfService, OwnerId, Priority, Status, Subject, WhoId from Task];
        for (Contact c : contactRecordList) {
            for (Task t : taskRecordList) {
                if (c.id == t.WhoId) {
                    System.assertEquals(t.ActivityDate, Date.today(), 'Activity date is not set to TodayDate');
                    System.assertEquals(t.Description, 'e-LULA-M link has been sent.', 'Description is not set properly');
                    System.assertEquals(t.OwnerId, c.OwnerId, 'Owner must be contact owner');
                    System.assertEquals(t.Priority, 'C', 'Piority must be set to C');
                    System.assertEquals(t.Status, 'Completed', 'Status is not set to Completed');
                    System.assertEquals(t.Subject, 'Email: e-LULA-M webform link sent to the customer', 'Subject is not set properly');
                    System.assertEquals(t.WhoId, c.Id, 'Who Id is not set correctly');

                }
            }
        }

        Test.stopTest();
    }

    @isTest static void SendeLULANLinktoContactConditionTest() {
        Test.startTest();
        ContactTestDataFactory factory = new ContactTestDataFactory();
        Database.SaveResult[] output = factory.Send_e_LULA_N_link_to_Contact_Record();
        List<Contact> contactRecordList = [select id, RecordTypeId, MGA_Token__c, MGA__c, ownerId from contact where id IN : factory.getBulkRecordIds()];
        contactRecordList[0].e_LULA_N__c = true;
        Contact data = factory.updateRecords(contactRecordList[0]);
        List<Task> taskRecordList = [select id, ActivityDate, Description, IsVisibleInSelfService, OwnerId, Priority, Status, Subject, WhoId, WhatId from Task where WhoId = :data.id];
        List<Task> taskRecordListAll = [select id, ActivityDate, Description, IsVisibleInSelfService, OwnerId, Priority, Status, Subject, WhoId from Task];
        for (Contact c : contactRecordList) {
            for (Task t : taskRecordList) {
                if (c.id == t.WhoId) {
                    System.assertEquals(t.ActivityDate, Date.today(), 'Activity date is not set to TodayDate');
                    System.assertEquals(t.Description, 'e-LULA-N link has been sent.', 'Description is not set properly');
                    System.assertEquals(t.OwnerId, c.OwnerId, 'Owner must be contact owner');
                    System.assertEquals(t.Priority, 'C', 'Piority must be set to C');
                    System.assertEquals(t.Status, 'Completed', 'Status is not set to Completed');
                    System.assertEquals(t.Subject, 'Email: e-LULA-N webform link sent to the customer', 'Subject is not set properly');
                    System.assertEquals(t.WhoId, c.Id, 'Who Id is not set correctly');

                }
            }
        }

        Test.stopTest();
    }

    @isTest static void SendeNDAAmericasLinktoContactcreatedtConditionTest() {
        Test.startTest();
        ContactTestDataFactory factory = new ContactTestDataFactory();
        Database.SaveResult[] output = factory.Send_e_NDA_Americas_link_to_Contact_created_Record();
        List<Contact> contactRecordList = [select id, RecordTypeId, MGA_Token__c, MGA__c, ownerId from contact where id IN : factory.getBulkRecordIds()];
        List<Task> taskRecordList = [select id, ActivityDate, Description, IsVisibleInSelfService, OwnerId, Priority, Status, Subject, WhoId, WhatId from Task where WhoId IN :contactRecordList];
        List<Task> taskRecordListAll = [select id, ActivityDate, Description, IsVisibleInSelfService, OwnerId, Priority, Status, Subject, WhoId from Task];
        for (Contact c : contactRecordList) {
            for (Task t : taskRecordList) {
                if (c.id == t.WhoId) {
                    System.assertEquals(t.ActivityDate, Date.today(), 'Activity date is not set to TodayDate');
                    System.assertEquals(t.Description, 'e-NDA link has been sent. Set the Status to Completed once the Case has been closed.', 'Description is not set properly');
                    System.assertEquals(t.OwnerId, c.OwnerId, 'Owner must be contact owner');
                    System.assertEquals(t.Priority, 'C', 'Piority must be set to C');
                    System.assertEquals(t.Status, 'In Progress', 'Status is not set to Completed');
                    System.assertEquals(t.Subject, 'Email: e-NDA webform link sent to the customer', 'Subject is not set properly');
                    System.assertEquals(t.WhoId, c.Id, 'Who Id is not set correctly');
                }
            }
        }

        Test.stopTest();
    }
}
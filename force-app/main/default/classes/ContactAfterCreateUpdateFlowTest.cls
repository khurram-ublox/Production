@isTest
public class ContactAfterCreateUpdateFlowTest {
    @isTest static void COPRecordTypeStdConditionTest() {
        Test.startTest();
        ContactTestDataFactory factory = new ContactTestDataFactory();
        Database.SaveResult[] output = factory.COP_Record_Type_Std_Record();
        List<Contact> dbRecordList = [select id, RecordTypeId, MGA_Support_Email__c from contact where id IN : factory.getBulkRecordIds()];
        Id recordTypeId = '01257000000BeCB'; //Standard RecordTypeId
        for (Contact c : dbRecordList) {
            System.assertEquals(c.RecordTypeId, recordTypeId, 'Should return the same recordID defined in the Flow Update Action.');
            System.assertEquals(c.MGA_Support_Email__c, 'support@u-blox.com', 'AssistNowSupportEmail formula is not working correctly.');
        }

        Test.stopTest();
    }

    @isTest static void COPRecordTypeFinanceConditionTest() {
        Test.startTest();
        ContactTestDataFactory factory = new ContactTestDataFactory();
        Database.SaveResult[] output = factory.COP_Record_Type_Finance_Record();
        List<Contact> dbRecordList = [select id, RecordTypeId, MGA_Support_Email__c from contact where id IN : factory.getBulkRecordIds()];
        Id recordTypeId = '01257000000BeCA';  //Finance RecordTypeId
        for (Contact c : dbRecordList) {
            System.assertEquals(c.RecordTypeId, recordTypeId, 'Should return the same recordID defined in the Flow Flow Update Action.');
            System.assertEquals(c.MGA_Support_Email__c, 'support@u-blox.com', 'AssistNowSupportEmail formula is not working correctly.');
        }

        Test.stopTest();
    }
}
@isTest
public class ContactTestDataFactory extends TestDataFactory {
    
    public ContactTestDataFactory() {
        super('contact');
    }

    public override sObject initializeRecord(){
        Contact c = new Contact();
        c.LastName = 'Test Contact1';
        return c;
    }

    public override sObject createRecord() {
        Contact c = (Contact)initializeRecord();
        Insert c;
        return c;
    }

    public override List<sObject> createBulkRecords() {
        for (Integer i = 0; i < numberOfRecords; i++) {
            Contact cont = new Contact();
            cont.LastName = 'Test Contact'+i;
            recordsList.add(cont);
        }
        Insert recordsList;
        return recordsList;
    }

    public Contact updateRecords(Contact toupdate) {
        toUpdate.MGA_Token__c = 'tokenupdaed';
        update toupdate;
        return toupdate;
    } 

    
    public Database.SaveResult[] COP_Record_Type_Std_Record() {
        String record = '[{"LastName": "Test Contact 1", "Role__c": "Other"}]';
        return createBulkRecordsfromJson(record);
    }

    public Database.SaveResult[] COP_Record_Type_Finance_Record() {
        String record = '[{"LastName": "Test Contact 1", "Role__c": "Shareholder engagement", "RecordTypeId": "01257000000BeCAAA0"}]';
        return createBulkRecordsfromJson(record);
    }

    public Database.SaveResult[] AssistNow_new_token_generation_Record() {
        String record = '[{"LastName": "Test Contact 1", "MGA__c": "true", "MGA_Token__c": "thisistoken32", "Email": "testuser@example.com"}]';
        return createBulkRecordsfromJson(record);
    }

    public Database.SaveResult[] AssistNow_token_to_deactivate_Record() {
        String record = '[{"LastName": "Test Contact 1", "MGA__c": "false", "Email": "testuser@example.com", "MGA_Requested_Date__c": "2016-10-30T15:27:02.000Z", "AssistNow_Token_To_Delete__c": "delete"}]';
        return createBulkRecordsfromJson(record);
    }

    public Database.SaveResult[] AssistNow_token_to_resend_Record() {
        String record = '[{"LastName": "Test Contact 1", "Email": "testuser@example.com", "AssistNow_Token_Resend__c": "true"}]';
        return createBulkRecordsfromJson(record);
    }

    public Database.SaveResult[] Send_e_LULA_M_link_to_Contact_Record() {
        String record = '[{"LastName": "Test Contact 1", "Email": "testuser@example.com", "e_LULA_M__c": "false"}]';
        return createBulkRecordsfromJson(record);
    }

    public Database.SaveResult[] Send_e_LULA_N_link_to_Contact_Record() {
        String record = '[{"LastName": "Test Contact 1", "Email": "testuser@example.com", "e_LULA_N__c": "false"}]';
        return createBulkRecordsfromJson(record);
    }

    public Database.SaveResult[] Send_e_NDA_Americas_link_to_Contact_created_Record() {
        AccountTestDataFactory accountFactory = new AccountTestDataFactory();
        Account a = (Account)accountFactory.initializeRecord();
        a.uB_Office__c = 'Americas';
        a = (Account)accountFactory.createRecord(a);
        String record = '[{"LastName": "Test Contact 1", "Email": "testuser@example.com", "e_NDA__c": "true", "AccountId": "'+a.Id+'"}]';
        return createBulkRecordsfromJson(record);
    }
}
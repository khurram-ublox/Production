@isTest
public class OpportunityTestDataFactory extends TestDataFactory {
    public OpportunityTestDataFactory() {
        super('Opportunity');
    }

    public override sObject initializeRecord(){
        Opportunity o = new Opportunity();
        o.Name = 'Test Opportunity1';
        o.StageName = '3 Calling on';
        o.CloseDate = Date.today();
        return o;
    }

    public override sObject createRecord() {
        Opportunity o = (Opportunity)initializeRecord();
        Insert o;
        return o;
    }

    public sObject createRecord(sObject record) {
        Insert record;
        return record;
    }

    public sObject updateRecord(Opportunity record) {
        update record;
        return record;
    }

    public override List<sObject> createBulkRecords() {
        for (Integer i = 0; i < numberOfRecords; i++) {
            Opportunity cont = new Opportunity();
            cont.Name = 'Test Opportunity'+i;
            recordsList.add(cont);
        }
        Insert recordsList;
        return recordsList;
    }

    public Database.SaveResult[] Opp_embargo_countries_Record() {
        AccountTestDataFactory accFactory = new AccountTestDataFactory();
        Account a = accFactory.getAccwithBillingAddress();
        String data = '[{"Name": "Test Opportunity1", "StageName": "3 Calling on", "CloseDate": "2021-11-28", "AccountId": "'+a.id+'"}]';
        return createBulkRecordsfromJson(data);
    }

    public Database.SaveResult[] All_Opps_Record() {
        AccountTestDataFactory accFactory = new AccountTestDataFactory();
        Account a = accFactory.getAccwithBillingAddress();
        String data = '[{"Name": "Test Opportunity1", "StageName": "3 Calling on", "CloseDate": "2021-11-28", "AccountId": "'+a.id+'"}]';
        return createBulkRecordsfromJson(data);
    }

    public Database.SaveResult[] Send_Email_to_Future_Americas_Record() {
        AccountTestDataFactory accFactory = new AccountTestDataFactory();
        Account a = accFactory.getAccwithBillingAddress();
        String data = '[{"Name": "Test Opportunity1", "StageName": "3 Calling on", "CloseDate": "2021-11-28", "AccountId": "'+a.id+'", "Approval_Status_Flag__c": "Approved"}]';
        return createBulkRecordsfromJson(data);
    }

    public Database.SaveResult[] Opportunity_send_mail_with_information_Record() {
        AccountTestDataFactory accFactory = new AccountTestDataFactory();
        Account a = accFactory.getAccwithBillingAddress();
        String data = '[{"Name": "Test Opportunity1", "StageName": "3 Calling on", "CloseDate": "2021-11-28", "AccountId": "'+a.id+'", "Approval_Status_Flag__c": "Approved", "Send_mail_with_info__c": "true" }]';
        return createBulkRecordsfromJson(data);
    }
    
    public Opportunity Opp_Reminder_of_Stage_5_to_FAE_Record() {
        Opportunity o = (Opportunity)createRecord();
        AccountTestDataFactory accFactory = new AccountTestDataFactory();
        Account a = (Account)accFactory.createRecord();
        a.uB_Office__c = 'EMEA';
        a = (Account)accFactory.updateRecords(a);
        o.StageName = '5 Design-in';
        return (Opportunity)updateRecord(o);
    }
    
    public Opportunity Opp_Owner_different_from_Account_Owner_Record() {
        Opportunity o = (Opportunity)createRecord();
        AccountTestDataFactory accFactory = new AccountTestDataFactory();
        Account a = (Account)accFactory.createRecord();
        o.AccountId = a.id;
        return (Opportunity)updateRecord(o);
    }
    
    public Opportunity oppForOppProduct(){
    Opportunity OPP = (Opportunity)initializeRecord();
    
    OPP.Opportunity_Account__c = OPP.AccountId;
    Opp.AccountId = OPP.AccountId;
    OPP.Name = OPP.Name + ' - New generation';
    OPP.CurrencyIsoCode = 'EUR';
    OPP.RecordTypeId = '01220000000CqRn'; /*Record ID für Opportunity*/
    OPP.Annual_Quantity__c = 500;
    OPP.New_Application_Type__c = 'Gateways and routers';

    
    OPP.Description = 'This is test opportunity';
    
    OPP.Area_opportunity_owner__c = 'Americas';
    OPP.Area_design_house__c = 'Americas';
    OPP.Area_manufacturing__c = 'Americas';
    OPP.Area_Design_Win__c = 'EMEA';
    OPP.Remark_Contribution__c = 'I worked really hard to develop this';
    OPP.Team_members__c = 'Adrian Tan';

    insert OPP;
    return OPP;
    }
    
}
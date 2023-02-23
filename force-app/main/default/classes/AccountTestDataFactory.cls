@isTest
public class AccountTestDataFactory  extends TestDataFactory {
    public AccountTestDataFactory() {
        super('account');
    }

    public override sObject initializeRecord(){
        Account a = new Account();
        a.Name = 'Test Account1';
        return a;
    }

    public override sObject createRecord() {
        Account a = (Account)initializeRecord();
        Insert a;
        return a;
    }

    public sObject createRecord(sObject record) {
        // Account a = (Account)record;
        Insert record;
        return record;
    }

    public override List<sObject> createBulkRecords() {
        for (Integer i = 0; i < numberOfRecords; i++) {
            Account cont = new Account();
            cont.Name = 'Test Account'+i;
            recordsList.add(cont);
        }
        Insert recordsList;
        return recordsList;
    }

    public Account updateRecords(Account toupdate) {
        update toupdate;
        return toupdate;
    }

    public Account getAccwithBillingAddress(){
        Account a = (Account)initializeRecord();
        a.BillingCountry = 'CU';
        a = (Account)createRecord(a);
        return a;
    }
}
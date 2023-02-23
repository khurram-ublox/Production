@isTest
public class BillingsTestDataFactory extends TestDataFactory {
   
    public BillingsTestDataFactory() {
        super('Billings');
    }

    public override sObject initializeRecord(){
        AccountTestDataFactory acc = new AccountTestDataFactory();
        SObject account = acc.createRecord();		
        Product2 product2 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Family = 'ALEX', Positioning_Engine__c = 'Not applicable', Product_Center__c = 'Positioning', Packaging_Size__c = 1000);
        insert product2;
        
        Billings__c billings = new Billings__c();
        billings.Name = 'Test Billings';
        billings.USDtoCHF__c = 5;
        billings.Qty_Invoiced__c = 10;
        billings.Invoice_Number__c = 'abc0123';
        billings.Total_Value_CHF__c = 10;
        billings.Total_COGS_CHF__c = 2;
        billings.Invoice_Date__c = Date.newInstance(2022, 11, 11);
        billings.Product__c = product2.id;
        billings.Account__c = account.id;
        billings.End_Customer_Account__c= account.id;
        billings.Project_Owner_Account__c = account.id;
		
       	return billings;
    }

    public override sObject createRecord() {
        Billings__c a = (Billings__c)initializeRecord();
        Insert a;
        return a;
    }

    public sObject createRecord(sObject record) {
        Insert record;
        return record;
    }

    public override List<sObject> createBulkRecords() {
        for (Integer i = 0; i < numberOfRecords; i++) {
            Billings__c cont = new Billings__c();
            cont.Name = 'Test Billings'+i;
            recordsList.add(cont);
        }
        Insert recordsList;
        return recordsList;
    }

    public Billings__c updateRecords(Billings__c toupdate) {
        update toupdate;
        return toupdate;
    }   
    
}
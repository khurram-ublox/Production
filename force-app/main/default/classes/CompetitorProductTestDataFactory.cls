@IsTest
public class CompetitorProductTestDataFactory extends TestDataFactory {
 
    public CompetitorProductTestDataFactory() {
        super('Competitor_Product__c');
    }

    public override sObject initializeRecord(){
        Competitor_Product__c initcp = new Competitor_Product__c();
        initcp.Name = 'Test Competitor Product';
        
        CompetitorTestDataFactory comp= New CompetitorTestDataFactory();
        Competitor__c c = (Competitor__c)comp.createRecord();
        initcp.Competitor__c = c.id;
        return initcp;
    }

    public override sObject createRecord() {
        Competitor_Product__c createcp = (Competitor_Product__c)initializeRecord();
        Insert createcp;
        return createcp;
    }

    public sObject createRecord(sObject record) {

        Insert record;
        return record;
    }

    public override List<sObject> createBulkRecords() {
        for (Integer i = 0; i < numberOfRecords; i++) {
            Competitor_Product__c cp = new Competitor_Product__c();
            cp.Name = 'Test Competitor Product'+i;
            recordsList.add(cp);
        }
        Insert recordsList;
        return recordsList;
    }

    public Competitor_Product__c updateRecords(Competitor_Product__c toupdate) {
        update toupdate;
        return toupdate;
    }

}
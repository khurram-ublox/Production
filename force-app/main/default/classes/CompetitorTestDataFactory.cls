@IsTest
public class CompetitorTestDataFactory extends TestDataFactory {
 
	    public CompetitorTestDataFactory() {
        super('Competitor__c');
    }

    public override sObject initializeRecord(){
        Competitor__c initc = new Competitor__c();
        initc.Name = 'Test Competitor';
        return initc;
    }

    public override sObject createRecord() {
        Competitor__c createc = (Competitor__c)initializeRecord();
        Insert createc;
        return createc;
    }

    public sObject createRecord(sObject record) {

        Insert record;
        return record;
    }

    public override List<sObject> createBulkRecords() {
        for (Integer i = 0; i < numberOfRecords; i++) {
            Competitor__c c = new Competitor__c();
            c.Name = 'Test Competitor'+i;
            recordsList.add(c);
        }
        Insert recordsList;
        return recordsList;
    }

    public Competitor__c updateRecords(Competitor__c toupdate) {
        update toupdate;
        return toupdate;
    }

}
@IsTest
public class CompetitorProductPriceTestDataFactory extends TestDataFactory {

    public CompetitorProductPriceTestDataFactory() {
        super('Competitor_Product_Price__c');
    }

    public override sObject initializeRecord(){
        Competitor_Product_Price__c cpp = new Competitor_Product_Price__c();
        
        CompetitorTestDataFactory comp= New CompetitorTestDataFactory();
        Competitor__c c = (Competitor__c)comp.initializeRecord();
        cpp.Competitor__c = c.id;
        
        CompetitorProductTestDataFactory cprod = New CompetitorProductTestDataFactory();
        Competitor_Product__c cp = (Competitor_Product__c)cprod.initializeRecord();
        cpp.Competitor_Product__c = cp.id;
		
		OppProductTestDataFactory oppProd = new OppProductTestDataFactory();
        Opp_Product__c oppProdObj = (Opp_Product__c)oppProd.initializeRecord();
		
		//AccountTestDataFactory accTDF = new AccountTestDataFactory();
        //Account acc = (Account)accTDF.initializeRecord();
        
        OpportunityTestDataFactory opportunity = new OpportunityTestDataFactory();
        Opportunity opp = (Opportunity)opportunity.initializeRecord();
        //opp.AccountId = acc.id;
        
        oppProdObj.Opportunity__c = opp.id;
        
		cpp.Opp_Product__c = oppProdObj.id;
        cpp.Comment__c = 'test comment';
        cpp.Price_Information_Date__c = date.today();
        return cpp;
    }

    public override sObject createRecord() {
        Competitor_Product_Price__c cpp = (Competitor_Product_Price__c)initializeRecord();
        Insert cpp;
        return cpp;
    }

    public sObject createRecord(sObject record) {

        Insert record;
        return record;
    }

    public override List<sObject> createBulkRecords() {
        for (Integer i = 0; i < numberOfRecords; i++) {
            Competitor_Product_Price__c cpp = new Competitor_Product_Price__c();
            //cpp.Name = 'Test Competitor Product Price'+i;
            recordsList.add(cpp);
        }
        Insert recordsList;
        return recordsList;
    }

    public Competitor_Product_Price__c updateRecords(Competitor_Product_Price__c toupdate) {
        update toupdate;
        return toupdate;
    }

}
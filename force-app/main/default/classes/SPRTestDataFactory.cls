@IsTest
public class SPRTestDataFactory extends TestDataFactory{

	public override sObject initializeRecord(){
        
		AccountTestDataFactory accountFactory = new AccountTestDataFactory();
        Account acc = (Account)accountFactory.createRecord();
        
        Special_Price_Request__c sprObj = new Special_Price_Request__c();
        sprObj.Account__c = acc.Id;
        sprObj.Status__c = 'Approved';
        sprObj.Price_Level__c = 'PPP (Project Price Plan)';
        sprObj.Approved_By_Team_Leader__c = false;
        sprObj.Approved_By_Team_Manager__c = false;
        sprObj.Approved_By_Regional_Head__c = true;
        sprObj.Comment_by_Requestor__c = 'Comment by Requestor...';
        
        return sprObj;
        
    }
    public override sObject createRecord() {
		Special_Price_Request__c sprObj = (Special_Price_Request__c)initializeRecord();
        insert sprObj;
        return sprObj;
        
    }
    public override List<sObject> createBulkRecords() {
        for (Integer i = 0; i < numberofRecords; i++) {
            recordsList.add((Special_Price_Request__c)initializeRecord());
        }
        Insert recordsList;
        return recordsList;
        
    }

}
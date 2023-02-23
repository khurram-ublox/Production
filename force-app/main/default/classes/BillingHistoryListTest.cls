@IsTest
public class BillingHistoryListTest {

	@isTest
    static void TestbHistoryOrders(){
    	AccountTestDataFactory accountrecord = new AccountTestDataFactory();
        SObject account = accountrecord.createRecord();

        Product2 product2 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Family = 'ALEX', Positioning_Engine__c = 'Not applicable', Product_Center__c = 'Positioning', Packaging_Size__c = 1000);
        insert product2;
		Billings__c billings = new Billings__c(Name = 'Test Billings', USDtoCHF__c = 5, Qty_Invoiced__c = 10, Invoice_Number__c = 'abc0123', Total_Value_CHF__c = 10, Total_COGS_CHF__c = 2, Invoice_Date__c = Date.newInstance(2022, 11, 11), Product__c = product2.id,Account__c = account.id , End_Customer_Account__c= account.id, Project_Owner_Account__c = account.id);
        insert billings;
        
        
        test.startTest();       
        List<Account> acc = [SELECT SF_Account_Number__c FROM Account WHERE id=:account.id];
        
        Map<string, Map<Integer,BillingHistoryList.BillingHistoryWrapper>> billinghistory = BillingHistoryList.bHistoryOrders(account.id); 
        system.assert(billinghistory.size() >0);
        test.stopTest();
    }
}
/*
@IsTest
public class BillingHistoryListTest {

	@isTest
    static void TestbHistoryOrders(){
    	//AccountTestDataFactory acctestdata = new AccountTestDataFactory();
        //BillingsTestDataFactory billing = new BillingsTestDataFactory();
        //SObject account = acctestdata.createRecord();
        //SObject billings = billing.createRecord();
        Account account = new Account(Name = 'Test Account');
        insert account;
        system.debug('account ---- '+account);
        Product2 product2 = new Product2(Name = 'NEO-M8P', Type_No__c= 'NEO-M8P-2-11', ProductCode= 'NEO-M8P-2', Family = 'ALEX', Positioning_Engine__c = 'Not applicable', Product_Center__c = 'Positioning', Packaging_Size__c = 1000);
        insert product2;
        system.debug('product2 ---- '+product2);
		Billings__c billings = new Billings__c(Name = 'Test Billings', USDtoCHF__c = 5, Qty_Invoiced__c = 10, Invoice_Number__c = 'abc0123', Total_Value_CHF__c = 10, Total_COGS_CHF__c = 2, Invoice_Date__c = Date.newInstance(2022, 11, 11), Product__c = product2.id,Account__c = account.id , End_Customer_Account__c= account.id, Project_Owner_Account__c = account.id);
        insert billings;
        system.debug('billings ---- '+billings);
        
        
        test.startTest();

        system.debug('account ---- '+account);
        system.debug('product2 ---- '+product2);
        system.debug('billings ---- '+billings);
        
        List<Account> acc = [SELECT SF_Account_Number__c FROM Account WHERE id=:account.id];
        
        BillingHistoryList.bHistoryOrders(account.id);       
        test.stopTest();
    }
}
*/
@IsTest
public class ShowOrdersListTest {

	@isTest
    static void TestgetOrders(){
        AccountTestDataFactory account = new AccountTestDataFactory();
        SObject accountRecord = account.createRecord();
        system.debug('accountRecord  ufar >>>> '+accountRecord);
		
        Product2 product2 = new Product2(Name = 'EVK-M101', Type_No__c= 'EVK-M101-00-00', ProductCode= 'EVK-M101-00', Family = 'Eval Kit', Positioning_Engine__c = 'Not applicable', Product_Center__c = 'Positioning', Packaging_Size__c = 1000);
        insert product2;
        system.debug('product2 ufar >>>> '+product2);
        // Date.newInstance(2022, 10, 10)
       	Billings__c mybillings = new Billings__c(Name = 'Test Billings', Total_Value__c = 5000 , Price_per_unit__c = 5, Qty_Ordered__c = 400, Delivery_Date__c = Date.today(), Request_Date__c = Date.today(), Order_Date__c = Date.today(), Frame_Order__c = false, Product_ID__c = 'EVK-M101-00-00', Reporting_Region__c = 'AMERICAS', Reference__c = 'test reference', Order_No__c = 123456, PO_No_Line_Item__c = 'test line number' , USDtoCHF__c = 5,  Invoice_Number__c = 'abc0123', Total_Value_CHF__c = 10, Total_COGS_CHF__c = 2, Invoice_Date__c =Date.today(), Product__c = product2.id,Account__c = accountRecord.id , End_Customer_Account__c= accountRecord.id, Project_Owner_Account__c = accountRecord.id);
        insert mybillings;
        system.debug('mybillings ufar >>>> '+mybillings);
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity1', product_1__c = product2.id , StageName = '3 Calling on', CloseDate = Date.today(), AccountId = accountRecord.id);
		insert opp;
        system.debug('opp ufar  >>>> '+opp);
        
        test.startTest();
         
        List<Account> acc = [SELECT SF_Account_Number__c FROM Account WHERE id=:accountRecord.id];
       	List<Billings__c> listBillngAccount = ShowOrderslist.getOrders(accountRecord.id);
		List<Billings__c> listBillngOpportunity = ShowOrderslist.getOrders(opp.id);
                
        system.assert(listBillngAccount.size() >0);
        system.assert(listBillngOpportunity.size() >0);

        test.stopTest();
    }
}


/*
@IsTest
public class ShowOrdersListTest {

	@isTest
    static void TestgetOrders(){
        AccountTestDataFactory account = new AccountTestDataFactory();
        BillingsTestDataFactory billings = new BillingsTestDataFactory();
        OpportunityTestDataFactory opportunity = new OpportunityTestDataFactory();
        SObject accountRecord = account.createRecord();
        SObject billingsRecord = billings.createRecord();
        SObject oppRecord = opportunity.createRecord();
        
        test.startTest();
         
       	ShowOrderslist.getOrders(accountRecord.id);
       	ShowOrderslist.getOrders(oppRecord.id);
        //system.debug('acc ---- '+acc);
        //system.debug('billingsRecord ---- '+billingsRecord);
        //system.debug('accountRecord ---- '+accountRecord);
		//system.debug('reportOrdersList ---- '+reportOrdersList);
        test.stopTest();
    }
}
*/
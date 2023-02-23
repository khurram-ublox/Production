@isTest
private class PopCustomerPartNumberOnOrderTest {
	
	@isTest static void popCustomerPartNumberOnOrderTest() {

		Map<Id, Billings__c> billingIdsMap = new Map<Id, Billings__c>();

		Account acc = new Account(Name = 'Test Account');
		insert acc;

		Billings__c obillings = new Billings__c(Name = 'Test Order', Account__c = acc.Id, CurrencyIsoCode = 'EUR');
		insert obillings;

		Customer_Part_Number__c cpn = new Customer_Part_Number__c(Name = 'cpn1', Account_Name__c = acc.Id, Customer_Part_Number__c = '12345');
		insert cpn;



		List<Id> billingIds = new List<Id>();
		billingIds.add(obillings.Id);
		
		List<Billings__c> billingIdsToSave = new List<Billings__c>();

		Billings__c bux = billingIdsMap.get(billingIds.get(0));
		//billingIdsToSave.add(bux);

		List<Billings__c> billings = new List<Billings__c>([SELECT Id, Account__c, Product__c, Product_ID__c, Customer_Part_Number__c FROM Billings__c WHERE Id =: billingIds]);
		

		//List<Customer_Part_Number__c> cpns = new List<Customer_Part_Number__c>([SELECT Id, Customer_Part_Number__c FROM Customer_Part_Number__c WHERE Id =: cpn.Id]);

		for(Billings__c b : billings){


			if(b.Product_ID__c == cpn.Type_Number_field_update__c && b.Account__c == cpn.Account_Name__c && b.Product__c == cpn.Type_No_c__c && b.Customer_Part_Number__c==null){
				b.Customer_Part_Number__c = '12345';
				billingIdsToSave.add(b);
			}
		}

		update billingIdsToSave;
		
	}
	
	
	
}
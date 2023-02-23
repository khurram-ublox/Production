@isTest
private class TestNewApplicationTypeTrigger {
	
	@isTest static void test_method_for_account() {
		Account acc = new Account();
		acc.Name = 'Test trigger account';
		insert acc;

		acc.Name = 'Field updated';
		update acc;
	}

	
	
	@isTest static void test_method_for_lead() {
		Lead l = new Lead();
		l.Company = 'Test trigger lead';
		l.Country = 'PK';
		l.LastName = 'Shahzad';
		insert l;

		l.Company = 'Field updated';
		update l;
	}
	


	@isTest static void test_method_for_opportunity() {
	
		
		Account acc = new Account();
		acc.Name = 'temp';
		acc.uB_Office__c = 'Corporate';
		acc.RecordTypeID='01257000000Be12';
		
		insert acc;

		
			Opportunity opp = new Opportunity();
			opp.AccountId = acc.Id;
			opp.Name = 'Test trigger opportunity';
			opp.StageName = '3 Calling on';
			opp.CloseDate = Date.today();
			opp.Annual_Quantity__c = 100;
			opp.Reason__c = 'testing trigger code';
			
		
		insert opp;

		opp.Name = 'Field updated';
		update opp;
	}
}
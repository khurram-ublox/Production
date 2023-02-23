@isTest
public with sharing class TestTriggers {

	public static testMethod void testTriggers(){
		Account testAcc = new Account();
		testAcc.Name = 'test';
		insert testAcc;
		
		testAcc.Name = 'test2';
		update testAcc;
		
		Design_Review__c testDr = new Design_Review__c();
		testDr.Distributor_Name__c = '';
		testDr.Email_Account_Owner__c = '';
		testDr.Account_Name__c = testAcc.Id;
		insert testDr;
		
		RMA__c testRMA = new RMA__c();
		testRMA.Distributor_Name__c = '';
		testRMA.Email_Account_Owner__c = '';
		testRMA.Approval_available__c = true;
		testRMA.Account_Name__c = testAcc.Id;
		insert testRMA;
		
		Case testCase = new Case();
		testCase.Distributor_Name__c = '';
		testCase.Email_Account_Owner__c = '';
		insert testCase;
	}

}
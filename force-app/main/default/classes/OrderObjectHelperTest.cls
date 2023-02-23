@isTest
public class OrderObjectHelperTest {
    @isTest
    public static void testContributionShare(){
        
        Account acc = TestUtils.createAccountWithCountry();
        Product2 prod011 = TestUtils.createProduct('TEST-P001','TEST-P001-0', 'SARA', 'TEST-P001-0-01') ;
        Product2 prod02 = TestUtils.createProduct('TEST-P002','TEST-P001-0', 'SARA', 'TEST-P001-0-02') ;
        Opportunity opp = testUtils.createOpportunityForAccount(acc.Id);
        Contribution_Share__c CS = testUtils.createCS(acc.Id,acc.Id,acc.Id,prod02.Id,opp.Id,'','');
        Contribution_Share__c CS3 = testUtils.createCS(acc.Id,acc.Id,acc.Id,NULL,opp.Id,'Family','SARA');  
        // Insert
        testUtils.createOrder(acc.Id, acc.Id, acc.Id, prod02.Id);
        // Insert
        testUtils.createOrder(acc.Id, acc.Id, acc.Id, prod011.Id);
    }
    
}
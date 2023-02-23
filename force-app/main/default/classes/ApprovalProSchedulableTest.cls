@isTest
private class ApprovalProSchedulableTest {


    public static String CRON_EXP = '0 0 0 15 3 ? 2030';

    static testmethod void testprocessApprovalrecord(){
        
    Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
    // Commenting out Product__c prod. It is for the removal of custom Product obj. By ufar, 12-6-22.
    /*
        Product__c prod = new Product__c();
        prod.Name = 'TEst Product';
        prod.Type_No__c = 'MPCI-L280-03S-03';
    prod.Packaging_Size__c = 150;
        prod.Product_Family__c = 'PCI';
        prod.Positioning_Engine__c = 'Not applicable';
        prod.CurrencyIsoCode = 'USD';
        insert prod;
	*/
    Product2 prodForRanked1 = new Product2(Name='testProd1', Type_No__c='testTypeNum1', Product_Center__C='Positioning');  // khir: Added Product Canter
        insert prodForRanked1;

        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'Test opportunity';
        opp.StageName = '6 Prototypes';
        opp.CloseDate = Date.newInstance(2030, 12, 9);
        insert opp;

    Opp_Product__c oppProd = new Opp_Product__c(); 
        oppProd.Opportunity__c = opp.Id;
    oppProd.CurrencyIsoCode = 'USD';
        oppProd.Status__c = 'Not applicable';
        oppProd.Flag_Approval_Status__c = 'Pending';
        oppProd.Flagged_Item__c = False;
        oppProd.Product__c = prodForRanked1.Id;
        insert oppProd;
    
    List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();

    Test.startTest();
        
    Approval.ProcessWorkitemRequest apwir = new approval.ProcessWorkitemRequest();
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
    app.setObjectId(oppProd.Id);
        Approval.ProcessResult resu = Approval.process(app);
    String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new ApprovalProSchedulable());
    ApprovalProcessAutomation approclass = new ApprovalProcessAutomation();
        approclass.processApprovalrecord();
        apwir.setAction('Approve');
        
        Test.stopTest();
    }   
}
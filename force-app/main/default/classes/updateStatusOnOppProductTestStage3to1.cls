@isTest
public class updateStatusOnOppProductTestStage3to1 {

    private static Product2 createProduct (String Name, String Type)
    {
    return new Product2(
        Name=Name,
        Type_No__C=Type,
        Packaging_Size__c=1,
        Family='Other',
        Positioning_Engine__c='Not applicable',
        CurrencyIsoCode='USD',
        COGS_1__c=20,
        COGS_Pct__c=0);
    }

    private static Opportunity createOpportunity (String Name)
    {
        Account a = new Account(Name='Test Acc',uB_Office__c='Corporate');
        insert a;
        return new Opportunity(
            Name=Name,
            Annual_Quantity__c=10,
            New_Application_Type__c='Asset tracking and management', 
            New_Market__c='Industrial',
            CurrencyIsoCode='USD',
            StageName='3 Calling on',
            Description='test description',
            AccountId=a.Id,
            CloseDate=Date.today());
    }

    private static Opp_Product__c createOppProduct (String ProductID, String OpportunityID, String Status, String Reason)
    {
    return new Opp_Product__c(
        RecordTypeID='012D0000000BaPZ',
        Product__c = ProductID,
        Opportunity__c = OpportunityID,
        CurrencyIsoCode='USD',
        Unit_Price__c=30,
        Status__c=Status,
        Loss_Reason__c=Reason);
    }
    
    public static testMethod void testOppProdStatusReason()
    {
        // Create new Product with mandatory fields (Product Center undefined)
        List<Product2> ProdToInsert = new List <Product2>{};
        Product2 p1 = createProduct ('Test Product 1', 'Test_Type_Number_1');
        ProdToInsert.add(p1);
        Product2 p2 = createProduct ('Test Product 2', 'Test_Type_Number_2');
        ProdToInsert.add(p2);
        Product2 p3 = createProduct ('Test Product 3', 'Test_Type_Number_3');
        ProdToInsert.add(p3);
        Product2 p4 = createProduct ('Test Product 4', 'Test_Type_Number_4');
        ProdToInsert.add(p4);
        Product2 p5 = createProduct ('Test Product 5', 'Test_Type_Number_5');
        ProdToInsert.add(p5);
        insert ProdToInsert;

        // Create new Opportunities with mandatory fields
        // o1: Opportunity Stage from 3 Calling on to 5 Design-in
        // o2: Opportunity Stage from 3 Calling on to 1 Lost
        List<Opportunity> OppToInsert = new List <Opportunity>{};
        Opportunity o1 = createOpportunity ('TestOpp_3_to_5');
        OppToInsert.add(o1);
        insert OppToInsert;

        // Create new Opp Product (Record Type=Positioning)
        // op1: For o1 to test Evaluation to Won
        // op2: For o1 to test Lost (unchanged)
        // op3: For o1 to test Alternative Product to Lost
        // op4: For o2 to test Evaluation to Lost
        // op5: For o2 to test Lost (unchanged)
        // op6: For o2 to test Alternative Product to Lost
        List<Opp_Product__c> OppProdToInsert = new List <Opp_Product__c>{};
        Opp_Product__c op1 = createOppProduct(p1.Id,o1.Id,'Evaluation','');
        OppProdToInsert.add(op1);
        Opp_Product__c op2 = createOppProduct(p2.Id,o1.Id,'Won','Performance');
        OppProdToInsert.add(op2);
        Opp_Product__c op3 = createOppProduct(p3.Id,o1.Id,'Lost','Price');
        OppProdToInsert.add(op3);
        Opp_Product__c op4 = createOppProduct(p4.Id,o1.Id,'Alternative Product','');
        OppProdToInsert.add(op4);
        Opp_Product__c op5 = createOppProduct(p5.Id,o1.Id,'Not applicable','');
        OppProdToInsert.add(op5);

        insert OppProdToInsert;

        // Change Currency in Forecast Unit
        o1.StageName = '1 Lost';
        o1.Reason__c = 'Project Stopped';
        update OppToInsert;

        // Verify that the Status and Reason (Loss_Reason__c) of Opp Products have been changed as expected
        // Stage: 3 Evaluation > 1 Lost
        // Opp Product with Status=Evaluation: Should become Lost, Reason should be from the Opportunity
        Opp_Product__c op1_updated = [SELECT Status__c, Opportunity__r.Reason__c, Loss_Reason__c FROM Opp_Product__c WHERE Product__c = :p1.Id];
        System.assertEquals('Lost', op1_updated.Status__c);
        System.assertEquals(op1_updated.Opportunity__r.Reason__c, op1_updated.Loss_Reason__c);
        Opp_Product__c op2_updated = [SELECT Status__c, Opportunity__r.Reason__c, Loss_Reason__c FROM Opp_Product__c WHERE Product__c = :p2.Id];
        System.assertEquals('Lost', op2_updated.Status__c);
        System.assertEquals(op2_updated.Opportunity__r.Reason__c, op2_updated.Loss_Reason__c);
        Opp_Product__c op3_updated = [SELECT Status__c, Opportunity__r.Reason__c, Loss_Reason__c FROM Opp_Product__c WHERE Product__c = :p3.Id];
        System.assertEquals('Lost', op3_updated.Status__c);
        System.assertEquals('Price', op3_updated.Loss_Reason__c);
        Opp_Product__c op4_updated = [SELECT Status__c, Opportunity__r.Reason__c, Loss_Reason__c FROM Opp_Product__c WHERE Product__c = :p4.Id];
        System.assertEquals('Lost', op4_updated.Status__c);
        System.assertEquals('Alternative Product', op4_updated.Loss_Reason__c);
        Opp_Product__c op5_updated = [SELECT Status__c, Opportunity__r.Reason__c, Loss_Reason__c FROM Opp_Product__c WHERE Product__c = :p5.Id];
        System.assertEquals('Lost', op5_updated.Status__c);
        System.assertEquals('Alternative Product', op5_updated.Loss_Reason__c);

    }
}
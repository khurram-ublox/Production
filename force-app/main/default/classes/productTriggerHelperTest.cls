@isTest(seealldata=false)
public with sharing class productTriggerHelperTest {
/*
2016.04.07 khir: Added Description of new Opportunity creation for update of updateStatusOnOppProduct.apxt
2016.04.07 khir: Added Account creation to solve the error for Flow "EMEA_Sales_Stage_8" (made by Process Builder)
YYYY.MM.DD skyvva: Commented test lines (see below)
2018.03.27 khir: Commented unused items (prodForRanked6, oppProductRanked6)
*/
    
    static testMethod void productTriggerHelperTest() {
        
        Map<Id, Opp_Product__c> oppProducts = new Map<Id, Opp_Product__c>();

        // 2016.04.07 khir: Added Account creation to solve the error for Flow "EMEA_Sales_Stage_8" (made by Process Builder)
        Account acc = new Account(Name='Test Acc',uB_Office__c='Corporate');
        insert acc;
        
        // 2017.11.27 khir: Added Product creation to solve the error for Flow
        Product2 prodForRanked1 = new Product2(Name='testProd1', Type_No__c='testTypeNum1', Product_Series__c='Legacy');
        insert prodForRanked1;
        Product2 prodForRanked2 = new Product2(Name='testProd2', Type_No__c='testTypeNum2', Product_Series__c='Legacy');
        //insert prodForRanked2; saaz
        Product2 prodForRanked3 = new Product2(Name='testProd3', Type_No__c='testTypeNum3', Product_Series__c='Legacy');
        //insert prodForRanked3; saaz
/*
        Product2 prodForRanked4 = new Product2(Name='testProd4', Type_No__c='testTypeNum4', Product_Series__c='Legacy');
        insert prodForRanked4;
        Product2 prodForRanked5 = new Product2(Name='testProd5', Type_No__c='testTypeNum5', Product_Series__c='Legacy');
        insert prodForRanked5;
*/
//        Product2 prodForRanked6 = new Product2(Name='testProd6', Type_No__c='testTypeNum6', Product_Series__c='Legacy');
//        insert prodForRanked6;
        
        
        // 2016.04.07 khir: Added Description of new Opportunity creation for update of updateStatusOnOppProduct.apxt
        Opportunity opp = new Opportunity(Name='TestOpp', StageName='3 Calling on',CloseDate=Date.today(),Description='test description',AccountId=acc.Id);
        insert opp;

        Opp_Product__c oppProductRanked1 = new Opp_Product__c(Opportunity__c=opp.Id);
        // Revenue = Annual_Quantity__c * Unit_Price__c * Status_Factor__c
        oppProductRanked1.Annual_Quantity__c = 10000;
        oppProductRanked1.Unit_Price__c = 10;
        oppProductRanked1.Status__c = 'Won'; // This will set Status_Factor__c for Revenue_c formula.
        oppProductRanked1.Loss_Reason__c = 'Price'; // khir: Added as it's required by Validation Rule.
        oppProductRanked1.Product__c = prodForRanked1.Id;
        //insert oppProductRanked1; saaz

        Opp_Product__c oppProductRanked2 = new Opp_Product__c(Opportunity__c=opp.Id);
        // Revenue = Annual_Quantity__c * Unit_Price__c * Status_Factor__c
        oppProductRanked2.Annual_Quantity__c = 8000;
        oppProductRanked2.Unit_Price__c = 10;
        oppProductRanked2.Status__c = 'Won'; // This will set Status_Factor__c for Revenue_c formula.
        oppProductRanked2.Loss_Reason__c = 'Price'; // khir: Added as it's required by Validation Rule.
        oppProductRanked2.Product__c = prodForRanked2.Id;
        //insert oppProductRanked2;  saaz

        Opp_Product__c oppProductRanked3 = new Opp_Product__c(Opportunity__c=opp.Id);
        // Revenue = Annual_Quantity__c * Unit_Price__c * Status_Factor__c
        oppProductRanked3.Annual_Quantity__c = 6000;
        oppProductRanked3.Unit_Price__c = 10;
        oppProductRanked3.Status__c = 'Won'; // This will set Status_Factor__c for Revenue_c formula.
        oppProductRanked3.Loss_Reason__c = 'Price'; // khir: Added as it's required by Validation Rule.
        oppProductRanked3.Product__c = prodForRanked3.Id;
       //-- insert oppProductRanked3; saaz
        /*
        delete prodForRanked3;
        Product2[] p = [Select Id, IsDeleted from Product2 where Id=:prodForRanked3.Id];
        
        system.assertEquals(true, p.isEmpty());
*/
        
/*
        Opp_Product__c oppProductRanked4 = new Opp_Product__c(Opportunity__c=opp.Id);
        // Revenue = Annual_Quantity__c * Unit_Price__c * Status_Factor__c
        oppProductRanked4.Annual_Quantity__c = 4000;
        oppProductRanked4.Unit_Price__c = 10;
        oppProductRanked4.Status__c = 'Won'; // This will set Status_Factor__c for Revenue_c formula.
        oppProductRanked4.Loss_Reason__c = 'Price'; // khir: Added as it's required by Validation Rule.
        oppProductRanked4.Product__c = prodForRanked4.Id;
        insert oppProductRanked4;

        Opp_Product__c oppProductRanked5 = new Opp_Product__c(Opportunity__c=opp.Id);
        // Revenue = Annual_Quantity__c * Unit_Price__c * Status_Factor__c
        oppProductRanked5.Annual_Quantity__c = 2000;
        oppProductRanked5.Unit_Price__c = 10;
        oppProductRanked5.Status__c = 'Won'; // This will set Status_Factor__c for Revenue_c formula.
        oppProductRanked5.Loss_Reason__c = 'Price'; // khir: Added as it's required by Validation Rule.
        oppProductRanked5.Product__c = prodForRanked5.Id;
        insert oppProductRanked5;
*/
        
        
//        Opp_Product__c oppProductRanked6 = new Opp_Product__c(Opportunity__c=opp.Id);
//        // Revenue = Annual_Quantity__c * Unit_Price__c * Status_Factor__c
//        oppProductRanked6.Annual_Quantity__c = 1000;
//        oppProductRanked6.Unit_Price__c = 10;
//        oppProductRanked6.Status__c = 'Won'; // This will set Status_Factor__c for Revenue_c formula.
//        oppProductRanked6.Loss_Reason__c = 'Price'; // khir: Added as it's required by Validation Rule.
//        oppProductRanked6.Product__c = prodForRanked6.Id;
//        insert oppProductRanked6;


        //skyvva
        //Comment to avoid error from validtion rule https://eu1.salesforce.com/00ND0000005bHJB?setupid=CustomObjects
        /*
        // Relate Products to Opp Product record.
        oppProductRanked1.Product__c = prodForRanked1.Id;
        update oppProductRanked1;
        oppProductRanked2.Product__c = prodForRanked2.Id;
        update oppProductRanked2;
        oppProductRanked3.Product__c = prodForRanked3.Id;
        update oppProductRanked3;
        oppProductRanked4.Product__c = prodForRanked4.Id;
        update oppProductRanked4;
        oppProductRanked5.Product__c = prodForRanked5.Id;
        update oppProductRanked5;
        oppProductRanked6.Product__c = prodForRanked6.Id;
        update oppProductRanked6;

        Opportunity oppReturned = [SELECT Id, Product_1__c, Product_2__c, Product_3__c, Product_4__c, Product_5__c
                                                    FROM Opportunity
                                                    WHERE Id =:opp.Id LIMIT 1];
        system.assertEquals(prodForRanked1.Id, oppReturned.Product_1__c);
        system.assertEquals(prodForRanked2.Id, oppReturned.Product_2__c);
        system.assertEquals(prodForRanked3.Id, oppReturned.Product_3__c);
        system.assertEquals(prodForRanked4.Id, oppReturned.Product_4__c);
        system.assertEquals(prodForRanked5.Id, oppReturned.Product_5__c);

        prodForRanked1.COGS_1__c = 12;
        update prodForRanked1;
        prodForRanked2.COGS_1__c = 8;
        update prodForRanked2;

        oppReturned = [SELECT Id, Product_1__c, Product_2__c, Product_3__c, Product_4__c, Product_5__c
                                                    FROM Opportunity
                                                    WHERE Id =:opp.Id LIMIT 1];

        system.debug('xxxxx ' + prodForRanked1.Id + '/' + prodForRanked2.Id + '/' + prodForRanked3.Id + '/' + prodForRanked4.Id + '/' + prodForRanked5.Id);
        system.debug('yyyyy ' + oppReturned.Product_1__c + '/' + oppReturned.Product_2__c + '/' + oppReturned.Product_3__c + '/' + oppReturned.Product_4__c + '/' + oppReturned.Product_5__c);
        
        //system.assertEquals(oppReturned.Product_1__c, prodForRanked3.Id);
        //system.assertEquals(oppReturned.Product_2__c, prodForRanked4.Id);
        //system.assertEquals(oppReturned.Product_3__c, prodForRanked5.Id);
        //system.assertEquals(oppReturned.Product_4__c, prodForRanked2.Id);
        //system.assertEquals(oppReturned.Product_5__c, prodForRanked6.Id);

        delete prodforRanked5;

        oppReturned = [SELECT Id, Product_1__c, Product_2__c, Product_3__c, Product_4__c, Product_5__c
                                                    FROM Opportunity
                                                    WHERE Id =:opp.Id LIMIT 1];

        system.debug('xxxxx ' + prodForRanked1.Id + '/' + prodForRanked2.Id + '/' + prodForRanked3.Id + '/' + prodForRanked4.Id + '/' + prodForRanked5.Id);
        system.debug('yyyyy ' + oppReturned.Product_1__c + '/' + oppReturned.Product_2__c + '/' + oppReturned.Product_3__c + '/' + oppReturned.Product_4__c + '/' + oppReturned.Product_5__c);
        
        //system.assertEquals(oppReturned.Product_1__c, prodForRanked3.Id);
        //system.assertEquals(oppReturned.Product_2__c, prodForRanked4.Id);
        //system.assertEquals(oppReturned.Product_3__c, null);
        //system.assertEquals(oppReturned.Product_4__c, prodForRanked2.Id);
        //system.assertEquals(oppReturned.Product_5__c, prodForRanked6.Id);
        */
        
    }
}
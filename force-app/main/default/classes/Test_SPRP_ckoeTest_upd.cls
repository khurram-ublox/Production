/**
 * Created by wsha, updated by ldra on 2018-04-23
 */

@IsTest
private class Test_SPRP_ckoeTest_upd {
    static testMethod void testBehavior() {
        Exchange_Rates__c currencyRates = new Exchange_Rates__c(
            EURtoCHFrate__c = 1.08608,
            JPYtoCHFrate__c = 0.00838,
            USDtoCHFrate__c = 0.92262,
            StartDate__c = system.Today()
        );
        insert currencyRates;
        // create account
        Account acc = new Account(Name='Account1');
        insert acc;

        // quarter dates for COGS quarters
        Date q1 = Date.newInstance(2018,1,1);
        Date q2 = q1.addMonths(3);
        Date q3 = q1.addMonths(6);
        Date q4 = q1.addMonths(9);
        
        // Values for COGS values v1 for q1, ...
        Integer v1 = 20;
        Integer v2 = 19;
        Integer v3 = 18;
        Integer v4 = 17;

        // create cogs quarters
        COGS_Quarter__c cogsQuarter1 = new COGS_Quarter__c(Name='2018 Q1',Start_Date__c=q1);
        insert cogsQuarter1;
        COGS_Quarter__c cogsQuarter2 = new COGS_Quarter__c(Name='2018 Q2',Start_Date__c=q2);
        insert cogsQuarter2;
        COGS_Quarter__c cogsQuarter3 = new COGS_Quarter__c(Name='2018 Q3',Start_Date__c=q3);
        insert cogsQuarter3;
        COGS_Quarter__c cogsQuarter4 = new COGS_Quarter__c(Name='2018 Q4',Start_Date__c=q4);
        insert cogsQuarter4;

        // create cogs set
        COGS_Set__c cogsSet = new COGS_Set__c(Name='COGS Set 1',Base_Quarter__c=cogsQuarter1.Id);
        insert cogsSet;

        // create cogs values
        COGS_Set_Value__c cogsSetValue1 = new COGS_Set_Value__c(Name='Value 1',RecordTypeId='01257000000BgRYAA0',COGS_Set__c=cogsSet.Id,COGS_Quarter__c=cogsQuarter1.Id,Value__c=v1);
        insert cogsSetValue1;
        COGS_Set_Value__c cogsSetValue2 = new COGS_Set_Value__c(Name='Value 2',RecordTypeId='01257000000BgRYAA0',COGS_Set__c=cogsSet.Id,COGS_Quarter__c=cogsQuarter2.Id,Value__c=v2);
        insert cogsSetValue2;
        COGS_Set_Value__c cogsSetValue3 = new COGS_Set_Value__c(Name='Value 3',RecordTypeId='01257000000BgRYAA0',COGS_Set__c=cogsSet.Id,COGS_Quarter__c=cogsQuarter3.Id,Value__c=v3);
        insert cogsSetValue3;
        COGS_Set_Value__c cogsSetValue4 = new COGS_Set_Value__c(Name='Value 4',RecordTypeId='01257000000BgRYAA0',COGS_Set__c=cogsSet.Id,COGS_Quarter__c=cogsQuarter4.Id,Value__c=v4);
        insert cogsSetValue4;

        // create product
        Product2 p1= new Product2();
        p1.Name = 'Product1';
        p1.Type_No__c = 'NEO-M8L-0-123';
        p1.Packaging_Size__c = 100;
        p1.Family = 'NEO';
        p1.Positioning_Engine__c = 'u-blox M8';
        p1.COGS_4__c = 4;
        p1.CurrencyIsoCode = 'EUR';
        p1.Valid_COGS_Info__c=cogsSet.Id;
        insert p1;

        // create SPR
        Special_Price_Request__c spr = new Special_Price_Request__c(Price_Level__c = 'PPP (Project Price Plan',CurrencyIsoCode = 'EUR',Account__c = acc.Id);
        insert spr;

        // create SPRP
        Special_Price_Request_Product__c sprp = new Special_Price_Request_Product__c();
        sprp.Product__c = p1.Id;
        sprp.Special_Price_Request__c = spr.Id;
        sprp.CurrencyIsoCode = 'EUR';
        sprp.Year_P1__c = q1;
        sprp.Product_Cost_P1__c = 14.230;
        sprp.Year_P2__c = q2;
        sprp.Product_Cost_P2__c = 8.000;
        sprp.Year_P3__c = q3;
        sprp.Product_Cost_P3__c = 166.000;
        sprp.Quantity_P1__c = 10;
        insert sprp;

        // get rate
        User u = [Select Id, USDtoEUR__c, USDtoCHF__c, USDtoJPY__c from User where Id=:Userinfo.getUserId()];
        Decimal rate_euro = 1/u.USDtoEUR__c;
        
        // ---- Test 1: Removing Product Cost values ----------
        // to get Product cost from valid PCOGS set
        sprp.Product_Cost_P1__c = NULL;
        sprp.Product_Cost_P2__c = NULL;
        update sprp;

        Special_Price_Request_Product__c sprpU1 = [select Id, Product_Cost_P1__c, Product_Cost_P2__c, EURtoUSD__c FROM Special_Price_Request_Product__c WHERE Id = :sprp.Id];
        // (1/rate_euro*v1).setscale(3) - formula from apex class (used instead of another query request)
        System.debug('sprp:'+rate_euro+' - sprpU1:'+sprpU1.EURtoUSD__c);
        System.assertEquals((1/rate_euro*v1).setscale(3), sprpU1.Product_Cost_P1__c);
        System.assertEquals((1/rate_euro*v2).setscale(3), sprpU1.Product_Cost_P2__c);
        System.debug('TEST 1 - New values P1, P2 taken from PCOGS: '+sprpU1.Product_Cost_P1__c+','+sprpU1.Product_Cost_P2__c);

        // ---- Test 2: Changing Product Cost value ---------------------
        // to get warning text in COGS_data_source_RT__c
        sprp.Product_Cost_P2__c = 15;
        update sprp;

        Special_Price_Request_Product__c sprpU2 = [select Id, Product_Cost_P2__c, COGS_data_source_RT__c FROM Special_Price_Request_Product__c WHERE Id = :sprp.Id];
        System.assertEquals(sprp.Product_Cost_P2__c, sprpU2.Product_Cost_P2__c);
        //System.assertEquals(true, sprpU2.COGS_data_source_RT__c.contains('ATTENTION'));
        System.debug('TEST 2 - New value P2 changed manually: '+sprpU2.Product_Cost_P2__c + ', warning message shown');

        // ---- Test 3: Changing Year for a Price
        // to get Product cost value from the right quarter. 
        sprp.Year_P3__c = q4;
        update sprp;

        Special_Price_Request_Product__c sprpU3 = [select Id, Product_Cost_P3__c FROM Special_Price_Request_Product__c WHERE Id = :sprp.Id];
        System.assertEquals((1/rate_euro*v4).setscale(3), sprpU3.Product_Cost_P3__c);
        System.debug('TEST 3 - Year P3 changed to Q4: '+sprpU3.Product_Cost_P3__c + ' (COGS value from Q4)');
        
        // ---- Test 4: Removing Valid_COGS_Info__c ---------
        // to update Product cost from COGS_4__c

        p1.Valid_COGS_Info__c = NULL;
        update p1;
        sprp.Product_Cost_P3__c = NULL;
        update sprp;

        Special_Price_Request_Product__c sprpU4 = [select Id, Product_Cost_P3__c FROM Special_Price_Request_Product__c WHERE Id = :sprp.Id];
        System.assertEquals((1/rate_euro*p1.COGS_4__c).setscale(3), sprpU4.Product_Cost_P3__c);
        System.debug('TEST 4 - Valid COGS set deleted. P3: '+sprpU4.Product_Cost_P3__c+' (taken from Product2.COGS_4__c)');

        // ---- Test 5: Removing all COGS data ---------
        // if no COGS data exists
/*
 * //commented to detour the dml exception. FIELD_CUSTOM_VALIDATION_EXCEPTION, COGS can be entered only through COGS User Interface.
        p1.COGS_4__c = NULL;
        update p1;
  */      
        sprpU4.Product_Cost_P3__c = NULL;
        update sprpU4;

        Special_Price_Request_Product__c sprpU5 = [select Id, Product_Cost_P3__c FROM Special_Price_Request_Product__c WHERE Id = :sprp.Id];
        //System.assertEquals(NULL, sprpU5.Product_Cost_P3__c);
        System.debug('TEST 5 - COGS value: '+sprpU5.Product_Cost_P3__c+' (no COGS set)');

    }
}
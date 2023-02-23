/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest
private class OrdersWithFullContributionTest {
    static final string CRON_EXP = '0 0 1 * * ?';
    static final integer BATCH_SIZE = 100;
    static testMethod void TestFullContributionOrders() {
        a4x__app4forecast__c orgDefaults = a4x__app4forecast__c.getOrgDefaults();
        orgDefaults.a4x__Measure_Events_Active__c = True;
        orgDefaults.a4x__Forecast_Periods__c = 21;
        
        Account mainAccount = new Account(
            Name = 'Test main Acount'
        );        
        insert mainAccount;
              
        Account endCustomerAccount = new Account(
            Name = 'Test End Customer Account'
        );       
        insert endCustomerAccount;
                       
        Account projectOwnerAccount = new Account(
            Name = 'Test Project Owner Account'
        );       
        insert projectOwnerAccount;
                        
        Product2 prod011 = new Product2();
        prod011.Name = 'TEST-P001';
        prod011.ProductCode = 'TEST-P001-0';
        prod011.Type_No__c = 'TEST-P001-0-01';
        prod011.Use_Abacus_Cost__c = true;
        insert prod011;
        
        Product2 prod012 = new Product2();
        prod012.Name = 'TEST-P001';
        prod012.ProductCode = 'TEST-P001-0';
        prod012.Type_No__c = 'TEST-P001-0-02';
        insert prod012;
        
        // Insert
        Billings__c o = new Billings__c();
        o.Account__c = mainAccount.Id;
        o.End_Customer_Account__c = endCustomerAccount.Id;
        o.Project_Owner_Account__c = projectOwnerAccount.Id;
        o.Product__c = prod011.Id;      
        o.Delivery_Date__c = Date.today().addMonths(+2);
        o.Qty_Ordered__c = 100;
        o.Total_Value_CHF__c = 1000;
        o.Total_Gross_Value_CHF__c = 1000;
        
        insert o;
        list<Billings__c> orderStatusOpen = [SELECT Order_Status__c from Billings__c where Id =: o.Id];
        system.assert(orderStatusOpen.size() > 0);
        system.assertEquals('Open', orderStatusOpen[0].Order_Status__c);
        
        o.Qty_Invoiced__c = 100; 
        o.Invoice_Date__c = Date.today().addMonths(+1);
        o.Invoice_Number__c = 'ubx-003';
        o.Cost_CHF_Abacus__c = 5.50;
        update o;
        
        list<Billings__c> orderStatusClosed = [SELECT Order_Status__c from Billings__c where Id =: o.Id];
        system.assert(orderStatusClosed.size() > 0);
        system.assertEquals('Closed', orderStatusClosed[0].Order_Status__c);

        OrdersWithFullContribution fullContributionOrders = new OrdersWithFullContribution(); 
        database.executebatch(fullContributionOrders,BATCH_SIZE);

        CronJobDetail Job;
        try{
            Job = [Select c.Name, c.Id From CronJobDetail c where Name = 'Orders with 100% Contribution' limit 1];         
        }catch(QueryException ex){}
                        
        
        if(Job != null){
            CronTrigger CTrigger  = [SELECT Id FROM CronTrigger WHERE CronJobDetailId = :Job.Id];           
            if(CTrigger != null){
                System.abortJob(CTrigger.Id);   
            }
        }
        
        String jobId = system.schedule('Orders with 100% Contribution', CRON_EXP , new ScheduleOrdersWithFullContribution());
     
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);        
    }
}
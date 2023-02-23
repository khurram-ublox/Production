@isTest
public class OrderTriggerTest {
    @isTest
    static void orderInputUpdateDeleteTest() {
        
        a4x__app4forecast__c orgDefaults = a4x__app4forecast__c.getOrgDefaults();
        orgDefaults.a4x__Measure_Events_Active__c = True;
        
        Account acc001 = new Account();
        acc001.Name = 'Test ACC 001';
        insert acc001;
        
        Account acc002 = new Account();
        acc002.Name = 'Test ACC 002';
        insert acc002;
        
        Account eca001 = new Account();
        eca001.Name = 'Test ECA 001';
        insert eca001;
        
        Account eca002 = new Account();
        eca002.Name = 'Test ECA 002';
        insert eca002;
        
        Account poa001 = new Account();
        poa001.Name = 'Test POA 001';
        poa001.uB_Office__c = 'EMEA';
        insert poa001;
        
        Account poa002 = new Account();
        poa002.Name = 'Test POA 002';
        insert poa002;
        
        Product2 prod011 = new Product2();
        prod011.Name = 'TEST-P001';
        prod011.ProductCode = 'TEST-P001-0';
        prod011.Type_No__c = 'TEST-P001-0-01';
        insert prod011;
        
        Product2 prod012 = new Product2();
        prod012.Name = 'TEST-P001';
        prod012.ProductCode = 'TEST-P001-0';
        prod012.Type_No__c = 'TEST-P001-0-02';
        insert prod012;
        
        // Insert
        Billings__c o = new Billings__c();
        o.Account__c = acc001.Id;
        o.End_Customer_Account__c = eca001.Id;
        o.Project_Owner_Account__c = poa001.Id;
        o.Product__c = prod011.Id;
        o.Product__c = prod011.Id;
        o.Delivery_Date__c = Date.today().addMonths(+1);
        o.Qty_Ordered__c = 100;
        o.Total_Value_CHF__c = 1000;
        insert o;
        
        List<Billings__c> orders = [SELECT Id, a4a_Measure_Filter__c, a4a_Measure_Filter_Formula__c, a4a_Region__c From Billings__c];
        system.assertEquals(1, orders.size());
        system.assertEquals(orders[0].a4a_Measure_Filter_Formula__c, orders[0].a4a_Measure_Filter__c);
        
        // Filter Off due to change of the Delivery Date into the past
        o.Delivery_Date__c = Date.today().addMonths(-1);
        update o;
        
        orders = [SELECT Id, a4a_Measure_Filter__c, a4a_Measure_Filter_Formula__c, a4a_Region__c From Billings__c];
        system.assertEquals(1, orders.size());
        system.assertEquals(orders[0].a4a_Measure_Filter_Formula__c, orders[0].a4a_Measure_Filter__c);
        
        // Filter On due to change of the Delivery Date into the future
        o.Delivery_Date__c = Date.today().addMonths(+3);
        update o;
        
        orders = [SELECT Id, a4a_Measure_Filter__c, a4a_Measure_Filter_Formula__c, a4a_Region__c From Billings__c];
        system.assertEquals(1, orders.size());
        system.assertEquals(orders[0].a4a_Measure_Filter_Formula__c, orders[0].a4a_Measure_Filter__c);
        
        
        // Order Dimensions Changed - leading to a new Key
        o.Project_Owner_Account__c = poa002.Id;
        update o;
        
        orders = [SELECT Id, a4a_Measure_Filter__c, a4a_Measure_Filter_Formula__c, a4a_Region__c From Billings__c];
        system.assertEquals(1,orders.size());
        system.assertEquals(orders[0].a4a_Measure_Filter_Formula__c, orders[0].a4a_Measure_Filter__c);
        
        // Updates With Unchanged Dimensions
        o.Qty_Ordered__c = 500;
        update o;
        
        orders = [SELECT Id, a4a_Measure_Filter__c, a4a_Measure_Filter_Formula__c From Billings__c];
        system.assertEquals(1, orders.size());
        system.assertEquals(orders[0].a4a_Measure_Filter_Formula__c, orders[0].a4a_Measure_Filter__c);
        
        // Delete
        delete o;
        orders = [SELECT Id, a4a_Measure_Filter__c, a4a_Measure_Filter_Formula__c From Billings__c];
        system.assertEquals(0, orders.size());        
        
    }
}
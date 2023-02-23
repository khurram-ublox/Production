/*
    Created by Ben Mansfield - 23/02/2010
    Changed by Werner Grätzer - 12/12/2012 / Request Herber Blaser 11/12/2012
    - replaced "Reporting_uB_Office__c" by "Project_Owner_uB_Office__c"
    Changed by Werner Grätzer - 19/04/2013 / Request Herbert Blaser 18/04/2013 / PRN-070542
    - replaced "Project_Owner_uB_Office__c" by "Project_Owner_Account_ID__c"
    
    Matches 'Project_Owner_Account_ID__c' field on Billings__c to the 'Project_Owner_Account_ID__c' field on
    a Contribution_Share__c record related to the same Account.

    2018.04.12 :khir: - End Customer, Product Name and Approval Status added for matching. Test cases also added.

*/
public with sharing class BillingsTrigger {
    
    public static void updateContributionShareOnBillings(List<Billings__c> updatedOrders, Map<Id, Billings__c> oldRecords)
    {
        List<Billings__c> ordersRequiringCSUpdate = new List<Billings__c>();
        Set<Id> accounts = new Set<Id>();
     
        // Loop through orders
        for (Billings__c order : updatedOrders)
        {
            // If order requires update
            if ((order.Order_Status__c == 'Closed' && (oldRecords == null || oldRecords.get(order.Id).Order_Status__c != order.Order_Status__c)) || order.Update_CS__c || order.Calculate_Total_COGS_CHF__c)
            {
                // Add orders to list
                ordersRequiringCSUpdate.add(order);
                // Add related account id to set
                accounts.add(order.Account__c);
                
                // Reset update CS flag
                order.Update_CS__c = false;
                // Set flag to calculate contribution split
                //order.Calculate_Contribution_Split__c = true;
            }
        }
        
        if (ordersRequiringCSUpdate.size() > 0) updateCS(ordersRequiringCSUpdate, accounts);
    }
    
    private static void updateCS(List<Billings__c> ordersToUpdate, Set<Id> targetAccounts)
    {
        // Get all accounts related to the orders including all of the contribution share related records 
        Map<Id, Account> accountDetails = new Map<Id, Account>([Select Id, 
                                        (Select Id, Project_Owner_Account_ID__c, End_Customer_Account_ID__c, Product_Name__c, Status__c From Contribution_Share__r)
                                        From Account Where Id in :targetAccounts]);

        System.debug('accountDetails:'+accountDetails);
        
        // Loop through orders
        for (Billings__c order : ordersToUpdate)
        {
            // Set Contribution Share field to null
            order.Contribution_Share__c = null;
            // If there is an account related to this order
            if (accountDetails.containsKey(order.Account__c))
            {
                // Get account
                Account target = accountDetails.get(order.Account__c);
                // Match order fields to contribution share
                Contribution_Share__c match = matchReportinguBOffice(order, target);
                // If there was a match, add record id to lookup field
                if (match != null) order.Contribution_Share__c = match.Id;
            }
        }
    }
    
    private static Contribution_Share__c matchReportinguBOffice(Billings__c order, Account relatedAccount)
    {
        // If the order record has no matchable fields - return null
        if (order.Project_Owner_Account_ID__c == null || order.Project_Owner_Account_ID__c == '') return null;
        // Loop through all contribution share records for this account
        for (Contribution_Share__c cs : relatedAccount.Contribution_Share__r)
        {
            // If this contribution share has no matchable fields, go to next record
            if (cs.Project_Owner_Account_ID__c == null || cs.Project_Owner_Account_ID__c == '' || cs.End_Customer_Account_ID__c == '' || cs.End_Customer_Account_ID__c == null) continue;

            // Try to match the contribution share field with the order field of the same name
            // 2018.04.12 :khir: End Customer, Product Name and Approval Status added for matching
            if (cs.Project_Owner_Account_ID__c == order.Project_Owner_Account_ID__c && cs.End_Customer_Account_ID__c == order.End_Customer_Account_ID__c && cs.Product_Name__c == order.Product_Name__c && cs.Status__c == 'Activated') return cs;
        }
        
        // No matches found here
        return null;
    }
    


//     @IsTest
//     private static void basictest()
//     {

// // 		List<Account> iAccounts = new list<Account>();
// // 		List<Product2> iProducts = new list<Product2>();

// //         Account acc = new Account();
// //         acc.Name = 'Test Account';
// // 		iAccounts.add(acc);
        
// //         Account ac2 = new Account();
// //         ac2.Name = 'Project Owner Test';
// //         iAccounts.add(ac2);

// // // :khir: 2018.03.19 added

// //         Account acc001 = new Account();
// //         acc001.Name = 'Test ACC 001';
// // 		iAccounts.add(acc001);

// //         Account acc002 = new Account();
// //         acc002.Name = 'Test ACC 002';
// // 		iAccounts.add(acc002);

// //         Account eca001 = new Account();
// //         eca001.Name = 'Test ECA 001';
// // 		iAccounts.add(eca001);

// //         Account eca002 = new Account();
// //         eca002.Name = 'Test ECA 002';
// // 		iAccounts.add(eca002);

// //         Account poa001 = new Account();
// //         poa001.Name = 'Test POA 001';
// // 		iAccounts.add(poa001);

// // 		insert iAccounts ;


// //         Product2 prod011 = new Product2();
// //         prod011.Name = 'TEST-P001';
// //         prod011.ProductCode = 'TEST-P001-0';
// //         prod011.Type_No__c = 'TEST-P001-0-01';
// // 		iProducts.add(prod011);

// //         Product2 prod012 = new Product2();
// //         prod012.Name = 'TEST-P001';
// //         prod012.ProductCode = 'TEST-P001-0';
// //         prod012.Type_No__c = 'TEST-P001-0-02';
// // 		iProducts.add(prod012);

// //         Product2 prod021 = new Product2();
// //         prod021.Name = 'TEST-P002';
// //         prod021.ProductCode = 'TEST-P002-0';
// //         prod021.Type_No__c = 'TEST-P002-0-01';
// // 		iProducts.add(prod021);

// //         Product2 prod022 = new Product2();
// //         prod022.Name = 'TEST-P002';
// //         prod022.ProductCode = 'TEST-P002-0';
// //         prod022.Type_No__c = 'TEST-P002-0-02';
// // 		iProducts.add(prod022);

// //         Product2 prod031 = new Product2();
// //         prod031.Name = 'TEST-P003';
// //         prod031.ProductCode = 'TEST-P003-0';
// //         prod031.Type_No__c = 'TEST-P003-0-01';
// // 		iProducts.add(prod031);

// // 		insert iProducts;


// //         Contribution_Share__c cs = new Contribution_Share__c();
// //         cs.Account__c = acc.Id;
// //         cs.Project_Owner_Account__c = ac2.Id;
// //         insert cs;


// //         Billings__c order_acc001 = new Billings__c();
// //         order_acc001.Account__c = acc001.Id;
// //         order_acc001.End_Customer_Account__c = eca001.Id;
// //         order_acc001.Project_Owner_Account__c = poa001.Id;
// //         order_acc001.Product__c = prod011.Id;
// //         insert order_acc001;

// // // :khir: 2018.03.19 added END
        
// //         Billings__c order = new Billings__c();
// //         order.Account__c = acc.Id;
// //         order.Reporting_Area__c = 'TW';
// //         order.Project_Owner_Account__c = ac2.Id;
// //         order.Update_CS__c = true;
// // 		insert order;

        
// // // :khir: 2018.03.19 commented
// // //        order = [Select Id, Project_Owner_uB_Office__c, Project_Owner_Account__c, Contribution_Share__c From Billings__c Where Id = :order.Id Limit 1][0];
// // //        
// // //        System.assertEquals(cs.Project_Owner_Account__c, order.Project_Owner_Account__c);
// // //        System.assertEquals(cs.Id, order.Contribution_Share__c);
// // // :khir: 2018.03.19 commented END


// // // :khir: 2018.03.19 added
        
// // // Test 1.01
// //         order_acc001.Update_CS__c = true;
// //         update order_acc001;

// //         Billings__c DUT_order = [SELECT Id, Project_Owner_uB_Office__c, Project_Owner_Account__c, Contribution_Share__c From Billings__c Where Id = :order_acc001.Id Limit 1];
// //         System.assertEquals(null, DUT_order.Contribution_Share__c);

// // // Test 1.04 - All the fields match and there is not approved CS
// //         Contribution_Share__c cs001 = new Contribution_Share__c();
// //         cs001.Account__c = acc001.Id;
// //         cs001.End_Customer__c = eca001.Id;
// //         cs001.Project_Owner_Account__c = poa001.Id;
// //         cs001.Product__c = prod011.Id;
// // //        cs001.Status__c = 'Activated';
// //         insert cs001;

// //         order_acc001.Update_CS__c = true;
// //         update order_acc001;
// //         DUT_order = [SELECT Id, Project_Owner_uB_Office__c, Project_Owner_Account__c, Contribution_Share__c From Billings__c Where Id = :order_acc001.Id Limit 1];
// //         System.assertEquals(null, DUT_order.Contribution_Share__c);

// // // Test 1.02
// //         cs001.Status__c = 'Activated';
// //         Update cs001;

// //         order_acc001.Update_CS__c = true;
// //         update order_acc001;

// //         DUT_order = [SELECT Id, Project_Owner_uB_Office__c, Project_Owner_Account__c, Contribution_Share__c From Billings__c Where Id = :order_acc001.Id Limit 1];
// //         System.assertEquals(cs001.Id, DUT_order.Contribution_Share__c);

// // // Test 1.03
// //         order_acc001.Product__c = prod012.Id;
// //         order_acc001.Update_CS__c = true;
// //         update order_acc001;

// //         DUT_order = [SELECT Id, Project_Owner_uB_Office__c, Project_Owner_Account__c, Contribution_Share__c From Billings__c Where Id = :order_acc001.Id Limit 1];
// //         System.assertEquals(cs001.Id, DUT_order.Contribution_Share__c);

// // // Test 1.05 - All the fields except Product match.
// //         order_acc001.Product__c = prod031.Id;
// //         order_acc001.Update_CS__c = true;
// //         update order_acc001;

// //         DUT_order = [SELECT Id, Project_Owner_uB_Office__c, Project_Owner_Account__c, Contribution_Share__c From Billings__c Where Id = :order_acc001.Id Limit 1];
// //         System.assertEquals(null, DUT_order.Contribution_Share__c);

// // // Test 1.06 - All the fields except End Customer match.
// //         order_acc001.Product__c = prod011.Id;
// //         order_acc001.End_Customer_Account__c = eca002.Id;
// //         order_acc001.Update_CS__c = true;
// //         update order_acc001;

// //         DUT_order = [SELECT Id, Project_Owner_uB_Office__c, Project_Owner_Account__c, Contribution_Share__c From Billings__c Where Id = :order_acc001.Id Limit 1];
// //         System.assertEquals(null, DUT_order.Contribution_Share__c);

// // // Test 1.07 - All the fields except Account match.
// //         cs001.Account__c = acc002.Id;
// //         Update cs001;

// //         order_acc001.End_Customer_Account__c = eca001.Id;
// //         order_acc001.Update_CS__c = true;
// //         update order_acc001;

// //         DUT_order = [SELECT Id, Project_Owner_uB_Office__c, Project_Owner_Account__c, Contribution_Share__c From Billings__c Where Id = :order_acc001.Id Limit 1];
// //         System.assertEquals(null, DUT_order.Contribution_Share__c);

// // // Test 1.08 - All the fields except Project Owner Account match.
// //         cs001.Account__c = acc001.Id;
// //         Update cs001;

// //         order_acc001.Project_Owner_Account__c = eca002.Id;
// //         order_acc001.Update_CS__c = true;
// //         update order_acc001;

// //         DUT_order = [SELECT Id, Project_Owner_uB_Office__c, Project_Owner_Account__c, Contribution_Share__c From Billings__c Where Id = :order_acc001.Id Limit 1];
// //         System.assertEquals(null, DUT_order.Contribution_Share__c);

// // :khir: 2018.03.19 added END

//         	System.assertEquals(true, true);
//     }
}
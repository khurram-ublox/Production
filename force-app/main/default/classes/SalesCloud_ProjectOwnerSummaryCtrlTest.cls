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
@isTest
private class SalesCloud_ProjectOwnerSummaryCtrlTest {
    
    static final Product2 cellularProduct;    
    static final Account projectOwnerAccount;
    static final Account orderAccount;
    static final Account endCustomerAccount;
    static final Billings__c Order1;
    static final Billings__c Order2;
    static final Billings__c Order3;
    
    static{        
       
        a4x__app4forecast__c orgDefaults = a4x__app4forecast__c.getOrgDefaults();
        orgDefaults.a4x__Measure_Events_Active__c = true;
        orgDefaults.a4x__Forecast_Periods__c = 21;
        
        orderAccount = new Account(
            Name = 'Test ACC 001',
            uB_Office__c = 'EMEA'
        );
        database.insert(orderAccount);

        endCustomerAccount = new Account(
            Name = 'Test ACC 001',
            uB_Office__c = 'EMEA'
        );
        database.insert(endCustomerAccount);

        projectOwnerAccount = new Account(
            Name = 'Test POA 001',
            uB_Office__c = 'EMEA'
        );
        database.insert(projectOwnerAccount);

        cellularProduct = new Product2(
            Name='TOBY-L201 quote',
            BusinessUnit__c = 'u-blox', 
            Type_No__c='TOBY-L201-02S-01-q', 
            Product_Center__C='Cellular'
        ); 
        database.insert(cellularProduct);
       
        Order1 = new Billings__c(
            Account__c = projectOwnerAccount.Id,
            End_Customer_Account__c = endCustomerAccount.Id,
            Project_Owner_Account__c = projectOwnerAccount.Id,
            Product__c = cellularProduct.Id,           
            Delivery_Date__c = Date.today().addMonths(+1),
            Qty_Ordered__c = 100,
            Qty_Invoiced__c = 100,  
            Total_Value_CHF__c = 50000,
            Total_COGS_CHF__c = 25000
        );
        database.insert(Order1);

        Order2 = new Billings__c(
            Account__c = projectOwnerAccount.Id,
            End_Customer_Account__c = endCustomerAccount.Id,
            Project_Owner_Account__c = projectOwnerAccount.Id,
            Product__c = cellularProduct.Id,           
            Delivery_Date__c = Date.today().addMonths(-2),
            Qty_Ordered__c = 10,
            Qty_Invoiced__c = 10, 
            Total_Value_CHF__c = 5000,
            Total_COGS_CHF__c = 2500,
            Invoice_Date__c = Date.today().addMonths(-7),
            Invoice_Number__c = '2'
        );
        database.insert(Order2);

        Order3 = new Billings__c(
            Account__c = projectOwnerAccount.Id,
            End_Customer_Account__c = endCustomerAccount.Id,
            Project_Owner_Account__c = projectOwnerAccount.Id,
            Product__c = cellularProduct.Id,           
            Delivery_Date__c = Date.today().addMonths(+5),
            Qty_Ordered__c = 50,
            Qty_Invoiced__c = 50, 
            Total_Value_CHF__c = 15000,
            Total_COGS_CHF__c = 5000,
            Invoice_Date__c = Date.today().addMonths(+3),
            Invoice_Number__c = '3'
        );
        database.insert(Order3);
    }

    static testMethod void TestProjectOwnerAccountSummary() {
        // TO DO: implement unit test
        SalesCloud_ProjectOwnerSummaryCtrl.getAccountSummary(projectOwnerAccount.Id);
    }
}
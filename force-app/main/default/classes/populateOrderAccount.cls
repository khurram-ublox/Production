public with sharing class populateOrderAccount {
    
    /*
    Created by: Werner Grätzer / CR-0147 based on CR-0048
    Created Date: 09th July 2012
    
    Version: 1.0
    Last Modified Date: 09th July 2012
    */
    public static TestMethod void test()
    {
        Account a = new Account();
        a.Name = 'Test Acc';
        insert a;
        
       
        Billings__c b = new Billings__c();
        b.Name = 'Test Billing';
        b.Account__c = a.Id;
        
        Test.startTest();
            insert b;
        Test.stopTest();
        
        Billings__c updatedBilling = [Select Id, Name, End_Customer_Account__c From Billings__c Where Id = :b.Id Limit 1][0];
        
        //System.assertEquals(a.Id, updatedBilling.End_Customer_Account__c);
        

    }
    /*
    Create a list of the billings that have the state where they need to be updated and pass to the execute method
    */
    public static void execute(List<Billings__c> newBillings, Map<Id, Billings__c> oldBillings){
            
        List<Billings__c> toUpdate = new List<Billings__c>(); 
        for(Billings__c newBilling : newBillings){
            Billings__c oldBilling = (Billings__c)oldBillings.get(newBilling.Id);
            
            if(oldBilling != null &&    //check that the old one exists - should do but you never know...
                newBilling.End_Customer_Account__c == null    //check if the End Customer field in the newBilling is empty
                )
            toUpdate.add(newBilling);
        }
        
        if(toUpdate.size() > 0)    //if there are some records that need processing then use the existing method.
            execute(toUpdate);
        
    }
    
    public static void execute(List<Billings__c> billings)
    {
       
        Set<Id> accountIds = new Set<Id>();
        // Loop through all new Billings
        for (Billings__c b : billings)
        {
            // For every Billing with an account id
            if (b.Account__c != null)
            {
                // Add the account id to set
                accountIds.add(b.Account__c);
            }
        }
        
        // Query all accounts associated with the new Billing
        Map<Id, Account> associatedAccounts = new Map<Id, Account>([Select Id From Account Where Id in :accountIds]);
        
        // Loop through all Billings again
        for (Billings__c b : billings)
        {
            // If the End Customer Account field is empty and this Billing
            // is associated with an account
            if (b.End_Customer_Account__c == null && associatedAccounts.containsKey(b.Account__c))
            {
                // Get the account
                Account a = associatedAccounts.get(b.Account__c);
                
                // Update End Customer Account
                
                b.End_Customer_Account__c = a.Id;

            }           
        }
    }
}
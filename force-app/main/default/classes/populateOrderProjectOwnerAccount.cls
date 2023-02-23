public with sharing class populateOrderProjectOwnerAccount {
    
    /*
    Created by: Werner Grätzer 12/12/2012
    
    */
    public static TestMethod void test()
    {
        Account a = new Account();
        a.Name = 'Test Acc';
        insert a;
        
       
        Billings__c b = new Billings__c();
        b.Name = 'Test Billing';
        b.Account__c = a.Id;
        b.End_Customer_Account__c = a.Id;
        
        Test.startTest();
            insert b;
        Test.stopTest();
        
        Billings__c updatedBilling = [Select Id, Name, Project_Owner_Account__c From Billings__c Where Id = :b.Id Limit 1][0];
        
        //System.assertEquals(a.Id, updatedBilling.Project_Owner_Account__c);
        

    }
    /*
    Create a list of the billings that have the state where they need to be updated and pass to the execute method
    */
    public static void execute(List<Billings__c> newBillings, Map<Id, Billings__c> oldBillings){
                
        List<Billings__c> toUpdate = new List<Billings__c>(); 
        for(Billings__c newBilling : newBillings){
            Billings__c oldBilling = (Billings__c)oldBillings.get(newBilling.Id);
            
            if(oldBilling != null &&    //check that the old one exists - should do but you never know...
                newBilling.Project_Owner_Account__c == null    //check if the End Customer field in the newBilling is empty
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
            // For every Billing with an end customer id
            if (b.End_Customer_Account__c != null)
            {
                // Add the account id to set
                accountIds.add(b.End_Customer_Account__c);
            }
            // For those without an end customer id
            else if (b.Account__c != null)
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
            // is associated with an end customer account
            if (b.Project_Owner_Account__c == null && associatedAccounts.containsKey(b.End_Customer_Account__c))
            {
                // Get the account
                Account a = associatedAccounts.get(b.End_Customer_Account__c);
                
                // Update Project Owner Account
                
                b.Project_Owner_Account__c = a.Id;

            }
            // If the End Customer Account field is empty and this Billing
            // is associated with an account
            else if (b.Project_Owner_Account__c == null && associatedAccounts.containsKey(b.Account__c))
            {
                // Get the account
                Account a = associatedAccounts.get(b.Account__c);
                
                // Update Project Owner Account
                
                b.Project_Owner_Account__c = a.Id;

            }            
        }
    }
}
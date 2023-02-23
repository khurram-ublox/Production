public with sharing class populateOpportunityAccount {
    
    /*
    Created by: Ben Mansfield
    Created Date: 29th July 2009
    
    Version: 1.0
    Last Modified Date: 31st July 2009 
    */
/*
2016.04.07 khir: Added Description of new Opportunity creation for update of updateStatusOnOppProduct.apxt
*/
    
    public static void execute(List<Opportunity> opps)
    {
        // Get Opportunity record type
        List<RecordType> recordTypes = [Select Id, Name From RecordType Where SObjectType = 'Opportunity' and Name = 'Opportunity' Limit 1];
        
        // If we cannot find the correct record type, exit function
        if (recordTypes.size() != 1) return;
        RecordType rt = recordTypes.get(0);
        
        Set<Id> accountIds = new Set<Id>();
        // Loop through all new opportunities
        for (Opportunity o : opps)
        {
            // For every opportunity with an account id
            if (o.AccountId != null)
            {
                // Add the account id to set
                accountIds.add(o.AccountId);
            }
        }
        
        // Query all accounts associated with the new opportunities
        Map<Id, Account> associatedAccounts = new Map<Id, Account>([Select Id, FAE__c, Name, 
                                                New_Application_Type__c, New_Market__c 
                                                From Account Where Id in :accountIds]);
        
        // Loop through all opportunities again
        for (Opportunity o : opps)
        {
            // If the opportunity account field is empty and this opportunity
            // is associated with an account
            if (o.RecordTypeId == rt.Id && associatedAccounts.containsKey(o.AccountId))
            {
                // Get the account
                Account a = associatedAccounts.get(o.AccountId);
                
                // Update other account fields
                if(o.Opportunity_Account__c == null) o.Opportunity_Account__c = a.Id;
                if(o.FAE__c == null) o.FAE__c = a.FAE__c;
                if(o.New_Application_Type__c == null) o.New_Application_Type__c = a.New_Application_Type__c;
                if(o.New_Market__c == null) o.New_Market__c = a.New_Market__c;	

            }
            system.debug(o.FAE__c);
        }
    }
}
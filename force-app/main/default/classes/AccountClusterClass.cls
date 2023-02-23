public class AccountClusterClass
{
    public static void updateClusterAfterUpdate(Map<Id, Account> updatedAccounts, Map<Id, Account> oldAccounts)
    {
        // List of accounts to update
        List<Account> accountsToUpdate = new List<Account>();
        
        // Full update records - stores records that require parent and child cluster field updates
        Map<Id, Account> requiresFullUpdate = new Map<Id, Account>();
        Set<Id> fullUpdateParentIds = new Set<Id>();
        
        // Child update records - stores records that require only child cluster field updates
        Map<Id, accountChildContainer> requiresChildUpdate = new Map<Id, accountChildContainer>();
        // Loop through all updated account records
        for (Account acc : updatedAccounts.values())
        {
            // If the parent id has changed or the name has changed
            if (acc.ParentId != oldAccounts.get(acc.Id).ParentId || acc.Name != oldAccounts.get(acc.Id).Name)
            {
                // Request a full update
                requiresFullUpdate.put(acc.Id, acc);
                fullUpdateParentIds.add(acc.ParentId);
            }
            // If only the cluster account has changed
            else if (acc.Cluster_Account__c != oldAccounts.get(acc.Id).Cluster_Account__c)
            {
                // Request child update
                requiresChildUpdate.put(acc.Id, new accountChildContainer(acc, acc.Cluster_Account__c));
            }
        }
        
        // Get the child records from full and child lists, sort the records into an easy to use map - <ParentId, listOfChildren>
        Map<Id, List<Account>> listOfAccountChildrenFull = new Map<Id, List<Account>>();
        if (requiresFullUpdate.size() > 0) listOfAccountChildrenFull = mapChildren([Select Id, Name, Cluster_Account__c, ParentId From Account Where ParentId in :requiresFullUpdate.keySet() Order By ParentId ASC]);
        
        Map<Id, List<Account>> listOfAccountChildrenPartial = new Map<Id, List<Account>>();
        if (requiresChildUpdate.size() > 0) listOfAccountChildrenPartial = mapChildren([Select Id, Name, Cluster_Account__c, ParentId From Account Where ParentId in :requiresChildUpdate.keySet() Order By ParentId ASC]);
        
        // Get the new parent records from full update list - make sure there are full update records to process
        Map<Id, Account> fullUpdateParentRecords = null;
        if (fullUpdateParentIds.size() > 0) fullUpdateParentRecords = new Map<Id, Account>([Select Id, Name, Cluster_Account__c From Account Where Id in :fullUpdateParentIds]);
        
        // Loop through full update records
        Set<Id> checkOldParentAccounts = new Set<Id>();
        for (Account acc : requiresFullUpdate.values())
        {
            String clusterName = null;
            
            // If the old account has a parent id
            if (oldAccounts.get(acc.Id).ParentId != null)
            {
                // Put the old parent id in a list for later processing
                checkOldParentAccounts.add(oldAccounts.get(acc.Id).ParentId);
            }
            
            // If new account has a parent id
            if (acc.ParentId != null)
            {
                // Get the new parent from list of parent records
                Account parent = fullUpdateParentRecords.get(acc.ParentId);
                // If the new parent has cluster account data - i.e. has a parent
                if (parent.Cluster_Account__c != null)
                {
                    // Make cluster name equal to new parent cluster account field
                    clusterName = parent.Cluster_Account__c;
                }
                else
                {
                    // Else, make cluster name the new parent name and add parent to update list
                    clusterName = parent.Name;
                    parent.Cluster_Account__c = clusterName;
                    accountsToUpdate.add(parent);
                }
            }
            // If new account does not have a parent
            else
            {
                // If there are children in the full update children account list
                if (listOfAccountChildrenFull.get(acc.Id) != null && listOfAccountChildrenFull.get(acc.Id).size() != 0)
                {
                    // Make cluster name the new record name
                    clusterName = acc.Name;
                }
            }
            
            // Add new account to update list if the cluster account field needs updating
            if (acc.Cluster_Account__c != clusterName) accountsToUpdate.add(new Account(Id=acc.Id, Cluster_Account__c=clusterName));
            
            // Converts this full update into a partial child update - child updates are done later on
            requiresChildUpdate.put(acc.Id, new accountChildContainer(acc, clusterName));
            listOfAccountChildrenPartial.put(acc.Id, listOfAccountChildrenFull.get(acc.Id));
        }
        
        // CHECK OLD PARENT ACCOUNTS
        Map<Id, Account> oldParentAccounts = null;
        // If the check old parent list is not empty, query the old parents
        if (checkOldParentAccounts.size() > 0) oldParentAccounts = new Map<Id, Account>([Select Id, Name, Cluster_Account__c From Account Where Id in :checkOldParentAccounts]);
        
        // If old parent accounts are found
        Map<Id, List<Account>> oldParentChildCount = new Map<Id, List<Account>>();
        if (oldParentAccounts != null)
        {
            // Get mapped old parent children
            if (oldParentAccounts != null && oldParentAccounts.size() > 0) oldParentChildCount = mapChildren([Select Id, Name, Cluster_Account__c, ParentId From Account Where ParentId in :oldParentAccounts.keySet() Order By ParentId]);
            
            // Loop through all old parents
            for (Account parent : oldParentAccounts.values())
            {
                // If old parent cluster account equals old parent name (i.e. at the top of the hierarchy)
                if (parent.Cluster_Account__c!= null && parent.Cluster_Account__c.contains(parent.Name))
                {
                    // If old parent has no children
                    if (!oldParentChildCount.containsKey(parent.Id) || oldParentChildCount.get(parent.Id).size() == 0)
                    {
                        // Parent cluster equals null, add to update list
                        parent.Cluster_Account__c = null;
                        accountsToUpdate.add(parent);
                    }
                }
            }
        }
        
        // Update all children and add to update list
        accountsToUpdate.addAll(updateChildClusterValues(requiresChildUpdate.values(), listOfAccountChildrenPartial));
        
        // Check that the accounts added to this list actually require an update - A better way would be to prevent accounts being added if they don't change
        Set<Id> accountIds = new Set<Id>();
        // Loop through all accounts to update and add id to set
        for (Account a : accountsToUpdate) accountIds.add(a.Id);
        
        // Get all current account data
        Map<Id, Account> oldAccountData = new Map<Id, Account>([Select Id, Name, Cluster_Account__c, ParentId From Account Where Id in :accountIds]);
        
        List<Account> removedAccounts = new List<Account>();
        List<Account> actualUpdates = new List<Account>();
        // Loop through all accounts again
        for (Account a : accountsToUpdate)
        {
            // If the current account data is equal to the account data that needs updating, remove from update list
            if (a.Name == oldAccountData.get(a.Id).Name && a.Cluster_Account__c == oldAccountData.get(a.Id).Cluster_Account__c && a.ParentId == oldAccountData.get(a.Id).ParentId)
            {
                removedAccounts.add(a); // Used for debugging
            }
            else
            {
                actualUpdates.add(a);
            }
        }
        
        System.debug('----------------DEBUGDATA---------------------- ACCOUNTS TO UPDATE: ' + actualUpdates + ' ----------------DEBUGDATA---------------------- ');
        System.debug('----------------DEBUGDATA---------------------- ACCOUNTS REMOVED: ' + removedAccounts + ' ----------------DEBUGDATA---------------------- ');
        
        // Update all accounts
        update actualUpdates;
    }
    
    // Run after delete - sorts out the parent accounts for deleted records
    public static void updateAccountClusterAfterDelete(Map<Id, Account> oldAccounts)
    {
        List<Account> accountsToUpdate = new List<Account>();
        // lookup parent account; check parent children - if none, cluster_account__c = null
        
        // Loop through all old accounts
        Set<Id> parentIds = new Set<Id>();
        for (Account acc : oldAccounts.values())
        {
            // If old account has a parent, add to parent list
            if (acc.ParentId != null) parentIds.add(acc.ParentId);
        }
        
        Map<Id, Account> parents = new Map<Id, Account>([Select Id, Name, ParentId From Account Where Id in :parentIds]);
        
        // Get a list of mapped children for parent accounts
        Map<Id, List<Account>> listOfAccountChildren;
        if (parents.size() > 0) listOfAccountChildren = mapChildren([Select Id, Name, ParentId From Account Where ParentId in :parents.keySet() Order By ParentId ASC]);
        
        // Loop through all parents
        for (Account parent : parents.values())
        {
            // If parent account has no children
            if (!listOfAccountChildren.containsKey(parent.Id) || listOfAccountChildren.get(parent.Id).size() == 0)
            {
                // Make parent account cluster field equal to null, add to update list
                if (parent.ParentId == null)
                {
                    parent.Cluster_Account__c = null;
                    accountsToUpdate.add(parent);
                }
                
            }
        }
        
        // Update all accounts
        update accountsToUpdate;
    }
    
    // Run before delete - sorts out all child accounts for deleted records
    public static void updateAccountClusterBeforeDelete(Map<Id, Account> oldAccounts)
    {
        List<Account> accountsToUpdate = new List<Account>();
        
        // Get a list of children for deleted accounts
        Map<Id, Account> listOfDeletedAccountChildren = new Map<Id, Account>([Select Id, Name, Cluster_Account__c, ParentId From Account Where ParentId in :oldAccounts.keySet() Order By ParentId ASC]);
        
        // Get a map of child accounts for the list of children and loop through list of children
        Map<Id, List<Account>> listOfChildrenChildren = mapChildren([Select Id, Name, Cluster_Account__c, ParentId From Account Where ParentId in :listOfDeletedAccountChildren.keySet() Order By ParentId ASC]);
        for (Account acc : listOfDeletedAccountChildren.values())
        {
            // If the child account has no children
            if (!listOfChildrenChildren.containsKey(acc.Id) || listOfChildrenChildren.get(acc.Id).size() == 0)
            {
                // Make child account cluster field equal to null, add to update list
                acc.Cluster_Account__c = null;
                accountsToUpdate.add(acc);
            }
            // If child account has children
            else
            {
                // Make child account cluster field equal to child account name
                acc.Cluster_Account__c = acc.Name;
                // Add child account to update list
                accountsToUpdate.add(acc);
                // Loop through child account children
                for (Account child : listOfChildrenChildren.get(acc.Id))
                {
                    // Make children equal to parent cluster account, add to update list
                    child.Cluster_Account__c = acc.Cluster_Account__c;
                    accountsToUpdate.add(child);
                }
            }
        }
        
        // Update all records that require updating
        update accountsToUpdate;
    }
    
    // HELPER FUNCTIONS
    private static Map<Id, List<Account>> mapChildren(List<Account> listOfChildren)
    {
        Map<Id, List<Account>> mappedChildren = new Map<Id, List<Account>>();
        
        Id currentId = null;
        if (listOfChildren != null)
        {
            // Loop through all children
            for (Account child : listOfChildren)
            {
                // If parent id not equal to current id
                if (currentId != child.ParentId)
                {
                    // Make parent id equal to current id
                    currentId = child.ParentId;
                    // Create a new entry in the map
                    mappedChildren.put(child.ParentId, new List<Account>());
                }
                // Add child to list of accounts in map
                mappedChildren.get(currentId).add(child);
            }
        }
        
        // Return mapped children
        return mappedChildren;
    }
    
    private static Account[] updateChildClusterValues(accountChildContainer[] records, Map<Id, List<Account>> children)
    {
        List<Account> updateAccounts = new List<Account>();
        
        // Loop through all records
        for (accountChildContainer acc : records)
        {   
            // If this record has children
            if (children.containsKey(acc.record.Id) && children.get(acc.record.Id) != null)
            {
                // Loop through all children and make child cluster field equal to account cluster name
                for (Account child : children.get(acc.record.Id))
                {
                    child.Cluster_Account__c = acc.clusterName;
                }
                // Update all children
                updateAccounts.addAll(children.get(acc.record.Id));
            }
        }
        
        // return records to update
        return updateAccounts;
    }
    
    public class accountChildContainer
    {
        public String clusterName {get;set;}
        public Account record {get;set;}
        
        public accountChildContainer(Account a, String cluster)
        {
            this.record = a;
            this.clusterName = cluster;

        }
    }
}
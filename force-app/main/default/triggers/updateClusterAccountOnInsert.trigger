trigger updateClusterAccountOnInsert on Account (before insert) {

    List<Account> accountsToUpdate = new List<Account>();
        
    Map<Id, List<Account>> accountsToQueryParent = new Map<Id, List<Account>>();
    for (Account acc : Trigger.new)
    {
        if (acc.ParentId != null)
        {
            if (!accountsToQueryParent.containsKey(acc.ParentId)) accountsToQueryParent.put(acc.ParentId, new List<Account>());
            accountsToQueryParent.get(acc.ParentId).add(acc);
        }
    }
    
    for (Account p : [Select Id, Name, Cluster_Account__c From Account Where Id in :accountsToQueryParent.keySet()])
    {
        if (p.Cluster_Account__c == null) p.Cluster_Account__c = p.Name;
        
        for (Account acc : accountsToQueryParent.get(p.Id))
        {
            acc.Cluster_Account__c = p.Cluster_Account__c;
        }
        
        accountsToUpdate.add(p);
    }
    
    update accountsToUpdate;
}
@IsTest
private class AccountClusterTestClass
{
    public static TestMethod void test()
    {
        Account parent = new Account(Name='1');
        insert parent;
        
        Account[] sublevelOne = new Account[] {new Account(Name='1.1', ParentId=parent.Id), new Account(Name='1.2', ParentId=parent.Id)};
        insert sublevelOne;
        
        Account[] sublevelTwo = new Account[] {new Account(Name='1.1.1', ParentId=sublevelOne.get(0).Id), new Account(Name='1.2.1', ParentId=sublevelOne.get(1).Id)};
        insert sublevelTwo;
        
        Account[] sublevelThree = new Account[] {new Account(Name='1.1.1.1', ParentId=sublevelTwo.get(0).Id), new Account(Name='1.1.1.2', ParentId=sublevelTwo.get(0).Id)};
        insert sublevelThree;
        
        parent = [Select Id, Name, Cluster_Account__c From Account Where Id = :parent.Id];
        sublevelOne = database.query('Select Id, Name, Cluster_Account__c From Account Where Id in (\'' + sublevelOne.get(0).Id + '\',\'' + sublevelOne.get(1).Id + '\')');
        sublevelTwo = database.query('Select Id, Name, Cluster_Account__c From Account Where Id in (\'' + sublevelTwo.get(0).Id + '\',\'' + sublevelTwo.get(1).Id + '\')');
        sublevelThree = database.query('Select Id, Name, Cluster_Account__c From Account Where Id in (\'' + sublevelThree.get(0).Id + '\',\'' + sublevelThree.get(1).Id + '\')');
        
        System.debug('1. ------------' + parent.Name + ' : ' + parent.Cluster_Account__c + '------------');
        System.debug('2. ------------        ' + sublevelOne[0].Name + ' : ' + sublevelOne[0].Cluster_Account__c + '------------');
        System.debug('2. ------------        ' + sublevelOne[1].Name + ' : ' + sublevelOne[1].Cluster_Account__c + '------------');
        System.debug('3. ------------            ' + sublevelTwo[0].Name + ' : ' + sublevelTwo[0].Cluster_Account__c + '------------');
        System.debug('3. ------------            ' + sublevelTwo[1].Name + ' : ' + sublevelTwo[1].Cluster_Account__c + '------------');
        System.debug('4. ------------            ' + sublevelThree[0].Name + ' : ' + sublevelThree[0].Cluster_Account__c + '------------');
        System.debug('4. ------------            ' + sublevelThree[1].Name + ' : ' + sublevelThree[1].Cluster_Account__c + '------------');
        
        
        
        subLevelOne[0].ParentId = null;
        update subLevelOne[0];
        
        parent = [Select Id, Name, Cluster_Account__c From Account Where Id = :parent.Id];
        sublevelOne = database.query('Select Id, Name, Cluster_Account__c From Account Where Id in (\'' + sublevelOne.get(0).Id + '\',\'' + sublevelOne.get(1).Id + '\') Order By Name');
        sublevelTwo = database.query('Select Id, Name, Cluster_Account__c From Account Where Id in (\'' + sublevelTwo.get(0).Id + '\',\'' + sublevelTwo.get(1).Id + '\') Order By Name');
        sublevelThree = database.query('Select Id, Name, Cluster_Account__c From Account Where Id in (\'' + sublevelThree.get(0).Id + '\',\'' + sublevelThree.get(1).Id + '\') Order By Name');
        
        System.debug('1. ------------' + parent.Name + ' : ' + parent.Cluster_Account__c + '------------');
        System.debug('2. ------------        ' + sublevelOne[0].Name + ' : ' + sublevelOne[0].Cluster_Account__c + '------------');
        System.debug('2. ------------        ' + sublevelOne[1].Name + ' : ' + sublevelOne[1].Cluster_Account__c + '------------');
        System.debug('3. ------------            ' + sublevelTwo[0].Name + ' : ' + sublevelTwo[0].Cluster_Account__c + '------------');
        System.debug('3. ------------            ' + sublevelTwo[1].Name + ' : ' + sublevelTwo[1].Cluster_Account__c + '------------');
        System.debug('4. ------------            ' + sublevelThree[0].Name + ' : ' + sublevelThree[0].Cluster_Account__c + '------------');
        System.debug('4. ------------            ' + sublevelThree[1].Name + ' : ' + sublevelThree[1].Cluster_Account__c + '------------');
        
       
        
        
        delete sublevelOne.remove(0);
        
        parent = [Select Id, Name, Cluster_Account__c From Account Where Id = :parent.Id];
        sublevelOne = database.query('Select Id, Name, Cluster_Account__c From Account Where Id in (\'' + sublevelOne.get(0).Id + '\')');
        sublevelTwo = database.query('Select Id, Name, Cluster_Account__c From Account Where Id in (\'' + sublevelTwo.get(0).Id + '\',\'' + sublevelTwo.get(1).Id + '\')');
        sublevelThree = database.query('Select Id, Name, Cluster_Account__c From Account Where Id in (\'' + sublevelThree.get(0).Id + '\',\'' + sublevelThree.get(1).Id + '\')');
        
        System.debug('1. ------------' + parent.Name + ' : ' + parent.Cluster_Account__c + '------------');
        System.debug('2. ------------        ' + sublevelOne[0].Name + ' : ' + sublevelOne[0].Cluster_Account__c + '------------');
        //System.debug('2. ------------        ' + sublevelOne[1].Name + ' : ' + sublevelOne[1].Cluster_Account__c + '------------');
        System.debug('3. ------------            ' + sublevelTwo[0].Name + ' : ' + sublevelTwo[0].Cluster_Account__c + '------------');
        System.debug('3. ------------            ' + sublevelTwo[1].Name + ' : ' + sublevelTwo[1].Cluster_Account__c + '------------');
        System.debug('4. ------------            ' + sublevelThree[0].Name + ' : ' + sublevelThree[0].Cluster_Account__c + '------------');
        System.debug('4. ------------            ' + sublevelThree[1].Name + ' : ' + sublevelThree[1].Cluster_Account__c + '------------');
        
       
        
    }
}
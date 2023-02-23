@isTest
public with sharing class UpdateDistributorNameTester {

    public static testMethod void testUpdateRMADistributorName(){
        List<Profile> profList = [select id,Name from Profile where Name ='System Administrator'];
        string profId = profList[0].id;  
    
        List<User> usersList = [select Id, Email, Distributor_Name__c from User where profileId = : profId AND IsActive = true];
        User testOwner = usersList[0];
        testOwner.Distributor_Name__c = 'DistributorName1';
        testOwner.Email = 'test@test.com';
        update testOwner;
        
        Account testAccount = new Account(Name = 'TestAccount', OwnerId = testOwner.Id);
        insert testAccount;
        
        RMA__c testRMA = new RMA__c(Account_Name__c=testAccount.Id,/*OwnerId = testOwner.Id,*/ Email_Account_Owner__c = 'test@test.com', Distributor_Name__c = 'DistributorName0', Approval_available__c = true);
        insert testRMA;
    }
    
    public static testMethod void testUpdateCaseDistributorName(){
        List<Profile> profList = [select id,Name from Profile where Name ='System Administrator'];
        string profId = profList[0].id;  
    
        List<User> usersList = [select Id, Email, Distributor_Name__c from User where profileId = : profId AND IsActive = true];
        User testOwner = usersList[0];
        testOwner.Distributor_Name__c = 'DistributorName1';
        testOwner.Email = 'test@test.com';
        update testOwner;
        
        Case testCase = new Case(/*OwnerId = testOwner.Id,*/ Email_Account_Owner__c = 'test@test.com', Distributor_Name__c = 'DistributorName0');
        insert testCase;
    }
    
    public static testMethod void testUpdateRMAandCaseDistributorName(){
        List<Profile> profList = [select id,Name from Profile where Name ='System Administrator'];
        string profId = profList[0].id;  
    
        List<User> usersList = [select Id, Email, Distributor_Name__c from User where profileId = : profId AND IsActive = true];
        User testOwner = usersList[0];
        testOwner.Distributor_Name__c = 'DistributorName1';
        testOwner.Email = 'test@test.com';
        update testOwner;
        
        User testOwner2 = usersList[1];
        testOwner2.Distributor_Name__c = 'DistributorName2';
        testOwner2.Email = 'test@test.com';
        update testOwner2;

        Account testAccount = new Account(Name = 'TestAccount', OwnerId = testOwner.Id);
        insert testAccount;
        
        RMA__c testRMA = new RMA__c( Email_Account_Owner__c = 'test@test.com', Distributor_Name__c = 'DistributorName0', Account_Name__c = testAccount.Id, Approval_available__c = true );
        insert testRMA;
        
        Case testCase = new Case(OwnerId = testOwner.Id, Email_Account_Owner__c = 'test@test.com', Distributor_Name__c = 'DistributorName0', AccountId = testAccount.Id );
        insert testCase;
        
        testAccount.OwnerId = testOwner2.Id;
        update testAccount;
    }
    
}
@isTest
public class AccountOwnerUpdateWithChannelManagerTest {
    public static User InitializeUserWithProfile(String lName,String profileName)
    {
        User u = null;
        
        List<Profile> profList = [select id,Name from Profile where Name =: profileName];
        
        if(profList.size()>0)
        {
            u = new User(Alias = 'testabc', Email='testabc_'+DateTime.now().getTime()+'@u-blox-test.com', 
            EmailEncodingKey='UTF-8', LastName=lName, LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profList[0].id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testabc_'+DateTime.now().getTime()+'@u-blox-test.com');
        }    
        return u;
    }
    
    static testMethod void testMethod1() 
    {
        List<User> userList = new List<User>();
        
        User u = InitializeUserWithProfile('Alpha Micro','Partner Base');
        u.Distributor_Name__c = 'Alpha Micro';
        userList.add(u);
        
        User u2 = InitializeUserWithProfile('Test User','System Administrator');
        u2.Distributor_Name__c = 'Internals';
        userList.add(u2);
        insert userList;    
        
        Account accountObj1 = new Account();
        accountObj1.Name ='Alpha Micro Customer Account';
        accountObj1.OwnerId = userList[0].Id;
        accountObj1.New_Channel_Manager__c =userList[1].Id ;
        
        Account accountObj2 = new Account();
        accountObj2.Name ='Alpha Micro Customer Account';
        accountObj2.OwnerId = userList[0].Id;
        //accountObj1.New_Channel_Manager__c =userList[1].Id ;
        
        List<Account> accList = new List<account>();
        accList.add(accountObj1);
        accList.add(accountObj2);
        insert accList;
        //insert accountObj;
        
        Account_Owner_Partner_Account_Map__c customSettingsoObj = new Account_Owner_Partner_Account_Map__c();
        customSettingsoObj.Name = u.Id;
        customSettingsoObj.value__c =accList[0].Id;
        insert customSettingsoObj;
        
        
        
        Test.startTest();
        
        AccountOwnerUpdateWithChannelManager obj = new AccountOwnerUpdateWithChannelManager();
        obj.accountIdforAttachment = accList[0].Id;
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }
}
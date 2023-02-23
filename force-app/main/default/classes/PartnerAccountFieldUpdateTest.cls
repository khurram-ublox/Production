@isTest
public class PartnerAccountFieldUpdateTest {
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
            
            //insert u; 
        }    
        
        return u;
    }
    
    
    static testMethod void testMethod1() 
    {
        Account accObj = new Account();
        accObj.Name = 'Alpha Micro Partner Account';
        insert accObj;
         
        User u = InitializeUserWithProfile('Alpha Micro','Partner Base');
        insert u;
        
        Account accountObj = new Account();
        accountObj.Name ='Alpha Micro Customer Account';
        accountObj.OwnerId = u.Id;
        insert accountObj;
        
        Account_Owner_Partner_Account_Map__c customSettingsoObj = new Account_Owner_Partner_Account_Map__c();
        customSettingsoObj.Name = u.Id;
        customSettingsoObj.value__c =accObj.Id;
        insert customSettingsoObj;
        
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <200;i++)
        {
            Account acc = new Account();
            acc.Name ='Name'+i;
            
        }
        
        insert lstAccount;
        
        Test.startTest();

            PartnerAccountFieldUpdate obj = new PartnerAccountFieldUpdate();
        obj.accountIdforAttachment =accObj.Id;
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}
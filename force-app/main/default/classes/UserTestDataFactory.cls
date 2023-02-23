@isTest
public class UserTestDataFactory  extends TestDataFactory {
    public UserTestDataFactory() {
        super('user');
    }

    public override sObject initializeRecord(){
         Profile prof = [SELECT Id FROM Profile WHERE Name='Management'];
        User u_user = new User();
                        u_user.Alias = 'atan';
                        u_user.Email='newuser@testorg.com'; 
                        u_user.EmailEncodingKey='UTF-8'; 
                        u_user.LastName='Testing';
                        u_user.LanguageLocaleKey='en_US';
                        u_user.LocaleSidKey='en_US';
                        u_user.ProfileId = prof.Id;
                        u_user.TimeZoneSidKey='America/Los_Angeles';
                        u_user.UserName='u_user@testorg.com';
                        u_user.IsActive = true;
        return u_user;
    }

    public override sObject createRecord() {
        User u = (User)initializeRecord();
        Insert u;
        return u;
    }

    public sObject createRecord(sObject record) {
        Insert record;
        return record;
    }

    public override List<sObject> createBulkRecords() {
        for (Integer i = 0; i < numberOfRecords; i++) {
            recordsList.add((User)initializeRecord());
        }
        Insert recordsList;
        return recordsList;
    }

    public User updateRecords(User toupdate) {
        update toupdate;
        return toupdate;
    }

    public User createTestUser(String fName, String lName)
    {
        Id profId = '00e200000015GYr'; // chatter free user
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        
       
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        Id roleID = '00E20000000urlW'; //Corporate
        
        
        User tuser = new User(  firstname = fName,
                                lastName = lName,
                                email = uniqueName + 'test@u-blox.com',
                                Username = uniqueName + 'test@u-blox.com',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = uniqueName.substring(18, 23),
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                IsActive = true,
                                ProfileId = profId
                                );
        insert tuser;
        
        return tuser;
    }

    public User createPortalUser(string userLName, string userEmail, string uBOffice, string profileName){
        User testUser = null;
        list<Profile> profList = [select id,Name from Profile where Name =: profileName];
        AccountTestDataFactory accountTestDataFactory = new AccountTestDataFactory();
        ContactTestDataFactory contactTestDataFactory = new ContactTestDataFactory();
        Contact contact = (Contact)contactTestDataFactory.createRecord();
        Account account = (Account)accountTestDataFactory.createRecord();
        contact.accountid = account.id;
        update contact;
        if(profList.size() > 0){
            
            testUser = new User(
                Alias = 'standt', 
                Email = (userEmail == NULL)? 'apex-test@u-blox.com' : userEmail, 
                EmailEncodingKey = 'UTF-8', 
                LastName = (userLName == NULL)? 'Mukul Bandodkar' : userLName, 
                LanguageLocaleKey = 'en_US', 
                LocaleSidKey = 'en_US', 
                ProfileId = profList[0].Id,
                ContactId = contact.Id,
                Channel_Manager__c = 'Test Manager',
                Email_Channel_Manager__c = 'apex-test-manager@u-blox.com',
                TimeZoneSidKey = 'America/Los_Angeles', 
                UserName = (userEmail == NULL)? 'apex-test'+(integer)Math.floor((Math.random()*5000))+ '@u-blox.com' : userEmail + (integer)Math.floor((Math.random()*5000)),
                uB_Office__c = (uBOffice == NULL)? 'EMEA' : uBOffice
            );           
            insert testUser; 
        }        
        return testUser;
    }
}
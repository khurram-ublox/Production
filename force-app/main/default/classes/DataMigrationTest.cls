@isTest
private class DataMigrationTest {
    static List<Id> oldUserIds= new List<Id>();
    static Map<Id, Id> usersIdMap = new Map<Id, Id>();
    static public Id acc; //Id of the dummy account to which results will be stored

    static testMethod void batchOwnerUpdaterTest() {

        Test.startTest();
        UserTestDataFactory testuser = new UserTestDataFactory();
        User oldUser = (User)testuser.createUserWithProfile('old user', 'olduser@gmail.com.invalid', '', 'System Administrator');
        User newUser = (User)testuser.createUserWithProfile('new user', 'newuser@gmail.com.invalid', '', 'System Administrator');

        oldUserIds.add(oldUser.id);
        usersIdMap.put(oldUser.id , newUser.id);

        AccountTestDataFactory accFactory = new AccountTestDataFactory();
        List<sObject> accs = accFactory.createBulkRecords();
        for(Sobject s : accs){
            s.put('OwnerId',oldUser.Id);
        }
        update accs;
        List<Contact> contacts = new List<Contact>();

        for (Account account : [select id from account]) {
            contacts.add(new Contact(firstname='first',
                lastname='last', accountId=account.id, ownerId=oldUser.id));
        }
        insert contacts;
        acc = String.valueOf(accs[0].get('Id'));
    
        DataMigration oChange = new DataMigration();
        oChange.usersIdMap = usersIdMap;
        oChange.acc = acc;
        System.assertNotEquals(null, oChange.usersIdMap);
        System.assertNotEquals(null, oChange.acc);
        oChange.populateChangeOwnerConfig();
        oChange.changeOwner();

        Test.stopTest();
        System.assertNotEquals(null, ochange.batchInstanceId1);
    }

    static testMethod void batchManualSharingUpdaterTest() {

        Test.startTest();
        UserTestDataFactory testuser = new UserTestDataFactory();
        User oldUser = (User)testuser.createUserWithProfile('old user', 'olduser@gmail.com.invalid', '', 'System Administrator');
        User newUser = (User)testuser.createUserWithProfile('new user', 'newuser@gmail.com.invalid', '', 'System Administrator');

        oldUserIds.add(oldUser.id);
        usersIdMap.put(oldUser.id , newUser.id);

        AccountTestDataFactory accFactory = new AccountTestDataFactory();
        List<sObject> accs = accFactory.createBulkRecords();
        for(Sobject s : accs){
            s.put('OwnerId',oldUser.Id);
        }
        update accs;
        
        AccountTeamMember accTeamMember = new AccountTeamMember();
        accTeamMember.AccountId = (Id)accs[0].get('Id');
        accTeamMember.TeamMemberRole = 'Team member';
        accTeamMember.UserId = oldUser.Id;
        insert accTeamMember;

        List<Contact> contacts = new List<Contact>();

        for (Account account : [select id from account]) {
            contacts.add(new Contact(firstname='first',
                lastname='last', accountId=account.id, ownerId=oldUser.id));
        }
        insert contacts;


        acc = String.valueOf(accs[0].get('Id'));

    
        DataMigration oChange = new DataMigration();
        oChange.usersIdMap = usersIdMap;
        oChange.acc = acc;
        System.assertNotEquals(null, oChange.usersIdMap);
        System.assertNotEquals(null, oChange.acc);
        
        oChange.populateManualSharingConfig();
        oChange.changeManualSharing();


        Test.stopTest();
        System.assertNotEquals(null, ochange.batchInstanceId2);
    }
}
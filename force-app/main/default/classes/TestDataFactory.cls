public abstract class TestDataFactory {
    protected String sObjectName;
    public List<sObject> recordsList = new List<sObject>();
    public Integer numberofRecords = 10;

    public TestDataFactory() {}
    
    public TestDataFactory(String sObjectName) {
        this.sObjectName = sObjectName;
    }
    
    protected List<SObject> generateSObjectDataFromJSON(String jsonString) {
        String className = 'List<'+sObjectName+'>';
        Type t = Type.forName(className);
        return (List<SObject>)JSON.deserialize(jsonString, t);
    }

    public List<sObject> getRecordsList(){
        return recordsList;
    }

    public List<Id> getBulkRecordIds() {
        List<Id> listData = new List<Id>();
        if (!recordsList.isEmpty()) {
            for (sObject sobj: recordsList) {
                listData.add(sobj.Id);
            }
        }
        return listData;
    }

    public Database.SaveResult[] createBulkRecordsfromJson(String json) {
        recordsList = generateSObjectDataFromJSON(json);
        return Database.insert(recordsList, false);
    }
    
    public sObject updateRecord(sObject toupdate) {
        update toupdate;
        return toupdate;
    }
    
    public User createUserWithProfile(string userLName, string userEmail, string uBOffice, string profileName){
        User testUser = null;    
        list<Profile> profList = [select id,Name from Profile where Name =: profileName];
        
        if(profList.size() > 0){
            
            testUser = new User(
                Alias = 'standt', 
                Email = (userEmail == NULL)? 'apex-test@u-blox.com' : userEmail, 
                EmailEncodingKey = 'UTF-8', 
                LastName = (userLName == NULL)? 'Mukul Bandodkar' : userLName, 
                LanguageLocaleKey = 'en_US', 
                LocaleSidKey = 'en_US', 
                ProfileId = profList[0].Id, 
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

    // it will be used in a child class to initialize default data for a sobject. 
    // e.g required fields
    abstract public sObject initializeRecord();
    abstract public sObject createRecord();
    abstract public List<sObject> createBulkRecords();

}
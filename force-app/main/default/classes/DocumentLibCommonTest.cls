@isTest
Public class DocumentLibCommonTest{
    
    Public static Topic createTopic(String tName,String tNetworkId){
        Topic topicObj = null;
        List<Topic> allTopics = [select id,name from Topic where Name =: tName AND NetworkId =: tNetworkId ]; 
        if(allTopics.size()==0)
        {
            topicObj = new Topic(Name=tName,NetworkId=tNetworkId);
            insert topicObj;
        }else
        {
            topicObj = allTopics[0];
        }
        return topicObj;
    }
    
    
    public static ContentVersion createTestDocumentVersion()
    {
        ContentVersion conVersion = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'TestFile.pdf',
            VersionData = Blob.valueOf('Test File'),
            IsMajorVersion = true
        );
        
        insert conVersion;
        return conVersion;
    }
    
    public static ContentVersion createTestDocumentVersionInComm(String commUserId)
    {
        NetworkMember commNetMember = [SELECT NetworkID, MemberID FROM NetworkMember
                              WHERE memberID = :commUserId];
                              
        ContentVersion conVersion = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'TestFile.pdf',
            VersionData = Blob.valueOf('Test File'),
            IsMajorVersion = true,
            NetworkId = commNetMember.NetworkId
        );
        
        insert conVersion;
        return conVersion;
    }
    
    public static ContentVersion createTestDocumentVersionByName(String fName,String fExtension)
    {
        if(String.isEmpty(fExtension))
            fExtension = 'txt';
        ContentVersion conVersion = new ContentVersion(
            Title = fName,
            PathOnClient = fName+'.'+fExtension,
            VersionData = Blob.valueOf(fName),
            IsMajorVersion = true
        );
        
        insert conVersion;
        return conVersion;
    }
    
    public static ContentDocument getContentDocumentFromContentVersion(String conVersionId)
    {
        ContentDocument conDocuments = null;
        if(!String.isEmpty(conVersionId))
        {
            ContentVersion conVersion = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :conVersionId limit 1];
            conDocuments = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Id =: conVersion.ContentDocumentId limit 1];
        }
        return conDocuments;
    }
    
    public static User_File__c createUserFile(String contactId,String uId)
    {
        User_File__c uFile = new User_File__c(
            Name = UserInfo.getUserName(),
            ContactId__c = contactId ,
            OwnerId = uId           
        );
        insert uFile;
        return uFile;
    }
    
    public static User_Group__c createUserGroup(String groupName)
    {
        User_Group__c uGroup = new User_Group__c(
            Name = groupName                       
        );
        insert uGroup;
        return uGroup;
    }
    
    public static User_Group_Item__c createUserGroupItem(String groupId,String userId)
    {
        User_Group_Item__c uGroupItem = new User_Group_Item__c(
            User_Group__c = groupId,
            User__c = userId                       
        );
        insert uGroupItem;
        return uGroupItem;
    }
    
    public static ContentDocumentLink createConDocLink(String conId,String linkEntityId)
    {
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = conId ;
        cdl.LinkedEntityId = linkEntityId;
        cdl.ShareType = 'V';
        insert cdl;
        return cdl;
    }
    
    
    
    public static Account createAccountWithOwner(ID ownerId)
    {
        Account acc = new Account();
        acc.name = 'Test Account';
        acc.OwnerId = ownerId;
        insert acc;
        return acc;
    }
    
    public static Contact createContact(String accId)
    {
        Contact c=new Contact(FirstName='First',LastName='Last',Phone='004194567854',AccountId=accId,Email='test@test.com');
        insert c;
        return c;        
    }
    
    public static User createCommunityUser(){
    
        Account a = new Account(Name='Registered Community Users');
        insert a;
        
        Contact c = new Contact(LastName='Test User', AccountId=a.Id);
        insert c;   
        
        Id profileId =  [Select Id from Profile where Name = 'Community Registered User' limit 1].Id;
        
        //Create user
        User u = new User(LastName='TestUser',
                          Alias='testAlia',
                          Email='apex-test@u-blox.com',
                          Username='apex-test@u-blox.com',
                          CommunityNickname='apex.test',
                          ContactId=c.Id,
                          ProfileId=profileId,
                          TimeZoneSidKey='America/New_York',
                          LocaleSidKey='en_Us',
                          EmailEncodingKey='ISO-8859-1',
                          LanguageLocaleKey='en_US');
        insert u;
    
        return u;
    }
}
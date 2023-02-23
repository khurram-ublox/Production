@isTest
private class DataMigrationCaseFeedCommentAttachTest {
    static List<Id> oldUserIds= new List<Id>();
    static Map<Id, Id> usersIdMap = new Map<Id, Id>();
    static public Id acc; //Id of the dummy account to which results will be stored

    static testMethod void caseFeedCommentTest() {

        Test.startTest();
        UserTestDataFactory testuser = new UserTestDataFactory();
        User oldUser = (User)testuser.createUserWithProfile('old user', 'olduser@gmail.com.invalid', '', 'System Administrator');
        User newUser = (User)testuser.createUserWithProfile('new user', 'newuser@gmail.com.invalid', '', 'System Administrator');

        usersIdMap.put(oldUser.id , newUser.id);

        AccountTestDataFactory accFactory = new AccountTestDataFactory();
        Account accs = (Account)accFactory.createRecord();

        CaseTestDataFactory caseFactory = new CaseTestDataFactory();
        Case tCase = (Case)caseFactory.createRecord();
        tCase.OwnerId = oldUser.id;
        update tCase;

        CaseComment   tComment = new CaseComment();
        tComment.ParentId = tCase.Id;
        tComment.CommentBody = 'Some Comment';
        tComment.IsPublished = TRUE;
        
        INSERT tComment;

        FeedItem f = new FeedItem();
        f.Body = 'Internal Communication';
        f.Type = 'TextPost';
        f.parentID = tCase.id;
        
        insert f;

        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;

        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=tCase.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'InternalUsers';
        insert contentlink;

        FeedComment fc = new FeedComment();
        fc.CommentBody = 'legal test';
        fc.RelatedRecordId =content.Id;
        fc.FeedItemId = f.Id;
        //  fc.ParentId =c.id;
        insert fc;

        DataMigrationCaseFeedCommentAttachments caseFeedTest = new DataMigrationCaseFeedCommentAttachments();
        caseFeedTest.Execute(Datetime.newInstance(2023, 1, 15, 0, 0, 0), usersIdMap.keySet(), accs.id, false);

        List<ContentDocumentLink> contentlinkList = [SELECT Visibility FROM ContentDocumentLink WHERE ContentDocumentId = :contentlink.contentdocumentid];
        for(ContentDocumentLink link : contentlinkList) {
            System.assertEquals('AllUsers', link.visibility, 'Record is not updated');
        }
        
        Test.stopTest();
    }
}
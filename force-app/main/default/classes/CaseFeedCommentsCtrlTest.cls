@isTest
private class CaseFeedCommentsCtrlTest {
    
    static testMethod void postfeedCommentInternalTest(){
        
        Test.startTest();
        CaseTestDataFactory caseDataFac = new CaseTestDataFactory();
        Case newCase = (Case)caseDataFac.createRecord();
		Id caseId = newCase.Id;

        String fileData = '{"fileName":"readCarefully.txt","fileContents":"anVzdCBhIHRleHQgZmlsZSBleGFtcGxlDQoNCg0KcGxlYXNlIHJlYWQgdGhpcyBjYXJlZnVsbHkgYW5kIHRoZW4gY2xvc2UgdGhpcyBmaWxlLg==","contentType":"text/plain"}';
        Id caseCommentId = CaseFeedCommentsCtrl.postCcCtrl(caseId, 'Hello partners',fileData);

        FeedItem feedItem = new FeedItem(Body='Internal Communication', ParentId=caseId, Type='TextPost', IsRichText=true, Visibility='InternalUsers');
        insert feedItem;
        
        UserTestDataFactory userTestDataFactory = new UserTestDataFactory();
        User user1 = (User)userTestDataFactory.createUserWithProfile('old user', 'olduser@gmail.com.invalid', '', 'System Administrator');

        Id postCommentId;
        System.RunAs(user1) {
            postCommentId = CaseFeedCommentsCtrl.postComment(caseId, feedItem.id, 'Hello internal', fileData, 'internal', null, null);
            System.assertNotEquals(null, postCommentId);
            postCommentId = CaseFeedCommentsCtrl.postComment(caseId, feedItem.id, 'Hello internal', fileData, 'customer', null, null);
            System.assertNotEquals(null, postCommentId);
            postCommentId = CaseFeedCommentsCtrl.postComment(caseId, feedItem.id, 'Hello partner', fileData, 'partner', null, null);
            System.assertNotEquals(null, postCommentId);

            Id userId = CaseFeedCommentsCtrl.getUserId();
            System.assertEquals( UserInfo.getUserId() , userId );
        }
        Test.stopTest();
    }

    static testMethod void editCommentTest(){
        
        CaseTestDataFactory caseDataFac = new CaseTestDataFactory();
        Case newCase = (Case)caseDataFac.createRecord();
        
        UserTestDataFactory userTestDataFactory = new UserTestDataFactory();
        User user1 = (User)userTestDataFactory.createUserWithProfile('old user', 'olduser@gmail.com.invalid', '', 'System Administrator');
		Id caseId = newCase.Id;

        FeedItem feedItem = new FeedItem(Body='Internal Communication', ParentId=caseId, Type='TextPost', IsRichText=true, Visibility='InternalUsers');
        insert feedItem;

        Test.startTest();
        System.RunAs(user1) {
            FeedComment fc = new FeedComment(CreatedById = UserInfo.getUserId(),CommentBody='first comment', FeedItemId=feedItem.id, CommentType='TextComment',IsRichText=true);
            insert fc;
            Id feedCommentId = fc.id;

            Boolean isInternalUpdated = CaseFeedCommentsCtrl.editComment(fc.Id, 'internal comment', 'internal');
            String updatedPostComment = [SELECT CommentBody FROM FeedComment where Id = :feedCommentId ].CommentBody;
            System.assertEquals(updatedPostComment, 'internal comment');
            
            Boolean ispartnerUpdated = CaseFeedCommentsCtrl.editComment(fc.Id, 'partner comment', 'partner');
            updatedPostComment = [SELECT CommentBody FROM FeedComment where Id = :feedCommentId ].CommentBody;
            
            System.assertEquals(updatedPostComment, 'partner comment');
        }
        
        Test.stopTest();
    }

    static testMethod void deleteCommentTest(){
        
        CaseTestDataFactory caseDataFac = new CaseTestDataFactory();
        Case newCase = (Case)caseDataFac.createRecord();
		Id caseId = newCase.Id;
        
        UserTestDataFactory userTestDataFactory = new UserTestDataFactory();
        User user1 = (User)userTestDataFactory.createUserWithProfile('old user', 'olduser@gmail.com.invalid', '', 'System Administrator');

        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;

        Test.startTest();
        System.RunAs(user1) {
            CaseComment caseComment = new CaseComment(ParentId = caseId, CommentBody = 'Hello', IsPublished = false);
            insert caseComment; 
            Boolean isDocDel = CaseFeedCommentsCtrl.deleteDocument([select contentdocumentid from contentversion where id =: content.id].contentdocumentid);
            Boolean flag = CaseFeedCommentsCtrl.deleteComment(caseComment.Id,'partner');
            System.assertEquals(true, flag);
            System.assertEquals(true, isDocDel);
        }
        
        
        Test.stopTest();
    }

    static testMethod void getCommentTest(){
        
        Test.startTest();
        
        CaseTestDataFactory caseDataFac = new CaseTestDataFactory();
        Case newCase = (Case)caseDataFac.createRecord();
        Partner_Communication__c pc = new Partner_Communication__c();
        insert pc;
        newCase.Partner_Communication__c = pc.id;
        update newCase;
		Id caseId = newCase.Id;
        
        UserTestDataFactory userTestDataFactory = new UserTestDataFactory();
        
        User user2 = (User)userTestDataFactory.createUserWithProfile('old user1', 'oolduser@gmail.com.invalid', '', 'System Administrator');

        String fileData = '{"fileName":"readCarefully.txt","fileContents":"anVzdCBhIHRleHQgZmlsZSBleGFtcGxlDQoNCg0KcGxlYXNlIHJlYWQgdGhpcyBjYXJlZnVsbHkgYW5kIHRoZW4gY2xvc2UgdGhpcyBmaWxlLg==","contentType":"text/plain"}';
        Id caseCommentId = CaseFeedCommentsCtrl.postCcCtrl(caseId, 'Hello partners',fileData);
        
        CaseComment caseComment = new CaseComment(ParentId = caseId, CommentBody = 'Hello', IsPublished = false);
        insert caseComment;
        FeedItem feedItem = new FeedItem(Body='Internal Communication', ParentId=caseId, Type='TextPost', IsRichText=true, Visibility='InternalUsers');
        insert feedItem;

        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;

        FeedComment fc = new FeedComment(CreatedById = user2.id,CommentBody='first comment', FeedItemId=feedItem.id,IsRichText=true, relatedrecordId=content.id);
        FeedComment fc2 = new FeedComment(CreatedById = user2.id,CommentBody='first comment', FeedItemId=feedItem.id, CommentType='TextComment',IsRichText=true);
        insert fc;
        insert fc2;
        System.assertNotEquals(null, fc);
        System.assertNotEquals(null, fc2);
        
        Id postCommentId;
        System.RunAs(user2) {
            Map<string,object> data = CaseFeedCommentsCtrl.getComments(caseId);
            System.assertNotEquals(null, data);
            CaseFeedCommentsHelper.powerPartnerFeedComments(feedItem.id, null);
        }
        
        Test.stopTest();
    }

    @IsTest(SeeAllData=true)
    static void itShouldWorkAsExpected() {
        // we can't test these
        CaseFeedCommentsHelper.addToCommentsMap(null, null, null, null);    
    }
}
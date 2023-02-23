@isTest
Class CustomFileRelatedListServiceTest{

    @isTest
    static void getFilteredContentDetailsWithoutSearchTest(){
    
        User commUser = DocumentLibCommonTest.createCommunityUser();        
        //Create UserFile
        User_File__c uFile = DocumentLibCommonTest.createUserFile(commUser.contactId,commUser.Id);
        ContentVersion cVer = DocumentLibCommonTest.createTestDocumentVersionInComm(commUser.Id);
        ContentDocument cDoc = DocumentLibCommonTest.getContentDocumentFromContentVersion(cVer.Id);
        // Associate document to UserFile
        DocumentLibCommonTest.createConDocLink(cDoc.id,uFile.id);
        
        List<ContentVersion> contentVersionList = CustomFileRelatedListService.getFilteredContentDetails(uFile.id,'');
        System.assert(contentVersionList.size() > 0,'There is issue fetching files related to User!');
    }
    
    @isTest
    static void getFilteredContentDetailsWithSearchTest(){
    
        User commUser = DocumentLibCommonTest.createCommunityUser();        
        //Create UserFile
        User_File__c uFile = DocumentLibCommonTest.createUserFile(commUser.contactId,commUser.Id);
        ContentVersion cVer = DocumentLibCommonTest.createTestDocumentVersionInComm(commUser.Id);
        ContentDocument cDoc = DocumentLibCommonTest.getContentDocumentFromContentVersion(cVer.Id);
        // Associate document to UserFile
        DocumentLibCommonTest.createConDocLink(cDoc.id,uFile.id);
        
        List<ContentVersion> contentVersionList = CustomFileRelatedListService.getFilteredContentDetails(uFile.id,'Test');
        System.assert(contentVersionList.size() == 0,'There is issue fetching files related to User!');
    }
    
    @isTest
    static void getFilteredContentDetailsWithSearchInvalidTest(){
    
        User commUser = DocumentLibCommonTest.createCommunityUser();        
        //Create UserFile
        User_File__c uFile = DocumentLibCommonTest.createUserFile(commUser.contactId,commUser.Id);
        ContentVersion cVer = DocumentLibCommonTest.createTestDocumentVersionInComm(commUser.Id);
        ContentDocument cDoc = DocumentLibCommonTest.getContentDocumentFromContentVersion(cVer.Id);
        // Associate document to UserFile
        DocumentLibCommonTest.createConDocLink(cDoc.id,uFile.id);
        
        List<ContentVersion> contentVersionList = CustomFileRelatedListService.getFilteredContentDetails(uFile.id,'ABC');
        System.assert(contentVersionList.size() == 0,'There is issue fetching files related to User!');
    }
}
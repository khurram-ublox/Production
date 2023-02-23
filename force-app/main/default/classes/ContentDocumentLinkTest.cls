@isTest
Class ContentDocumentLinkTest{
     
    @isTest
    static void associateFileToUserGroup()
    {
        User commUser = DocumentLibCommonTest.createCommunityUser();        
        ContentVersion cVer = DocumentLibCommonTest.createTestDocumentVersion();
        //Create UserFile
        User_File__c uFile = DocumentLibCommonTest.createUserFile(commUser.contactId,commUser.Id);
        
        //Create Group
        User_Group__c uGroup = DocumentLibCommonTest.createUserGroup('TestGroup1');        
        User_Group_Item__c uGroupItem = DocumentLibCommonTest.createUserGroupItem(uGroup.Id,commUser.Id);
        
        // Associate document to User Group
        ContentDocument cDoc = DocumentLibCommonTest.getContentDocumentFromContentVersion(cVer.Id);
        DocumentLibCommonTest.createConDocLink(cDoc.id,uGroup.id);
        List<ContentDocumentLink> cdLinkObjList = [select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId =: uFile.id];
        System.assert(cdLinkObjList.size() == 1,'There is an issue associating file using Groups.');
    }
    
    @isTest
    static void associateFileToUserFile()
    {
        User commUser = DocumentLibCommonTest.createCommunityUser();        
        ContentVersion cVer = DocumentLibCommonTest.createTestDocumentVersion();
        //Create UserFile
        User_File__c uFile = DocumentLibCommonTest.createUserFile(commUser.contactId,commUser.Id);
        
        ContentDocument cDoc = DocumentLibCommonTest.getContentDocumentFromContentVersion(cVer.Id);
        
        // Associate document to User Group
        DocumentLibCommonTest.createConDocLink(cDoc.id,uFile.id);
        List<ContentDocumentLink> cdLinkObjList = [select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId =: uFile.id];
        System.assert(cdLinkObjList.size() == 1,'There is an issue associating file to UserFile.');
    }
    
    @isTest
    static void associateFileToUserFileByCommUser()
    {
        User commUser = DocumentLibCommonTest.createCommunityUser();        
        
        //Create UserFile
        User_File__c uFile = DocumentLibCommonTest.createUserFile(commUser.contactId,commUser.Id);
        
        System.runAs(commUser) {
            ContentVersion cVer = DocumentLibCommonTest.createTestDocumentVersionInComm(commUser.Id);
            
            ContentDocument cDoc = DocumentLibCommonTest.getContentDocumentFromContentVersion(cVer.Id);
            
            // Associate document to UserFile
            
            // try catch is used as this always give validation error
            try{
                DocumentLibCommonTest.createConDocLink(cDoc.id,uFile.id);
            }catch(Exception ex){}
        }
        List<ContentDocumentLink> cdLinkObjList = [select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId =: uFile.id];
        System.assert(cdLinkObjList.size() == 0,'There is an issue associating file to UserFile.');
    }
    
    @isTest
    static void removeFileAssociatedToUserFile()
    {
        User commUser = DocumentLibCommonTest.createCommunityUser();        
        ContentVersion cVer = DocumentLibCommonTest.createTestDocumentVersion();
        //Create UserFile
        User_File__c uFile = DocumentLibCommonTest.createUserFile(commUser.contactId,commUser.Id);
        
        //Create Group
        User_Group__c uGroup = DocumentLibCommonTest.createUserGroup('TestGroup1');        
        User_Group_Item__c uGroupItem = DocumentLibCommonTest.createUserGroupItem(uGroup.Id,commUser.Id);
        
        // Associate document to UserFile
        ContentDocument cDoc = DocumentLibCommonTest.getContentDocumentFromContentVersion(cVer.Id);
        ContentDocumentLink cdl = DocumentLibCommonTest.createConDocLink(cDoc.id,uFile.id);
        
        delete cdl;
        
        List<ContentDocumentLink> cdLinkObjList = [select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId =: uFile.id];
        System.assert(cdLinkObjList.size() == 0,'There is an issue deleting file from UserFile.');
    }
    
    @isTest
    static void removeFileAssociatedToUserFileWithGroup()
    {
        User commUser = DocumentLibCommonTest.createCommunityUser();        
        ContentVersion cVer = DocumentLibCommonTest.createTestDocumentVersion();
        //Create UserFile
        User_File__c uFile = DocumentLibCommonTest.createUserFile(commUser.contactId,commUser.Id);
        
        //Create Group
        User_Group__c uGroup = DocumentLibCommonTest.createUserGroup('TestGroup1');        
        User_Group_Item__c uGroupItem = DocumentLibCommonTest.createUserGroupItem(uGroup.Id,commUser.Id);
        
        ContentDocument cDoc = DocumentLibCommonTest.getContentDocumentFromContentVersion(cVer.Id);
        
        // Associate document to UserFile
        ContentDocumentLink cdl = DocumentLibCommonTest.createConDocLink(cDoc.id,uFile.id);
        ContentDocumentLink cdlGroup = DocumentLibCommonTest.createConDocLink(cDoc.id,uGroup.id);
        // try catch is used as this always give validation error
        try{
            delete cdl;
        }catch(Exception ex){}
        List<ContentDocumentLink> cdLinkObjList = [select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId =: uFile.id];
        System.assert(cdLinkObjList.size() == 1,'There is an issue deleting file from UserFile.');
    }
    @isTest
    public static void callTriggerHandler()
    {
        ContentDocumentLinkTriggerHandler cHandler = new ContentDocumentLinkTriggerHandler();
        cHandler.beforeUpdate();
        cHandler.afterDelete();
        cHandler.afterUpdate();
        cHandler.finish();
        
    }
}
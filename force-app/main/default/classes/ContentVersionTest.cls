@isTest
Public class ContentVersionTest{

    @isTest(SeeAllData=true)
    public static void updateContentVersion()
    {
        Topic topic1 = DocumentLibCommonTest.createTopic('Others',NULL);
        Topic topic2 = DocumentLibCommonTest.createTopic('Internal',NULL);
        
        ContentVersion cv = DocumentLibCommonTest.createTestDocumentVersion();
        cv.Type__c = 'Internal';
        cv.Category__c = 'Others';
        
        update cv;
        
        System.assert(cv.Type__c == 'Internal','Update failed');
        
    }
    @isTest
    public static void callTriggerHandler()
    {
        ContentVersionTriggerHandler cvtHandler = new ContentVersionTriggerHandler();
        cvtHandler.prepareBefore();
        cvtHandler.beforeInsert();        
        cvtHandler.beforeUpdate();
        cvtHandler.beforeDelete();
        cvtHandler.afterDelete();
        
    }
}
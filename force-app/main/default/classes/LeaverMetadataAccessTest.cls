@isTest
class LeaverMetadataAccessTest{
    @isTest
    static void getSOQLResultTest(){
        TestUtils.createAccount();
        String qStr = 'select id from account';
        Test.startTest();
        List<sObject> sObjList = LeaverMetadataAccess.getSOQLResult(qStr);
        Test.stopTest();
        System.assertEquals(sObjList.size(), 1);
    }
    
    @isTest
    static void deleteScheduleJobsTest(){
        Test.startTest();
        LeaverMetadataAccess.deleteScheduleJobs(UserInfo.getUserId());
        Test.stopTest();        
    }
}
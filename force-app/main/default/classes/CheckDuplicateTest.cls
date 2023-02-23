@isTest
public class CheckDuplicateTest{
    @isTest
    public static void accountDuplicateCheckTest(){
    
        Account acc = TestUtils.createAccount();
        Account acc1 = TestUtils.createAccount();
        List<sObject> records = new List<sObject>{acc,acc1};
                
        Account reqAcc = new Account();
        reqAcc.Name = acc1.Name;
        RestRequest request = new RestRequest(); 
        RestResponse resp = new RestResponse();
        request.requestURI = '/services/apexrest/CheckDuplicate';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(JSON.serialize(reqAcc));
        RestContext.request = request;
        RestContext.response= resp;
        
        Test.startTest();
        CheckDuplicate.DuplicateResult dRes = CheckDuplicate.getDuplicateRecords(records);
        Test.StopTest();
        //if(dRes.duplicateRecords!=null)  // if duplicate rule is not activated     
            //System.assertEquals(dRes.duplicateRecords.size(),records.size());
    }
    
    @isTest
    public static void accountWithNoRecordsDuplicateCheckTest(){
    
        Account acc = TestUtils.createAccount();
        List<sObject> records = new List<sObject>();
                
        Account reqAcc = new Account();
        reqAcc.Name = acc.Name;
        RestRequest request = new RestRequest(); 
        RestResponse resp = new RestResponse();
        request.requestURI = '/services/apexrest/CheckDuplicate';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(JSON.serialize(reqAcc));
        RestContext.request = request;
        RestContext.response= resp;
        
        Test.startTest();
        CheckDuplicate.DuplicateResult dRes = CheckDuplicate.getDuplicateRecords(records);
        Test.StopTest();        
        System.assertEquals(dRes.isSuccess,false);
    }
    
    @isTest
    public static void noRuleDuplicateCheckTest(){
        Contact reqCont = new Contact();
        reqCont.firstName = 'First';
        
        List<sObject> records = new List<sObject>{reqCont};
        
        reqCont.FirstName = 'Test Name';
        RestRequest request = new RestRequest(); 
        RestResponse resp = new RestResponse();
        request.requestURI = '/services/apexrest/CheckDuplicate';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(JSON.serialize(records));
        RestContext.request = request;
        RestContext.response= resp;
        
        Test.startTest();
        CheckDuplicate.DuplicateResult dRes = CheckDuplicate.getDuplicateRecords(records);
        Test.StopTest();        
        System.assertEquals(dRes.isSuccess,false);
    }

}
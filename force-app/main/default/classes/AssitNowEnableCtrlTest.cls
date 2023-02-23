@IsTest
private class AssitNowEnableCtrlTest{
    public static TestMethod void test(){           
      Contact coObj=new Contact();
      coObj.LastName='sumit singh';
      coObj.MGA_Support_Email__c = 'sumit.singh.uxb@mailinator.com';
      coObj.Email = 'sumit.singh.uxb@mailinator.com';
      insert coObj;  
      String conId=coObj.id; 
       // Set mock callout class 
       //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
      //HttpResponse res = CalloutClass.getInfoFromExternalService();          
      AssitNowEnableCtrl.assitNowEnableToken(conId);
      Test.startTest();
      AssitNowEnableCtrl.assitNowEnableTokenConform(conId);
      Test.stopTest();
      AssitNowEnableCtrl.assitNowEnableTokenReSend(conId);
    }
}
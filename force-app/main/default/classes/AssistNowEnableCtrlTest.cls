@isTest
private class AssistNowEnableCtrlTest{
    public static TestMethod void test(){           
        Contact c = new Contact();
        c.LastName = 'sumit singh';
        c.MGA_Support_Email__c = 'sumit.singh.uxb@mailinator.com';
        c.Email = 'sumit.singh.uxb@mailinator.com';
        insert c;

        // Set mock callout class
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        
        //HttpResponse res = CalloutClass.getInfoFromExternalService();          
        Boolean res = AssistNowEnableCtrl.checkToken(c.id);
        System.assertEquals(true, res); 
        Test.startTest();
        Id cId = AssistNowEnableCtrl.enableToken(c.id);
        System.assertEquals(c.Id, cId);
        Test.stopTest();
        cId = AssistNowEnableCtrl.resendToken(c.id);
        System.assertEquals(c.Id, cId);
    }
}
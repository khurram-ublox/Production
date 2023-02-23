@isTest
public class EmailMessageObjectHelperTest {
    
    private static Case createCase(){
        //Insert test case record
        Case c = new Case();
        c.Subject = 'Test Closed Case';  
        c.Status ='New';
        c.Priority = 'Medium';
        c.Origin = 'Email';
        c.AccountId = TestUtils.createAccount().id;
        insert c; 
        return c;       
    }

    private static Case_EmailMessage_Config__c  createEmailCaseConfigSetting()
    {
        Case_EmailMessage_Config__c cESetting = new Case_EmailMessage_Config__c();
        cESetting.Days_For_ClosedCase_Email__c = 0;
        insert cESetting;
        
        return cESetting;
    }

    private static EmailMessage createEmailMessage(String recordId){
        //Insert emailmessage for case
        EmailMessage emailObj = new EmailMessage();
        emailObj.FromAddress = 'test@ubx.com';
        emailObj.Incoming = True;
        emailObj.ToAddress= 'test@ubx.com';
        emailObj.Subject = 'Re : Test email';
        emailObj.HtmlBody = 'Re : Test email';
        emailObj.ParentId = recordId; 
        insert emailObj;
        return emailObj;
    }

    static void callEmailMessageTriggerHelperMethods()
    {
        EmailMessageTriggerHelper emTrigger = new EmailMessageTriggerHelper();
        emTrigger.prepareAfter();
        emTrigger.beforeUpdate();
        emTrigger.beforeDelete();
        emTrigger.afterInsert();
        emTrigger.afterUpdate();
        emTrigger.afterDelete();
    }

    @isTest
    public static void checkForCloseCaseAndProcessMsgTest(){
        callEmailMessageTriggerHelperMethods();
        Case c = createCase();
        c.Status = 'Closed';
        update c;
        createEmailCaseConfigSetting();        
        Test.startTest();
        EmailMessage em = createEmailMessage(c.id);        
        Test.stopTest();
    }

}
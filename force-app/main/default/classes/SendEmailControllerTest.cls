/*
    Name         : SendEmailControllerTest
    Author       : PARX
    Date         : 18th Sept 2017
    Description  : This class cover the code of SendEmailController class.
*/
@isTest
public class SendEmailControllerTest {

    @isTest static void testSendAndClose() {
    
        PageReference pageRef = Page.Save_and_Close_Page;
       
        // Create custom settings
        Users_Email__c setting = new Users_Email__c();
        setting.Name = 'Test Setting';
        setting.Email_Address__c = 'harivaishnav01@gmail.com';
        setting.User_And_Email__c = 'hari <harivaishnav01@gmail.com>';
        insert setting;
        
        // getting recordtype id 
        List<RecordType> recTypeLst = [Select Id From RecordType where sobjecttype = 'Case' and name = 'Email Case'];
        
        // Create case record 
        Case caseRec = new Case();
        caseRec.RecordTypeId = recTypeLst[0].Id;
        caseRec.Temp_From__c = setting.Id;
        insert caseRec;
        
        // create task for case
        Task tsk1 = new Task(WhatId = caseRec.Id, Subject = 'Email: apex test', ActivityDate = date.today(), Status = 'Completed',Description = 'hello this is test body \n');
        insert tsk1;
        
        System.assertEquals(1,[Select Id,(SELECT ActivityDate, Subject FROM ActivityHistories) from Case where Id =:caseRec.Id].size());
                    
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',caseRec.id);
        ApexPages.StandardController sc = new ApexPages.standardController(caseRec);
        
        SendEmailController sendEmail = new SendEmailController(sc);
        sendEmail.toEmail = 'harivaishnav@gmail.com';
        sendEmail.cC = 'harivaishnav@gmail.com';
        sendEmail.bCc = 'harivaishnav@gmail.com';
        sendEmail.mailBody = 'test email body';
        sendEmail.subject = 'test subject';
       
        sendEmail.selectedFrom = setting.Id;
        
        //  OrgWideEmailAddress orgw = new OrgWideEmailAddress(Address='harivaishnav01@gmail.com', DisplayName='hari', IsAllowAllProfiles=true);
        //  insert orgw;
        sendEmail.sendEmail();
        sendEmail.updateCaseStatus();
    }
}
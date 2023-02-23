/*
 * Title: AttachmentTriggerTest
 * Description: Test class for AttachmentTrigger
 * Author:  ldra
 * Created:  2018-12-06
 */

@isTest
public class AttachmentTriggerTest {

    @isTest 
    static void opportunityOnInsert() {

        Account acc = new Account(Name='Test Acc',uB_Office__c='Corporate');
        insert acc;

        Opportunity opp = new Opportunity(Name='TestOpp', StageName='3 Calling on',CloseDate=Date.today(),Description='test description',AccountId=acc.Id);
        insert opp;
        
        Attachment att=new Attachment();  
        att.ParentId=opp.Id;
        att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('Unit Test Attachment Body');
        att.ContentType='application/pdf';
        insert att;
        
        Opportunity o = [SELECT Id, Has_PDF_Attachments__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(true, o.Has_PDF_Attachments__c);  

    }

    @isTest 
    static void opportunityOnDelete() {

        Account acc = new Account(Name='Test Acc',uB_Office__c='Corporate');
        insert acc;

        Opportunity opp = new Opportunity(Name='TestOpp', Has_PDF_Attachments__c = true, StageName='3 Calling on',CloseDate=Date.today(),Description='test description',AccountId=acc.Id);
        insert opp;
        
        Attachment att=new Attachment();  
        att.ParentId=opp.Id;
        att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('Unit Test Attachment Body');
        att.ContentType='application/pdf';
        insert att;
        
        delete att;

        Opportunity o = [SELECT Id, Has_PDF_Attachments__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(false, o.Has_PDF_Attachments__c);  

    }
    
}
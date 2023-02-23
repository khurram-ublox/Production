/*
    Name         : CaseCloseController
    Author       : PARX
    Date         : 3nd Nov 2017
    Description  : This class cover CaseCloseController class. 
*/
@isTest
public class UpdateCaseControllerTest{
    
    @isTest static void testCaseClose(){
      
        // getting recordtype id 
        List<RecordType> recTypeLst = [Select Id From RecordType where sobjecttype = 'Case' and name = 'Email Case'];
      
        // Create case record 
        Case caseRec = new Case();
        caseRec.RecordTypeId = recTypeLst[0].Id;
        //caseRec.Temp_From__c = setting.Id;
        insert caseRec;
       
        PageReference pageRef = Page.CaseClose_Page;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',caseRec.id);
        ApexPages.StandardController sc = new ApexPages.standardController(caseRec);
        
        UpdateCaseController caseClose = new UpdateCaseController(sc);
        caseClose.updateCaseStatus();
    }
}
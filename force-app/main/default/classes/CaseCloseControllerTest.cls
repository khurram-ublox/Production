/*
        Name        : CaseCloseControllerTest
        Author      : AnavClouds (Hari Vaishnav)
        Date        : 24th Jan 2018
        Description : Test class of lightning CaseCloseController class.
*/
@isTest 
public class CaseCloseControllerTest {

    @isTest 
    private static void test(){
        Case cse = new Case();
        cse.Status = 'New';
        insert cse;
        
        CaseCloseController.getCase(cse.Id);
        CaseCloseController.updateCaseStatus(cse.Id);
    }
}
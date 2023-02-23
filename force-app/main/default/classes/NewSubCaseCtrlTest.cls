@IsTest
private class NewSubCaseCtrlTest {     
    public static TestMethod void test(){
     Case caseObj= new Case();
     insert caseObj; 
     ApexPages.StandardController stdController= new ApexPages.StandardController(caseObj);   
     NewSubCaseCtrl con= new NewSubCaseCtrl(stdController);           
     }
}
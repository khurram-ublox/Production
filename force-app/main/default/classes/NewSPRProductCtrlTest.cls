@IsTest
private class NewSPRProductCtrlTest {     
    public static TestMethod void test(){
     Account accObj= new Account();
     accObj.Name='Test';
     insert accObj;
     Special_Price_Request__c sprObj=new Special_Price_Request__c();
     sprObj.Account__c=accObj.id;  
     insert sprObj;
     List<Special_Price_Request__c> sprObjLst=new List<Special_Price_Request__c>();      
     ApexPages.currentPage().getParameters().put('id', sprObj.id);
     ApexPages.StandardSetController stdController= new ApexPages.StandardSetController(sprObjLst);   
     NewSPRProductCtrl con= new NewSPRProductCtrl(stdController); 
               
     }
}
@IsTest
private class NewPriceCtrlTest {     
    public static TestMethod void test(){
      Competitor__c comObj=new Competitor__c();
      insert comObj;
     list<Competitor_Product__c> compProLst= new list<Competitor_Product__c>();
     Competitor_Product__c compProduct= new Competitor_Product__c();
     compProLst=[Select id from Competitor_Product__c];  
     Test.setCurrentPageReference(new PageReference('Page.New_Price')); 
     System.currentPageReference().getParameters().put('id', compProLst[0].id);
     ApexPages.StandardSetController stdController= new ApexPages.StandardSetController(compProLst);   
     NewPriceCtrl con= new NewPriceCtrl(stdController); 
               
     }
}
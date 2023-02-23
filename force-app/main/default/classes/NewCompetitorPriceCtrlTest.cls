@IsTest
private class NewCompetitorPriceCtrlTest {     
    public static TestMethod void test(){
      // 2017.11.27 khir: Added Account creation to solve the error for Flow "EMEA_Sales_Stage_8" (made by Process Builder)
      Account acc = new Account(Name='Test Acc',uB_Office__c='Corporate');
      insert acc;
        
        
     Opportunity oppObj =new Opportunity();
     oppObj.Name='test'; 
     oppObj.StageName='prospecting'; 
     oppObj.CloseDate=System.today();     
      oppObj.AccountId=acc.Id; // 2017.11.27 khir
     insert oppObj; 
     Product2 proObj=new Product2();
     proObj.Name='test';
     proObj.Type_No__c='test';
     proObj.Product_Series__c='VERA-P1';
     insert proObj;
     Opp_Product__c oppProObj=new Opp_Product__c();
     oppProObj.Opportunity__c=oppObj.id;
     oppProObj.Product__c=proObj.id;
     insert oppProObj;  
     list<Opp_Product__c>  oppProObjLst=new list<Opp_Product__c>();   
      
     ApexPages.currentPage().getParameters().put('id', oppProObj.id);
     ApexPages.StandardSetController stdController= new ApexPages.StandardSetController(oppProObjLst);   
     NewCompetitorPriceCtrl con= new NewCompetitorPriceCtrl(stdController); 
               
     }
}
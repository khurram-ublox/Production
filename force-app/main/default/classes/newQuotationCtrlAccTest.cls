@IsTest
private class newQuotationCtrlAccTest{
    public static TestMethod void test(){
      // 2017.11.27 khir: Added Account creation to solve the error for Flow "EMEA_Sales_Stage_8" (made by Process Builder)
      Account acc = new Account(Name='Test Acc',uB_Office__c='Corporate');
      insert acc;
        
      opportunity oppObj = new Opportunity();
      oppObj.Name='test'; 
      oppObj.StageName='3 Calling on'; 
      oppObj.CloseDate=System.today();
      oppObj.AccountId=acc.Id; // 2017.11.27 khir
      insert oppObj;
      Contact coObj=new Contact();
      coObj.LastName='sumit singh';
      insert coObj;
      OpportunityContactRole oppContObj= new OpportunityContactRole();
      oppContObj.OpportunityId=oppObj.id;
      oppContObj.ContactId=coObj.id;
      insert oppContObj;       
      Account accObj=new Account();
      accObj.Name='sumit';
      insert accObj;
      /*Opp_Product__c oppProObj=new Opp_Product__c();
      oppProObj.Opportunity__c=oppObj.id;
      insert oppProObj;*/
      String oppId=oppObj.id;
      String accId=accObj.id;
      NewQuotationAccCtrl.newQuotationMethod(accId);
    }
}
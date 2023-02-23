@isTest
private class CloneSPRTest {
    public static TestMethod void Test(){
        Account accObj=new Account();
        accObj.Name='sumit';
        insert accObj;
        Special_Price_Request__c SPRObj= new Special_Price_Request__c();
        SPRObj.Account__c=accObj.id;
        SPRObj.CurrencyIsoCode='USD';
        insert SPRObj;
        Special_Price_Request_Product__c SPRProObj =new Special_Price_Request_Product__c(); 
        SPRProObj.Special_Price_Request__c=SPRObj.id;
        SPRProObj.CurrencyIsoCode='USD';
        insert  SPRProObj;      
        CloneSPR.cloneSPRConform(SPRObj.id);
    }
}
public class Opportunity_Product_Controller {
    public Id oppId;
    public List<Opp_Product__c> oppProdList{get;set;}
    public Opportunity_Product_Controller(ApexPages.StandardController controller){
        oppId = ApexPages.currentPage().getParameters().get('id');
        system.debug('oppId: '+oppId);
        oppProdList = new List<Opp_Product__c>();
        Id recTypeId = Schema.SObjectType.Opp_Product__c.getRecordTypeInfosByDeveloperName().get('Opp_Product_Tashang').getRecordTypeId(); 
        oppProdList = [select Id,Name,Ordering_Code__c,Product_Center__c,Use_Restriction__c,Revenue__c,Contribution__c,Status__c,Ranking__c,
                       Unit_Price__c,Annual_Quantity__c from Opp_Product__c where Opportunity__c =: oppId and RecordTypeId =: recTypeId];
        
		system.debug('oppProdList:'+oppProdList);
    }

}
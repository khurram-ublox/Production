public with sharing class NewCompetitorPriceCtrl {
    public Opp_Product__c oppProduct{get;set;} 
    public Id ids{get;set;}
    public NewCompetitorPriceCtrl(ApexPages.StandardSetController controller) {
        ids=ApexPages.currentPage().getParameters().get('id');
        if(ids!=null){
            oppProduct=[Select id,Annual_Quantity__c,Name from Opp_Product__c where id=:ids];
         }         
    }

}
public with sharing class NewPriceCtrl {
    public Competitor_Product__c compProduct{get;set;} 
    public Id ids{get;set;}
    public NewPriceCtrl(ApexPages.StandardSetController stdSetController) {
        ids=ApexPages.currentPage().getParameters().get('id');
        if(ids!=null){
            compProduct=[Select id,Competitor__c,Competitor__r.Name,Name from Competitor_Product__c where id=:ids];
         }   
    }

}
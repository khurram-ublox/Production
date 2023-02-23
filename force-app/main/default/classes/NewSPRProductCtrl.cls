public with sharing class NewSPRProductCtrl {
    public Special_Price_Request__c sprObj{get;set;} 
    public Id ids{get;set;}
    public NewSPRProductCtrl(ApexPages.StandardSetController controller) {
      ids=ApexPages.currentPage().getParameters().get('id');
        if(ids!=null){
            sprObj=[Select id,Name,CurrencyIsoCode from Special_Price_Request__c where id=:ids];
         }
    }

}
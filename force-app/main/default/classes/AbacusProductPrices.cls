public class AbacusProductPrices{
	
    @AuraEnabled
    public String id{get; set;}
    @AuraEnabled
    public String link{get; set;}
    @AuraEnabled
    public String productId{get; set;}
    @AuraEnabled
    public String productLink{get; set;}
    @AuraEnabled
    public String name{get; set;}
  
    @AuraEnabled
    public String conditionNumber{get; set;}
    @AuraEnabled
    public String priceCurrency{get; set;}
    @AuraEnabled
    public String customerCategory{get; set;}
    @AuraEnabled
    public Integer customerGroupNumber{get; set;}
    @AuraEnabled
    public String productCategory{get; set;}
    @AuraEnabled
    public String startDate{get; set;}
    @AuraEnabled
    public Decimal seriesToAmount{get; set;}
    @AuraEnabled
    public Decimal seriesPrice{get; set;}
    @AuraEnabled
    public String orderingNumber{get; set;}
    
    public AbacusProductPrices()
    {
    }

}
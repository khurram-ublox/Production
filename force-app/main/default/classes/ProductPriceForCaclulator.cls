public class ProductPriceForCaclulator {

    @AuraEnabled
    public String priceCurrency{get; set;}
    @AuraEnabled
    public Decimal amount{get; set;}
    @AuraEnabled
    public Decimal priceMod{get; set;}
    @AuraEnabled
    public Decimal priceSampleSize1{get; set;}
    @AuraEnabled
    public Decimal priceSampleSize10{get; set;}
    @AuraEnabled
    public Decimal priceSampleSize50{get; set;}
    @AuraEnabled
    public Decimal priceSampleSize100{get; set;}
    @AuraEnabled
    public Decimal priceSampleSize250{get; set;}
    @AuraEnabled
    public Decimal priceSampleSize500{get; set;}
    @AuraEnabled
    public Decimal priceSampleSize1000{get; set;}
    @AuraEnabled
    public Date validFrom{get; set;}
     
    public ProductPriceForCaclulator()
    {
    }
}
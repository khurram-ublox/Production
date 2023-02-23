@isTest
public class updateIPROnProductTest {

    public static testMethod void testProdIPR(){
        
        // Create new Product with mandatory fields (Product Center undefined)
        Product2 prod = new Product2(Name='Test Product', Type_No__C='Test Type Number', Packaging_Size__c=1, Family='Other', Positioning_Engine__c='Not applicable', CurrencyIsoCode='USD', COGS_1__c=20, COGS_Pct__c=0);
        insert prod;

        // Create new IPR Cost
        IPR_Cost__c iprc = new IPR_Cost__c(Name='Test IPR Cost', Consumer_USD__c=1,M2M_USD__c=2,Telematics_USD__c=3,Handset_USD__c=4,Laptop_USD__c=5,Other_USD__c=6,Consumer_Pct__c=1,M2M_Pct__c=2,Telematics_Pct__c=3,Handset_Pct__c=4,Laptop_Pct__c=5,Other_Pct__c=6);
        insert iprc;
        
        prod.IPR_Cost__c = iprc.Id;
        update prod;

        List<Product2> updatedProd = [
            SELECT IPR_USD_Consumer__c,IPR_USD_M2M__c,IPR_USD_Telematics__c,IPR_USD_Handset__c,IPR_USD_Laptop__c,IPR_USD_Other__c,
                IPR_Pct_Consumer__c,IPR_Pct_M2M__c,IPR_Pct_Telematics__c,IPR_Pct_Handset__c,IPR_Pct_Laptop__c,IPR_Pct_Other__c,
                IPR_Cost__r.Consumer_USD__c,IPR_Cost__r.M2M_USD__c,IPR_Cost__r.Telematics_USD__c,IPR_Cost__r.Handset_USD__c,IPR_Cost__r.Laptop_USD__c,IPR_Cost__r.Other_USD__c,
                IPR_Cost__r.Consumer_Pct__c,IPR_Cost__r.M2M_Pct__c,IPR_Cost__r.Telematics_Pct__c,IPR_Cost__r.Handset_Pct__c,IPR_Cost__r.Laptop_Pct__c,IPR_Cost__r.Other_Pct__c
            FROM Product2
            WHERE IPR_Cost__c = :prod.Id];
        
        for(Product2 a : updatedProd){

            System.assertEquals(a.IPR_Cost__r.Consumer_USD__c, a.IPR_USD_Consumer__c);
            System.assertEquals(a.IPR_Cost__r.M2M_USD__c, a.IPR_USD_M2M__c);
            System.assertEquals(a.IPR_Cost__r.Telematics_USD__c, a.IPR_USD_Telematics__c);
            System.assertEquals(a.IPR_Cost__r.Handset_USD__c, a.IPR_USD_Handset__c);
            System.assertEquals(a.IPR_Cost__r.Laptop_USD__c, a.IPR_USD_Laptop__c);
            System.assertEquals(a.IPR_Cost__r.Other_USD__c, a.IPR_USD_Other__c);
            System.assertEquals(a.IPR_Cost__r.Consumer_Pct__c, a.IPR_Pct_Consumer__c);
            System.assertEquals(a.IPR_Cost__r.M2M_Pct__c, a.IPR_Pct_M2M__c);
            System.assertEquals(a.IPR_Cost__r.Telematics_Pct__c, a.IPR_Pct_Telematics__c);
            System.assertEquals(a.IPR_Cost__r.Handset_Pct__c, a.IPR_Pct_Handset__c);
            System.assertEquals(a.IPR_Cost__r.Laptop_Pct__c, a.IPR_Pct_Laptop__c);
            System.assertEquals(a.IPR_Cost__r.Other_Pct__c, a.IPR_Pct_Other__c);

//            System.assertEquals(1, 1);
        }
    }
}
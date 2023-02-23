@IsTest
public class IPRCostTriggerHandlerTest {
	
    Public static testMethod void afterInsertTest (){


/*
		IPR_Cost__c i = new IPR_Cost__c();
        i.Name = 'test';
        //i.Type_No__c = 'NEO-M8U-06B-00';
        i.Consumer_USD__c = 1;
        i.M2M_USD__c = 2;
        i.Telematics_USD__c = 3;
        i.Handset_USD__c  = 4;
        i.Laptop_USD__c = 5;
        i.Other_USD__c = 6;
        i.Consumer_Pct__c = 7;
        i.M2M_Pct__c = 8;
        i.Telematics_Pct__c = 9;
        i.Handset_Pct__c = 10;
        i.Laptop_Pct__c = 11;
        i.Other_Pct__c = 12;
		i.Prime_Pct__c = 13;      
        i.Prime_USD__c = 14;

		insert i;      
        
		Product2 p2 = new Product2();
        p2.Name = 'test';
        p2.Type_No__c = 'NEO-M8U-06B-00';
        p2.IPR_USD_Consumer__c = i.Consumer_USD__c;
		p2.IPR_USD_M2M__c = 2;
		p2.IPR_USD_Telematics__c = 3;
        p2.IPR_USD_Handset__c = 4;
        p2.IPR_USD_Laptop__c = 5;
        p2.IPR_USD_Other__c = 6;
        p2.IPR_Pct_Consumer__c = 7;
        p2.IPR_Pct_M2M__c = 8;
        p2.IPR_Pct_Telematics__c = 9;
        p2.IPR_Pct_Handset__c = 10;
        p2.IPR_Pct_Laptop__c = 11;
        p2.IPR_Pct_Laptop__c = 12;
        p2.IPR_Pct_Other__c = 13;
        p2.IPR_Pct_Prime__c = 14;
        p2.IPR_USD_Prime__c = 15;
        
		insert p2;  
        
        List<Product2> prodList1 = new List<Product2>();
        List<Product2> prodList2 = new List<Product2>();
        
       		prodList2 = [SELECT IPR_USD_Consumer__c,IPR_USD_M2M__c,IPR_USD_Telematics__c,IPR_USD_Handset__c,
                           	IPR_USD_Laptop__c,IPR_USD_Other__c, IPR_Pct_Consumer__c,IPR_Pct_M2M__c,IPR_Pct_Telematics__c,
							IPR_Pct_Handset__c,IPR_Pct_Laptop__c,IPR_Pct_Other__c, IPR_Pct_Prime__c, IPR_USD_Prime__c, 
							IPR_Cost__r.Consumer_USD__c,IPR_Cost__r.M2M_USD__c,IPR_Cost__r.Telematics_USD__c,
                           	IPR_Cost__r.Handset_USD__c,IPR_Cost__r.Laptop_USD__c,IPR_Cost__r.Other_USD__c,
                			IPR_Cost__r.Consumer_Pct__c,IPR_Cost__r.M2M_Pct__c,IPR_Cost__r.Telematics_Pct__c,
                           	IPR_Cost__r.Handset_Pct__c,	IPR_Cost__r.Laptop_Pct__c,IPR_Cost__r.Other_Pct__c,
                			IPR_Cost__r.Prime_Pct__c, IPR_Cost__r.Prime_USD__c
        					FROM Product2];
        
        if(!prodList2.isempty()){
            for(Product2 list1: prodList2){
            //list1.prodList1 = prodList2;
        }
    }
     
*/
        
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
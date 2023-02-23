trigger updateIPROnProduct on IPR_Cost__c (after insert, after update) {

    List<Product2> ProductsToCheck = [
        SELECT  IPR_USD_Consumer__c,IPR_USD_M2M__c,IPR_USD_Telematics__c,IPR_USD_Handset__c,IPR_USD_Laptop__c,IPR_USD_Other__c,
                IPR_Pct_Consumer__c,IPR_Pct_M2M__c,IPR_Pct_Telematics__c,IPR_Pct_Handset__c,IPR_Pct_Laptop__c,IPR_Pct_Other__c, IPR_Pct_Prime__c, IPR_USD_Prime__c,
                IPR_Cost__r.Consumer_USD__c,IPR_Cost__r.M2M_USD__c,IPR_Cost__r.Telematics_USD__c,IPR_Cost__r.Handset_USD__c,IPR_Cost__r.Laptop_USD__c,IPR_Cost__r.Other_USD__c,
                IPR_Cost__r.Consumer_Pct__c,IPR_Cost__r.M2M_Pct__c,IPR_Cost__r.Telematics_Pct__c,IPR_Cost__r.Handset_Pct__c,IPR_Cost__r.Laptop_Pct__c,IPR_Cost__r.Other_Pct__c,
                IPR_Cost__r.Prime_Pct__c, IPR_Cost__r.Prime_USD__c
        FROM Product2
        WHERE IPR_Cost__c IN :Trigger.newMap.keySet()];

    List<Product2> ProductsToUpdate = new List<Product2>{};

    for(Product2 a: ProductsToCheck){

        Integer updateflag = 0;

        if(a.IPR_USD_Consumer__c <> a.IPR_Cost__r.Consumer_USD__c){
            a.IPR_USD_Consumer__c = a.IPR_Cost__r.Consumer_USD__c;
            updateflag++;  
        }
        if(a.IPR_USD_M2M__c <> a.IPR_Cost__r.M2M_USD__c){
            a.IPR_USD_M2M__c = a.IPR_Cost__r.M2M_USD__c;
            updateflag++;
        }
        if(a.IPR_USD_Telematics__c <> a.IPR_Cost__r.Telematics_USD__c){
            a.IPR_USD_Telematics__c = a.IPR_Cost__r.Telematics_USD__c;
            updateflag++;
        }
        if(a.IPR_USD_Handset__c <> a.IPR_Cost__r.Handset_USD__c){
            a.IPR_USD_Handset__c = a.IPR_Cost__r.Handset_USD__c;
            updateflag++;
        }
        if(a.IPR_USD_Laptop__c <> a.IPR_Cost__r.Laptop_USD__c){
            a.IPR_USD_Laptop__c = a.IPR_Cost__r.Laptop_USD__c;
            updateflag++;
        }
        if(a.IPR_USD_Other__c <> a.IPR_Cost__r.Other_USD__c){
            a.IPR_USD_Other__c = a.IPR_Cost__r.Other_USD__c;
            updateflag++;
        }
        if(a.IPR_USD_Prime__c <> a.IPR_Cost__r.Prime_USD__c){
            a.IPR_USD_Prime__c = a.IPR_Cost__r.Prime_USD__c;
            updateflag++;
        }
        if(a.IPR_Pct_Consumer__c <> a.IPR_Cost__r.Consumer_Pct__c){
            a.IPR_Pct_Consumer__c = a.IPR_Cost__r.Consumer_Pct__c;
            updateflag++;  
        }
        if(a.IPR_Pct_M2M__c <> a.IPR_Cost__r.M2M_Pct__c){
            a.IPR_Pct_M2M__c = a.IPR_Cost__r.M2M_Pct__c;
            updateflag++;
        }
        if(a.IPR_Pct_Telematics__c <> a.IPR_Cost__r.Telematics_Pct__c){
            a.IPR_Pct_Telematics__c = a.IPR_Cost__r.Telematics_Pct__c;
            updateflag++;
        }
        if(a.IPR_Pct_Handset__c <> a.IPR_Cost__r.Handset_Pct__c){
            a.IPR_Pct_Handset__c = a.IPR_Cost__r.Handset_Pct__c;
            updateflag++;
        }
        if(a.IPR_Pct_Laptop__c <> a.IPR_Cost__r.Laptop_Pct__c){
            a.IPR_Pct_Laptop__c = a.IPR_Cost__r.Laptop_Pct__c;
            updateflag++;
        }
        if(a.IPR_Pct_Other__c <> a.IPR_Cost__r.Other_Pct__c){
            a.IPR_Pct_Other__c = a.IPR_Cost__r.Other_Pct__c;
            updateflag++;
        }
        if(a.IPR_Pct_Prime__c <> a.IPR_Cost__r.Prime_Pct__c){
            a.IPR_Pct_Prime__c = a.IPR_Cost__r.Prime_Pct__c;
            updateflag++;
        }
        
        if (updateflag>0){
            ProductsToUpdate.add(a);
        }

    }

    update ProductsToUpdate;

}
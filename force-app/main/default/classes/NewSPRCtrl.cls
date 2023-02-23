public Without Sharing class  NewSPRCtrl {

    @AuraEnabled
    public static Map<String, String> getIds(Id recordId){
        Map<String, String> mapping = new Map<String, String>{};
        mapping.put('AccountId', recordId);
        mapping.put('OpportunityId', '');

        Opportunity[] o = [Select AccountId from Opportunity where Id = :recordId];   
        if(!o.isEmpty()) {
            mapping.put('AccountId', o[0].AccountId);
            mapping.put('OpportunityId', recordId);
        }

        return mapping;
    }
    
    @AuraEnabled
    public static String save(Special_Price_Request__c sp){
        String rId = ''; 
        
        Account a = [Select Id, Name, OppCloseDate__c, Delivery_Terms__c, Abacus_Payterms__c, CurrencyIsoCode from Account Where Id = :sp.Account__c];
        String AccountId = sp.Account__c;
        Date OppCloseDate = a.OppCloseDate__c;
        String PayTerms = a.Abacus_Payterms__c;
        String DelTerms = a.Delivery_Terms__c;
        String SPRCurrency = a.CurrencyIsoCode;
        Id OpportunityId = sp.Opportunity__c;
        
        if(OpportunityId!=null) {
            Opportunity o = [SELECT Name, CurrencyIsoCode, OwnerId, CloseDate FROM Opportunity WHERE Id = :OpportunityId];
        	SPRCurrency = o.CurrencyIsoCode;
        	OppCloseDate = o.CloseDate;
        }


        Special_Price_Request__c spr = new Special_Price_Request__c(
            Account__c = AccountId,
            CurrencyIsoCode = SPRCurrency,
            Payment__c = PayTerms,
            Delivery__c = DelTerms,
            Price_Level__c = sp.Price_Level__c,
            Comment_by_Requestor__c = sp.Comment_by_Requestor__c,
            Prices_Valid_Until__c = sp.Prices_Valid_Until__c
        );
        if(OpportunityId!=null) spr.Opportunity__c = OpportunityId;
        insert spr;
        
        if(OpportunityId!=null && spr.Id != null) {
            Map<Id,Id> maps = new Map<Id,Id>(); 
            
            //Loop through the Opp Products in the records set
            for(Opp_Product__c op: [SELECT Id, Product__c, Annual_Quantity__c, Unit_Price__c, Use_Restriction__c, IPR_Coverage__c, CurrencyIsoCode FROM Opp_Product__c WHERE Opportunity__c = :OpportunityId AND Status__c != 'Lost']){
                
                Special_Price_Request_Product__c sprp =new Special_Price_Request_Product__c();    
                sprp.Special_Price_Request__c = spr.Id;
                sprp.Product__c = op.Product__c;
                sprp.Year_P1__c = OppCloseDate;
                sprp.Quantity_P1__c = op.Annual_Quantity__c;
                sprp.Unit_Price_P1__c = op.Unit_Price__c;
                sprp.Use_Restriction__c = op.Use_Restriction__c;
                sprp.IPR_Coverage__c = op.IPR_Coverage__c;
                sprp.CurrencyIsoCode = op.CurrencyIsoCode;
                insert sprp; 
                
                if(sprp.Id != null) {
                    // map of opp products and sprp to use in Competitor_Product_Price__c 
                    maps.put(op.Id,sprp.Id);
                }
            }     
            
            if(!maps.isEmpty()) {
                List<Competitor_Product_Price__c> lstCP = new list<Competitor_Product_Price__c>();
                
            	for(Competitor_Product_Price__c  cp: [SELECT Id, Opp_Product__c, Special_Price_Request_Product__c FROM Competitor_Product_Price__c WHERE Opp_Product__c IN :maps.keySet()]) {
                	Competitor_Product_Price__c cps = new Competitor_Product_Price__c(); 
                    cps.Id = cp.Id;
                    cps.Special_Price_Request_Product__c = maps.get(cp.Opp_Product__c);
                    
                    lstCP.add(cps);
                }
                                                      
                if(!lstCP.isEmpty()) {
                    update(lstCP);
                }                                         
            }
        }
    
        rId = spr.Id; 
        return rId;
    }
        
}
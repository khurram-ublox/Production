public class QuoteObjectTriggerHandler {
    public static void addContactDetails(list<Quote> quoteObj){
        set<Id> opportunityIds = new set<Id>();
        map<Id,OpportunityContactRole> opportunityContacts = new map<Id, OpportunityContactRole>();
        map<Id,Opportunity> quoteOpportunity = new map<Id, Opportunity>();
        for(Quote Q : quoteObj){
            opportunityIds.add(Q.OpportunityId);
        }
        for(Opportunity opp : [Select Id, Name, OwnerId, AccountId, OppAutoNumber__c from Opportunity where Id IN : opportunityIds]){
            quoteOpportunity.put(opp.Id,Opp);
        }

        for(OpportunityContactRole ocr : [SELECT ContactId,
                                                    OpportunityId,
                                                    Contact.Phone, 
                                                    Contact.Fax, 
                                                    Contact.Email, 
                                                    IsPrimary 
                                                FROM OpportunityContactRole 
                                                WHERE OpportunityId IN : opportunityIds
                                                AND Role = 'Contact Quotation'
                                                AND IsPrimary = true]){
            opportunityContacts.put(ocr.OpportunityId, ocr);
        }
        for(Quote Q : quoteObj){
            if(!quoteOpportunity.isEmpty() && quoteOpportunity.get(Q.OpportunityId) != null){
                //Q.Name = quoteOpportunity.get(Q.OpportunityId).Name + '-u-blox-';
                Q.OwnerId = quoteOpportunity.get(Q.OpportunityId).OwnerId;            
            }
            
            if(Q.ContactId == NULL && !opportunityContacts.isEmpty() && opportunityContacts.get(Q.OpportunityId) != NULL){
                Q.ContactId = opportunityContacts.get(Q.OpportunityId).ContactId;
                Q.Email = opportunityContacts.get(Q.OpportunityId).Contact.Email;
                Q.Phone = opportunityContacts.get(Q.OpportunityId).Contact.Phone;
                Q.Fax = opportunityContacts.get(Q.OpportunityId).Contact.Fax;
            }
        }
    }

    public static void addPriceBook(list<Quote> quoteObj){
        List<pricebook2> priceBookList = new List<pricebook2>();
        priceBookList = [SELECT Id from pricebook2 WHERE name = 'Standard Price Book' Limit 1];
        if(priceBookList.size() > 0){
            for(Quote Q : quoteObj){               
                Q.pricebook2Id = priceBookList[0].Id;
            }
        }
    }

    public static List<QuoteLineItem> createQuoteLienItem(List<Quote> quoteObj){
        List<String> productIds = new List<String>();
        List<quoteLineItem> quoteLineItemList = new List<quoteLineItem>();
        map<String,String> quoteOppIds = new map<String, String>();
        map<String,String> prodPBEMap = new map<String,String>();
        map<String,List<opp_product__c>> oppIdProdMap = new map<String, List<opp_product__c>>();
        
        for(quote tempQuote : quoteObj){
            quoteOppIds.put(tempQuote.Id,tempQuote.opportunityId);
        }
        
        for(opp_product__c tempProd : [SELECT Id,
                                                Opportunity__c, 
                                                product__c,
                                                Annual_Quantity__c, 
                                                Unit_Price__c,
                                                Use_Restriction__c, 
                                                IPR_Coverage__c 
                                                FROM opp_product__c 
                                                WHERE opportunity__c IN :quoteOppIds.values()
                                                AND Status__c != 'Lost']){
            if(oppIdProdMap.get(tempProd.Opportunity__c) == null){
                oppIdProdMap.put(tempProd.Opportunity__c,new List<opp_product__c>() );
            }
            oppIdProdMap.get(tempProd.Opportunity__c).add(tempProd);
            productIds.add(tempProd.product__c);
        }
        
        for(PricebookEntry pe :[SELECT Id,CurrencyIsoCode , Product2Id
                                FROM PricebookEntry
                                WHERE Product2Id IN:productIds
                                AND IsActive = true])
        {
            String PBEKey = pe.Product2Id + pe.CurrencyIsoCode;
            prodPBEMap.put(PBEKey,pe.Id);
        }
                
        for(quote tempQuote :quoteObj){
            if(oppIdProdMap.size() > 0 && oppIdProdMap.get(tempQuote.OpportunityId) != null){
                for(Opp_Product__c tempOppProd : oppIdProdMap.get(tempQuote.OpportunityId)  ){
                    String PBEKey = tempOppProd.Product__c + tempQuote.CurrencyIsoCode;
                    quoteLineItem quoteLineItemObj = new quoteLineItem();
                    quoteLineItemObj.QuoteId = tempQuote.Id;
                    quoteLineItemObj.Quantity = tempOppProd.Annual_Quantity__c;
                    quoteLineItemObj.UnitPrice = tempOppProd.Unit_Price__c;
                    quoteLineItemObj.Use_Restriction__c = tempOppProd.Use_Restriction__c;
                    quoteLineItemObj.IPR_Coverage__c = tempOppProd.IPR_Coverage__c;
                    quoteLineItemObj.PriceBookEntryId = prodPBEMap.get(PBEKey);
                    quoteLineItemList.add(quoteLineItemObj);
                }
            }
        }
        return quoteLineItemList;
    }   
}
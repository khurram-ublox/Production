public with sharing class QuotationSPRCtrl {

    private static ID StdPricebookId() {
        if(Test.isRunningTest())   
        return Test.getStandardPricebookId();
        return StdPriceBook().id;    
    } 
    
    private static Pricebook2  StdPriceBook () {
        List<pricebook2> stdPriceBook = new List<pricebook2>();                       
        stdPriceBook    = [select id, name from Pricebook2 where isStandard = true AND name = 'Standard Price Book' limit 1];
        return stdPriceBook[0];    
    }

    @AuraEnabled
    public static Id getSPRid(string sprId){      // void getSPRid(string sprId) {
        Quote newQuote = new Quote();
        Special_Price_Request__c spr;
        
        if(!string.isEmpty(sprId)){
            
            User currentUser = [Select 
                                    uB_Office__c, 
                                    Alias 
                                    From User Where id=:UserInfo.getUserId() limit 1];

            // SPR fields required for NewQuotation
            // Approved_By_Team_Manager__c added in query on 11-19-2021 (IN_SF_MTC-858)
            spr = [Select Id, 
                        Approved_By_Regional_Head__c, 
                        Price_Level__c, 
                        Status__c, 
                        CurrencyIsoCode, 
                        Opportunity__c,
                        Opportunity__r.OppAutoNumber__c,
                        Opportunity__r.Name,
                        Opportunity__r.OwnerId, 
                        Contact__c,
                        Contact__r.Email,
                        Contact__r.Phone,
                        Contact__r.Fax,
                        Quotation_Account_ID__c, 
                        Account__c, 
                        Quotation_Account__c, 
                        Delivery__c, Payment__c,
                        Approved_By_Team_Manager__c
                        FROM Special_Price_Request__c WHERE Id =:sprId limit 1];        
            
            Id sprAccId = spr.Account__c;
            Id sprConId = spr.Contact__c;
            string PriceLevel = spr.Price_Level__c;
            if(spr.Opportunity__c == NULL){
                throw new AuraHandledException('Missing Opportunity on SPR, Quote can not be created without Opportunity');
            }

            if (spr.Status__c !='Approved' && spr.Price_Level__c == 'PPP (Project Price Plan)'){
                throw new AuraHandledException('This request has not yet been approved.');               
                
            }else if (spr.Price_Level__c == 'MSP (Minimum Sales Price)' 
                        && spr.Approved_By_Regional_Head__c == false 
                        && (currentUser.uB_Office__c == 'Americas' 
                            || currentUser.uB_Office__c == 'EMEA' 
                            || currentUser.uB_Office__c == 'Corporate') 
                        && (currentUser.Alias != 'egui' && currentUser.Alias != 'npap')) {       
                throw new AuraHandledException('This request has not yet been approved by Regional Head (required in Americas, EMEA).');

            }else if (spr.Price_Level__c == 'MSP (Minimum Sales Price)' 
                        && spr.Approved_By_Regional_Head__c == false 
                        && spr.Approved_By_Team_Manager__c == false 
                        && (currentUser.uB_Office__c != 'Americas' 
                            && currentUser.uB_Office__c != 'EMEA' 
                            && currentUser.uB_Office__c != 'Corporate') 
                        && (currentUser.Alias != 'atan' 
                            && currentUser.Alias != 'mchi' 
                            && currentUser.Alias != 'shki' 
                            && currentUser.Alias != 'tnak' 
                            && currentUser.Alias != 'tzho' 
                            && currentUser.Alias != 'ntha' 
                            && currentUser.Alias != 'psbi' 
                            && currentUser.Alias != 'sguo')) {  
                throw new AuraHandledException('This request has not yet been approved by Country Manager (required in APAC).');
            }else{

                // from Account
                list<Account> quotAcc = [Select 
                                    Name, 
                                    OppCloseDate__c, 
                                    Abacus_Payterms__c, 
                                    CurrencyIsoCode, 
                                    OwnerId 
                                    From Account Where id=:spr.Quotation_Account_ID__c limit 1];
                                                    
                // Get standard price book
                                              
                
                //New Quote
                newQuote = new Quote(
                    Name = spr.Opportunity__c != NULL && spr.Opportunity__r.OppAutoNumber__c != NULL ? spr.Opportunity__r.Name+'-u-blox-QR-'+spr.Opportunity__r.OppAutoNumber__c:spr.Opportunity__c != NULL ? spr.Opportunity__r.Name:quotAcc[0].Name,
                    OpportunityId = spr.Opportunity__c,                   
                    Quotation_Account__c = sprAccId,
                    Special_Price_Request__c = spr.id,
                    CurrencyIsoCode = spr.CurrencyIsoCode,
                    Type_of_quotation__c = 'Quotation',
                    Delivery__c = spr.Delivery__c,
                    Payment__c = spr.Payment__c != NULL ? spr.Payment__c:quotAcc[0].Abacus_Payterms__c,
                    OwnerId = spr.Opportunity__c != NULL ? spr.Opportunity__r.OwnerId:quotAcc[0].OwnerId,
                    ContactId = spr.Contact__c,
                    Email = spr.Contact__c != NULL ? spr.Contact__r.Email:NULL,
                    Phone = spr.Contact__c != NULL ? spr.Contact__r.Phone:NULL,
                    Fax = spr.Contact__c != NULL ? spr.Contact__r.Fax:NULL,                    
                    pricebook2Id = StdPricebookId()
                );
                System.debug('newQuote >>>'+newQuote);
                try {
                    insert newQuote;                    
                }catch(DmlException e){
                    throw new AuraHandledException(e.getMessage());                    
                }

                /*  PricebookEntry  */
                // Query SPRP 
                               
                Id newQuotId = newQuote.Id;
                list<quoteLineItem> quoteProducts = new list<quoteLineItem>();
                for(Special_Price_Request_Product__c pbSPRP : [SELECT Id, 
                                                                Product__c, 
                                                                Quantity_P1__c, 
                                                                Quantity_P2__c, 
                                                                Quantity_P3__c, 
                                                                Quantity_P4__c, 
                                                                Quantity_P5__c, 
                                                                Unit_Price_P1__c, 
                                                                Unit_Price_P2__c, 
                                                                Unit_Price_P3__c, 
                                                                Unit_Price_P4__c, 
                                                                Unit_Price_P5__c, 
                                                                Year_P1__c, 
                                                                Year_P2__c, 
                                                                Year_P3__c, 
                                                                Year_P4__c, 
                                                                Year_P5__c, 
                                                                Use_Restriction__c, 
                                                                IPR_Coverage__c 
                                                                FROM Special_Price_Request_Product__c 
                                                                WHERE Special_Price_Request__c=:spr.id])
                {
                    PricebookEntry pricebook;
                    try {
                        pricebook = [SELECT Id 
                                     FROM PricebookEntry 
                                     WHERE Product2Id=:pbSPRP.Product__c 
                                     AND CurrencyIsoCode =:spr.CurrencyIsoCode limit 1];
                    } catch(QueryException e){
                        throw new AuraHandledException('Pricebook is not associated with the following product: ' +pbSPRP.Product__c);
                    }
                    System.debug('pricebook >>> '+pricebook);
                    // if price bood records exist
                    if(pricebook != null){
                        if(pbSPRP.Quantity_P1__c != null){
                            quoteLineItem quoteLineItem1 = new quoteLineItem();
                            quoteLineItem1.QuoteId = newQuotId;
                            quoteLineItem1.PriceBookEntryId = pricebook.Id;
                            quoteLineItem1.Quantity = pbSPRP.Quantity_P1__c;
                            quoteLineItem1.UnitPrice = pbSPRP.Unit_Price_P1__c;
                            quoteLineItem1.Year_Date__c = pbSPRP.Year_P1__c;
                            quoteLineItem1.Use_Restriction__c = pbSPRP.Use_Restriction__c;
                            quoteLineItem1.IPR_Coverage__c = pbSPRP.IPR_Coverage__c;
                            quoteLineItem1.Price_Level__c = spr.Price_Level__c;
                            quoteLineItem1.Special_Price_Request_Product__c = pbSPRP.Id;
                            quoteProducts.add(quoteLineItem1);
                        }                        
                        if(pbSPRP.Quantity_P2__c != null){
                            quoteLineItem quoteLineItem2 = new quoteLineItem();
                            quoteLineItem2.QuoteId = newQuotId;
                            quoteLineItem2.PriceBookEntryId = pricebook.Id;
                            quoteLineItem2.Quantity = pbSPRP.Quantity_P2__c;
                            quoteLineItem2.UnitPrice = pbSPRP.Unit_Price_P2__c;
                            quoteLineItem2.Year_Date__c = pbSPRP.Year_P2__c;
                            quoteLineItem2.Use_Restriction__c = pbSPRP.Use_Restriction__c;
                            quoteLineItem2.IPR_Coverage__c = pbSPRP.IPR_Coverage__c;
                            quoteLineItem2.Price_Level__c = spr.Price_Level__c;
                            quoteLineItem2.Special_Price_Request_Product__c = pbSPRP.Id;
                            quoteProducts.add(quoteLineItem2);
                        }
                        if(pbSPRP.Quantity_P3__c != null){
                            quoteLineItem quoteLineItem3 = new quoteLineItem();
                            quoteLineItem3.QuoteId = newQuotId;
                            quoteLineItem3.PriceBookEntryId = pricebook.Id;
                            quoteLineItem3.Quantity = pbSPRP.Quantity_P3__c;
                            quoteLineItem3.UnitPrice = pbSPRP.Unit_Price_P3__c;
                            quoteLineItem3.Year_Date__c = pbSPRP.Year_P3__c;
                            quoteLineItem3.Use_Restriction__c = pbSPRP.Use_Restriction__c;
                            quoteLineItem3.IPR_Coverage__c = pbSPRP.IPR_Coverage__c;
                            quoteLineItem3.Price_Level__c = spr.Price_Level__c;
                            quoteLineItem3.Special_Price_Request_Product__c = pbSPRP.Id;
                            quoteProducts.add(quoteLineItem3);                            
                        }
                        if(pbSPRP.Quantity_P4__c != null){
                            quoteLineItem quoteLineItem4 = new quoteLineItem();
                            quoteLineItem4.QuoteId = newQuotId;
                            quoteLineItem4.PriceBookEntryId = pricebook.Id;
                            quoteLineItem4.Quantity = pbSPRP.Quantity_P4__c;
                            quoteLineItem4.UnitPrice = pbSPRP.Unit_Price_P4__c;
                            quoteLineItem4.Year_Date__c = pbSPRP.Year_P4__c;
                            quoteLineItem4.Use_Restriction__c = pbSPRP.Use_Restriction__c;
                            quoteLineItem4.IPR_Coverage__c = pbSPRP.IPR_Coverage__c;
                            quoteLineItem4.Price_Level__c = spr.Price_Level__c;
                            quoteLineItem4.Special_Price_Request_Product__c = pbSPRP.Id;
                            quoteProducts.add(quoteLineItem4);
                        }
                        if(pbSPRP.Quantity_P5__c != null){
                            quoteLineItem quoteLineItem5 = new quoteLineItem();
                            quoteLineItem5.QuoteId = newQuotId;
                            quoteLineItem5.PriceBookEntryId = pricebook.Id;
                            quoteLineItem5.Quantity = pbSPRP.Quantity_P5__c;
                            quoteLineItem5.UnitPrice = pbSPRP.Unit_Price_P5__c;
                            quoteLineItem5.Year_Date__c = pbSPRP.Year_P5__c;
                            quoteLineItem5.Use_Restriction__c = pbSPRP.Use_Restriction__c;
                            quoteLineItem5.IPR_Coverage__c = pbSPRP.IPR_Coverage__c;
                            quoteLineItem5.Price_Level__c = spr.Price_Level__c;
                            quoteLineItem5.Special_Price_Request_Product__c = pbSPRP.Id;
                            quoteProducts.add(quoteLineItem5);                           
                        }
                    }                                
                }
                system.debug('quoteProducts >>>'+quoteProducts);
                try {
                    if(quoteProducts.size() > 0){
                        database.insert(quoteProducts, true);
                    }
                }catch(DMLException ex) {
                    throw new AuraHandledException(ex.getMessage());
                }                
            }
            return newQuote.Id;
        }else{
            throw new AuraHandledException('Missing SPR record id from the request');
        }
    }
}
public with sharing class NewQuotationSPRCtrl {

    @AuraEnabled
    public static Id getSPRid(string sprId){      // void getSPRid(string sprId) {
        Opportunity newQuot = new Opportunity();
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
                        Contact__c, 
                        Quotation_Account_ID__c, 
                        Account__c, 
                        Quotation_Account__c, 
                        Delivery__c, Payment__c,
                        Approved_By_Team_Manager__c
                        FROM Special_Price_Request__c WHERE Id =:sprId limit 1];        
            
            Id sprAccId = spr.Account__c;
            Id sprConId = spr.Contact__c;
            string PriceLevel = spr.Price_Level__c;

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
                                                    
                // Create new Opportunity of Quotation record type
                
                //Insert operation
                newQuot.Quotation_Account__c = sprAccId; //spr[0].Account__c; .id
                newQuot.AccountId = sprAccId;
                newQuot.Special_Price_Request__c = spr.id;
                newQuot.Referred_Opportunity_Account__c = spr.Account__c; //
                newQuot.Delivery_del__c = spr.Delivery__c;
                newQuot.CurrencyIsoCode = spr.CurrencyIsoCode; //spr[0].CurrencyIsoCode;
                newQuot.Type_of_quotation__c = 'Quotation';
                newQuot.RecordTypeId = Schema.sObjectType.Opportunity.getRecordTypeInfosByName().get('Quotation').getRecordTypeId(); // Quotation record type Id 01220000000CqRdAAK
                newQuot.StageName = '3 Calling on';

                if(!string.isEmpty(spr.Payment__c)){
                    newQuot.Payment__c = spr.Payment__c;
                }else if(!quotAcc.isEmpty()){
                    newQuot.Payment__c = quotAcc[0].Abacus_Payterms__c;
                }
                if(!string.isEmpty(spr.Opportunity__c)){
                    // SPR Opportunity
                    id oppId = spr.Opportunity__c;
                    Opportunity quotOpp = [SELECT Name,
                                        CurrencyIsoCode, 
                                        OwnerId, 
                                        CloseDate 
                                        FROM Opportunity WHERE Id=:oppId];
                    newQuot.Name = quotOpp.Name;
                    newQuot.CloseDate = quotOpp.CloseDate;
                    newQuot.OwnerId = quotOpp.OwnerId;
                }else if(!quotAcc.isEmpty()){
                    newQuot.Name = quotAcc[0].Name;
                    newQuot.CloseDate = quotAcc[0].OppCloseDate__c;
                    newQuot.OwnerId = quotAcc[0].OwnerId;
                }

                try {
                    insert newQuot;                    
                }catch(DmlException e){
                    throw new AuraHandledException(e.getMessage());                    
                }

                /*  PricebookEntry  */
                // Query SPRP 
                               
                Id newQuotId = newQuot.Id;
                list<OpportunityLineItem> quoteProducts = new list<OpportunityLineItem>();
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
                    
                    // if price bood records exist
                    if(pricebook != null){
                        OpportunityLineItem oppLinItem = new OpportunityLineItem();
                        oppLinItem.OpportunityId = newQuotId;
                        oppLinItem.PricebookEntryId = pricebook.Id;
                        oppLinItem.Quantity = pbSPRP.Quantity_P1__c;
                        oppLinItem.UnitPrice = pbSPRP.Unit_Price_P1__c;
                        oppLinItem.Year_Date__c = pbSPRP.Year_P1__c;
                        oppLinItem.Use_Restriction__c = pbSPRP.Use_Restriction__c;
                        oppLinItem.IPR_Coverage__c = pbSPRP.IPR_Coverage__c;
                        oppLinItem.Price_Level__c = spr.Price_Level__c;
                        oppLinItem.Special_Price_Request_Product__c = pbSPRP.Id;
                        quoteProducts.add(oppLinItem);
                                
                        
                        if(pbSPRP.Quantity_P2__c != null){
                            OpportunityLineItem oppLinItem2 = new OpportunityLineItem();
                            oppLinItem2.OpportunityId = newQuotId;
                            oppLinItem2.PriceBookEntryId = pricebook.Id; 
                            oppLinItem2.Quantity = pbSPRP.Quantity_P2__c;
                            oppLinItem2.UnitPrice = pbSPRP.Unit_Price_P2__c;
                            oppLinItem2.Year_Date__c= pbSPRP.Year_P2__c;
                            oppLinItem2.Use_Restriction__c = pbSPRP.Use_Restriction__c;
                            oppLinItem2.IPR_Coverage__c = pbSPRP.IPR_Coverage__c;
                            oppLinItem2.Price_Level__c = spr.Price_Level__c;
                            oppLinItem2.Special_Price_Request_Product__c = pbSPRP.Id;
                            quoteProducts.add(oppLinItem2);    
                        }
                        if(pbSPRP.Quantity_P3__c != null){
                            OpportunityLineItem oppLinItem3 = new OpportunityLineItem();
                            oppLinItem3.OpportunityId = newQuotId;
                            oppLinItem3.PriceBookEntryId = pricebook.Id; 
                            oppLinItem3.Quantity = pbSPRP.Quantity_P3__c;
                            oppLinItem3.UnitPrice = pbSPRP.Unit_Price_P3__c;
                            oppLinItem3.Year_Date__c= pbSPRP.Year_P3__c;
                            oppLinItem3.Use_Restriction__c = pbSPRP.Use_Restriction__c;
                            oppLinItem3.IPR_Coverage__c = pbSPRP.IPR_Coverage__c;
                            oppLinItem3.Price_Level__c = spr.Price_Level__c;
                            oppLinItem3.Special_Price_Request_Product__c = pbSPRP.Id;                            
                            quoteProducts.add(oppLinItem3);
                        }
                        if(pbSPRP.Quantity_P4__c != null){
                            OpportunityLineItem oppLinItem4 = new OpportunityLineItem();
                            oppLinItem4.OpportunityId = newQuotId;
                            oppLinItem4.PriceBookEntryId = pricebook.Id; 
                            oppLinItem4.Quantity = pbSPRP.Quantity_P4__c;
                            oppLinItem4.UnitPrice = pbSPRP.Unit_Price_P4__c;
                            oppLinItem4.Year_Date__c= pbSPRP.Year_P4__c;
                            oppLinItem4.Use_Restriction__c = pbSPRP.Use_Restriction__c;
                            oppLinItem4.IPR_Coverage__c = pbSPRP.IPR_Coverage__c;
                            oppLinItem4.Price_Level__c = spr.Price_Level__c;
                            oppLinItem4.Special_Price_Request_Product__c = pbSPRP.Id;
                            quoteProducts.add(oppLinItem4);
                        }
                        if(pbSPRP.Quantity_P5__c != null){
                            OpportunityLineItem oppLinItem5 = new OpportunityLineItem();
                            oppLinItem5.OpportunityId = newQuotId;
                            oppLinItem5.PriceBookEntryId = pricebook.Id; 
                            oppLinItem5.Quantity = pbSPRP.Quantity_P5__c;
                            oppLinItem5.UnitPrice = pbSPRP.Unit_Price_P5__c;
                            oppLinItem5.Year_Date__c= pbSPRP.Year_P5__c;
                            oppLinItem5.Use_Restriction__c = pbSPRP.Use_Restriction__c;
                            oppLinItem5.IPR_Coverage__c = pbSPRP.IPR_Coverage__c;
                            oppLinItem5.Price_Level__c = spr.Price_Level__c;
                            oppLinItem5.Special_Price_Request_Product__c = pbSPRP.Id;                            
                            quoteProducts.add(oppLinItem5);
                        }
                    }                                
                }
                if(quoteProducts.size() > 0){
                    database.insert(quoteProducts, false);
                }        
                        
                /* Add Contact Role that is added as Contact in the Special Price Request. */
                        
                if(sprConId != null){
                    OpportunityContactRole QuotationCR = new OpportunityContactRole();
                    QuotationCR.ContactId = sprConId;
                    QuotationCR.IsPrimary = true;
                    QuotationCR.OpportunityId = newQuotId;
                    QuotationCR.Role = 'Contact Quotation';
                    try {
                        insert QuotationCR;
                    } catch(DmlException e){
                        throw new AuraHandledException(e.getMessage());
                    }
                }
            }
            return newQuot.Id;
        }else{
            throw new AuraHandledException('Missing SPR record id from the request');
        }
    }
}
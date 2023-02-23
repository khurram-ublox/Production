/*
* Apex Controller for New Opportunity button in Account object in Lightning
* 
* Date: 27/09/2019Author: ldra
* */

public class NewQuotationCtrl {
    
    @AuraEnabled
    public static Account getAccount(Id recordId){
        
        if(!string.isEmpty(recordId)){
            if(recordId.getsobjecttype().getDescribe().getName()=='Opportunity'){
                recordId = [Select Opportunity_Account__c from Opportunity where id=:recordId LIMIT 1].Opportunity_Account__c;
            }
            Account a = [Select Id, Name, OppCloseDate__c, Abacus_Payterms__c from Account Where id=:recordId];   
            return a;
        }
        return null;
    }
    
    @AuraEnabled
    public static Map<String,Boolean> checkBusinessUnit(Id oppId){
        Map<String,Boolean> businessUnitMap = new Map<String,Boolean>();
        List<Opp_Product__c> oppProdList = new List<Opp_Product__c>();
        oppProdList = [Select Id,Product_Center__c,Product__r.BusinessUnit__c from Opp_Product__c where Opportunity__c =: oppId];
        
        businessUnitMap.put('Tashang',false);
        businessUnitMap.put('u-blox',false);
        
        for(Opp_Product__c oppProd : oppProdList){
            if(oppProd.Product__r.BusinessUnit__c == 'Tashang'){
                businessUnitMap.put('Tashang',true);
            }
            
            if(oppProd.Product__r.BusinessUnit__c == 'u-blox') {
                businessUnitMap.put('u-blox',true);
			}
            
        }
        return businessUnitMap;
    }
    
    @AuraEnabled
    public static Id save(Opportunity o, String objectName){
        return NewQuotationCtrl.save(o,null,'objectName');
    }
    
    @AuraEnabled
    public static Id save(Opportunity o,Opportunity tashangOpp, String objectName){
        system.debug('#### o : ' + o);
        system.debug('#### objectName : ' + objectName);
        String OpportunityId = '';
        Id ownerId = null;
        List<OpportunityContactRole> ocrAll = new List<OpportunityContactRole>{};
            
            // ----- Owner is changed in trigger - updateOpportunityOwner
            // if(objectName=='Opportunity') ownerId = [Select OwnerId from Opportunity Where id=:o.Referred_Opportunity__c].OwnerId;
            // else ownerId = [Select OwnerId from Account Where id=:o.Quotation_Account__c].OwnerId;
            // o.OwnerId = ownerId;
            // 
            /*o.AccountId = o.Quotation_Account__c;
insert o;*/
            
            // if it is from opportunity, create OpportunityLineItem entries from Product2Id
            //if(objectName=='Opportunity') {
            //For each parent product business unit, corrsponsding list of Opp_Product__c
            map<string,list<Opp_Product__c>> mapProductBU_ProductList = new map<string,list<Opp_Product__c>>();
        	set<Id> setAllRequiredProductIds = new set<Id>();
        
         OpportunityId = o != null ? o.Referred_Opportunity__c : tashangOpp != null ?  tashangOpp.Referred_Opportunity__c : '';
        
        //#1 get all opportunity products and store them per business unit + store all required products
        for(Opp_Product__c opp : [SELECT Id, Product__c, Annual_Quantity__c, Unit_Price__c, Use_Restriction__c, IPR_Coverage__c,Product__r.BusinessUnit__c,Opportunity__r.CurrencyIsoCode
                                  FROM Opp_Product__c 
                                  WHERE Opportunity__c = :OpportunityId
                                  AND Product__c != null ] )
        {
            string BusinessUnit = opp.Product__r.BusinessUnit__c;
            BusinessUnit = (BusinessUnit == null ? '' : BusinessUnit);
            if(mapProductBU_ProductList.get(BusinessUnit) == null)
            {
                mapProductBU_ProductList.Put(BusinessUnit, new list<Opp_Product__c>());
            }
            mapProductBU_ProductList.get(BusinessUnit).Add(opp);
            setAllRequiredProductIds.Add(opp.Product__c);
        }
        
        //#2 list all available PricebookEntries per ProductId and currency
        map<string,map<Id,PricebookEntry>> mapCurrency_mapProduct2IdAndPriocebookEntry = new map<string,map<Id,PricebookEntry>>();
        for(PricebookEntry pe :[SELECT Id,CurrencyIsoCode , Product2Id
                                FROM PricebookEntry
                                WHERE Product2Id IN:setAllRequiredProductIds
                                AND IsActive = true])
        {
            if(mapCurrency_mapProduct2IdAndPriocebookEntry.get(pe.CurrencyIsoCode) == null)
            {
                mapCurrency_mapProduct2IdAndPriocebookEntry.put(pe.CurrencyIsoCode, new map<Id,PricebookEntry>());
            }
            mapCurrency_mapProduct2IdAndPriocebookEntry.get(pe.CurrencyIsoCode).put(pe.Product2Id, pe);
        }
        
        //#3 insert new Opportunities
        map<string,Opportunity> mapProductBU_NewQuotation = new map<string,Opportunity>();
        for(string BusinessUnit:mapProductBU_ProductList.Keyset())
        {
            //Changes made on 23rd Jan 
            //Opportunity newQuotation = o.clone(false,true,false,false);
            Opportunity newQuotation = new Opportunity(); //o.clone(false,true,false,false);
            if(BusinessUnit == 'Tashang'){
                newQuotation = tashangOpp.clone(false,true,false,false);
            }else{
                newQuotation = o.clone(false,true,false,false);
            }
           
            //Changes Completed
            newQuotation.AccountId = newQuotation.Quotation_Account__c;
            newQuotation.BusinessUnit__c = BusinessUnit;
            newQuotation.Name = newQuotation.Name + '-' + BusinessUnit;
            newQuotation.Name = (newQuotation.Name.Length() > 80 ? '...' + newQuotation.Name.Right(77) : newQuotation.Name);
            mapProductBU_NewQuotation.put(BusinessUnit,newQuotation);
        }
        if(mapProductBU_NewQuotation.Values().size() > 0){
        	insert mapProductBU_NewQuotation.Values();    
        }else{
            Opportunity newQuotation = new Opportunity();
            newQuotation = o.clone(false,true,false,false);
            system.debug('newQuotation.Quotation_Account__c--->>'+newQuotation.Quotation_Account__c);
            //Changes Completed for Account's New Quotation button
            newQuotation.Name = (newQuotation.Name.Length() > 80 ? '...' + newQuotation.Name.Right(77) : newQuotation.Name);
            newQuotation.accountId = newQuotation.Quotation_Account__c;
            newQuotation.Referred_Opportunity__c = NULL;
            newQuotation.Name +='-u-blox ';
            
            insert newQuotation;
             OpportunityId = newQuotation.Id;
        }
       
        
        //Changes done on 27th April
        List<Opportunity> oppList = [select Id,Name,OppAutoNumber__c   from Opportunity where Id IN:mapProductBU_NewQuotation.values() OR Id =: OpportunityId];
        
        for(Opportunity opp : oppList){
            opp.Name += '-QR' + opp.OppAutoNumber__c ; 
        }
        if(!oppList.isEmpty()){
            update oppList;
		}
        // Changes completed
        //#4 construct the list of new OpportunityLineItems
        List<OpportunityLineItem> oplAll = new List<OpportunityLineItem>{};
            
            for(string businessUnit:mapProductBU_ProductList.Keyset())
        {	//For eeach source business unit, retrieve the inserted opportunity/quotation, and 
            //build from it the proper opportunity line item for erach Opp_Product__c
            opportunity parentOpportunity = mapProductBU_NewQuotation.get(businessUnit);
            for(Opp_Product__c opp : mapProductBU_ProductList.get(businessUnit))
            {
                //Find available priocebookEntries for the currency
                map<Id,PricebookEntry> mapAvailablePricebookEntries = mapCurrency_mapProduct2IdAndPriocebookEntry.get(opp.Opportunity__r.CurrencyIsoCode);
                if(mapAvailablePricebookEntries != null)
                {
                    //Find the available pricebookEntry for this currency AND this product
                    PricebookEntry pe = mapAvailablePricebookEntries.get(opp.Product__c);
                    if(pe != null)
                    {
                        OpportunityLineItem opl = new OpportunityLineItem(
                            OpportunityId = parentOpportunity.Id,
                            PriceBookEntryId = pe.Id,
                            Quantity = opp.Annual_Quantity__c,
                            UnitPrice = opp.Unit_Price__c,
                            Use_Restriction__c = opp.Use_Restriction__c,
                            IPR_Coverage__c = opp.IPR_Coverage__c
                        );
                        oplAll.add(opl);
                    }
                }
            }
        }
        insert oplAll;
        //} // end if opportunity
        
        // ------ refresh contact roles ------
        // 1. first remove contact roles for newly created quotation
        List<OpportunityContactRole> contactRoles = [SELECT Id FROM OpportunityContactRole WHERE OpportunityId IN: mapProductBU_NewQuotation.Values()];
        delete contactRoles;
        
        // 2. then copy contact roles from parent (first opportunity, then account)
        OpportunityContactRole[] ocrExisting = [SELECT ContactId, IsPrimary FROM OpportunityContactRole WHERE Role = 'Contact Quotation' AND OpportunityId =: OpportunityId];
        if(!ocrExisting.isEmpty()) {
            for(OpportunityContactRole ocr : ocrExisting) {
                for(Opportunity newQuotation:mapProductBU_NewQuotation.Values())
                {
                    OpportunityContactRole ocrSingle = new OpportunityContactRole(
                        ContactId = ocr.ContactId,
                        IsPrimary = ocr.IsPrimary,
                        OpportunityId = newQuotation.Id,
                        Role = 'Contact Quotation'
                    );
                    ocrAll.add(ocrSingle);
                }
            }
        }
        else {
            Id oppAccountId = o != null ? o.AccountId : tashangOpp != null ?  tashangOpp.AccountId : '';
            AccountContactRole[] acrExisting = [SELECT ContactId, IsPrimary FROM AccountContactRole WHERE Role = 'Contact Commercial' AND AccountId =: oppAccountId];
            for(AccountContactRole acr : acrExisting) {
                for(Opportunity newQuotation:mapProductBU_NewQuotation.Values())
                {
                    OpportunityContactRole ocrSingle = new OpportunityContactRole(
                        ContactId = acr.ContactId,
                        IsPrimary = acr.IsPrimary,
                        OpportunityId = newQuotation.Id,
                        Role = 'Contact Quotation'
                    );
                    ocrAll.add(ocrSingle);
                }
            }
        }
        
        insert ocrAll;
        
        //Return new QUotationId only if one, and only one, opportunity has been created.Othezrwise, return source opportunity
        
        return (mapProductBU_NewQuotation.Size() == 1 ? mapProductBU_NewQuotation.Values()[0].Id : OpportunityId);//o.Id;
    }
    
}
/*public class NewQuotationCtrl {

@AuraEnabled
public static Account getAccount(Id recordId){

if(!string.isEmpty(recordId)){
if(recordId.getsobjecttype().getDescribe().getName()=='Opportunity'){
recordId = [Select Opportunity_Account__c from Opportunity where id=:recordId LIMIT 1].Opportunity_Account__c;
}
Account a = [Select Id, OppCloseDate__c, Abacus_Payterms__c from Account Where id=:recordId];   
return a;
}
return null;
}

@AuraEnabled
public static Id save(Opportunity o, String objectName){
String OpportunityId = '';
Id ownerId = null;
List<OpportunityContactRole> ocrAll = new List<OpportunityContactRole>{};

// ----- Owner is changed in trigger - updateOpportunityOwner
// if(objectName=='Opportunity') ownerId = [Select OwnerId from Opportunity Where id=:o.Referred_Opportunity__c].OwnerId;
// else ownerId = [Select OwnerId from Account Where id=:o.Quotation_Account__c].OwnerId;
// o.OwnerId = ownerId;
// 
o.AccountId = o.Quotation_Account__c;
insert o;

// if it is from opportunity, create OpportunityLineItem entries from Product2Id
if(objectName=='Opportunity') {
OpportunityId = o.Referred_Opportunity__c;
List<OpportunityLineItem> oplAll = new List<OpportunityLineItem>{};

for(Opp_Product__c opp : [SELECT Id, Product__c, Annual_Quantity__c, Unit_Price__c, Use_Restriction__c, IPR_Coverage__c FROM Opp_Product__c WHERE Opportunity__c = :OpportunityId] ) {
PricebookEntry[] pe = [SELECT Id FROM PricebookEntry WHERE Product2Id = :opp.Product__c AND CurrencyIsoCode = :o.CurrencyIsoCode AND IsActive = true];
if(!pe.isEmpty()) {
OpportunityLineItem opl = new OpportunityLineItem(
OpportunityId = o.Id,
PriceBookEntryId = pe[0].Id,
Quantity = opp.Annual_Quantity__c,
UnitPrice = opp.Unit_Price__c,
Use_Restriction__c = opp.Use_Restriction__c,
IPR_Coverage__c = opp.IPR_Coverage__c
);
oplAll.add(opl);
}
}
insert oplAll;
} // end if opportunity

// ------ refresh contact roles ------
// 1. first remove contact roles for newly created quotation
List<OpportunityContactRole> contactRoles = [SELECT Id FROM OpportunityContactRole WHERE OpportunityId =: o.Id];
delete contactRoles;

// 2. then copy contact roles from parent (first opportunity, then account)
OpportunityContactRole[] ocrExisting = [SELECT ContactId, IsPrimary FROM OpportunityContactRole WHERE Role = 'Contact Quotation' AND OpportunityId =: OpportunityId];
if(!ocrExisting.isEmpty()) {
for(OpportunityContactRole ocr : ocrExisting) {
OpportunityContactRole ocrSingle = new OpportunityContactRole(
ContactId = ocr.ContactId,
IsPrimary = ocr.IsPrimary,
OpportunityId = o.Id,
Role = 'Contact Quotation'
);
ocrAll.add(ocrSingle);
}
}
else {
AccountContactRole[] acrExisting = [SELECT ContactId, IsPrimary FROM AccountContactRole WHERE Role = 'Contact Commercial' AND AccountId =: o.AccountId];
for(AccountContactRole acr : acrExisting) {
OpportunityContactRole ocrSingle = new OpportunityContactRole(
ContactId = acr.ContactId,
IsPrimary = acr.IsPrimary,
OpportunityId = o.Id,
Role = 'Contact Quotation'
);
ocrAll.add(ocrSingle);
}
}

insert ocrAll;


return o.Id;
}

}*/
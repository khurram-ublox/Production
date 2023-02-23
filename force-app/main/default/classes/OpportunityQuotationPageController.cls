/*
 * Apex Controller for New Quotation button in Account object in Lightning
 * 
 * Date: 2019/11/06
 * Author: PARX-ogu
 * */
public class OpportunityQuotationPageController {
    
    public Opportunity currentRecord {get;set;}    //Current Opporutnity
    public Opportunity QuotationTemplate {get;set;} //Template Oppportunity for Quotation
    public Opportunity TashangQuotationTemplate {get;set;} // Tashang Template Opportunity 
    public List<Opp_Product__c> oppProdList{get;set;}
    public Boolean checkTashang{get;set;}
    public Boolean checkUblox{get;set;}
    public OpportunityQuotationPageController(apexPages.StandardController sc)
    {
        //Fetch current record's information
        Id currentRecordId = sc.getRecord().Id;
        oppProdList = new List<Opp_Product__c>();
        checkTashang = false;
        checkUblox = false;
        currentRecord = [SELECT Id, 
                         Name,
                         OppAutoNumber__c ,
                         CurrencyIsoCode,
                         AccountId,
                         CloseDate,
                         Account.OppCloseDate__c,
                         Account.Abacus_Payterms__c
                         FROM Opportunity
                         WHERE Id =:currentRecordId];
        oppProdList = [Select Id,Product_Center__c,Product__r.BusinessUnit__c from Opp_Product__c where Opportunity__c =: currentRecordId];
        
        for(Opp_Product__c oppProd : oppProdList){
            if(oppProd.Product__r.BusinessUnit__c == 'Tashang')checkTashang = true;
            
            if(oppProd.Product__r.BusinessUnit__c == 'u-blox') checkUblox = true;
            
        }
        system.debug('currentRecord: '+currentRecord.CurrencyIsoCode);
        //Initialize template quotation from current Opportunity
        QuotationTemplate = new Opportunity(
            CurrencyIsoCode          = currentRecord.CurrencyIsoCode,
            Name               = currentRecord.Name,
            Quotation_Account__c       = currentRecord.AccountId,
            Referred_Opportunity_Account__c = currentRecord.AccountId,
            AccountId             = currentRecord.AccountId,
            Referred_Opportunity__c     = currentRecord.Id,
            CloseDate             = currentRecord.Account.OppCloseDate__c,
            RecordTypeId           = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Quotation').getRecordTypeId(),
            Payment__c             = currentRecord.Account.Abacus_Payterms__c,
            StageName             = '3 Calling on'
        );
        
        // Initialize Template Quotation for Tashang from Current Opportunity
        if(checkTashang){
             TashangQuotationTemplate = new Opportunity(
                CurrencyIsoCode          = currentRecord.CurrencyIsoCode,
                Name               = currentRecord.Name,
                Quotation_Account__c       = currentRecord.AccountId,
                Referred_Opportunity_Account__c = currentRecord.AccountId,
                AccountId             = currentRecord.AccountId,
                Referred_Opportunity__c     = currentRecord.Id,
                CloseDate             = currentRecord.Account.OppCloseDate__c,
                RecordTypeId           = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Quotation').getRecordTypeId(),
                Payment__c             = currentRecord.Account.Abacus_Payterms__c,
                StageName             = '3 Calling on'
            );
      }
    }
    
    //Return to previous opportunity
    public pageReference doCancel()
    {
        pageReference pageRef = new pageReference('/' + currentRecord.Id);
        pageRef.SetRedirect(true);
        return pageRef;
    }
    
    //Save and return
    public pageReference doSave()
    {
        try{
            Id newQuotationId = NewQuotationCtrl.save(QuotationTemplate,TashangQuotationTemplate,'Opportunity');
            pageReference pageRef = new pageReference('/' + (newQuotationId != null ? newQuotationId : currentRecord.Id));
            pageRef.SetRedirect(true);
            return pageRef;
        }catch(DMLException ex){
            for(Integer i=0;i<ex.getNumDml();i++){           
                ApexPages.addmessage(new ApexPages.message(ApexPages.SEVERITY.FATAL, ex.getDmlMessage(i)));
            }
        }
        return null;
    }
}
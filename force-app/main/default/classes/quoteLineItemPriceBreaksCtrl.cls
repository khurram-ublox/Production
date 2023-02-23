public class quoteLineItemPriceBreaksCtrl {

    public string quoteId    {get; set;}
    public QuoteLineItem quoteLookupId  {get; set;}
    public boolean showQuoteLookup  {get; set;}{
        showQuoteLookup = false;
    }
    public list<QuoteLineItem> quoteLineItems    {get; set;}
    public map<Id, list<priceBreaksWrapper>> multiPriceBreaks {get; set;}
    public integer counter  {get; set;}
    private string newQuoteId;
    
    public quoteLineItemPriceBreaksCtrl(ApexPages.StandardSetController controller) {
        quoteId = ApexPages.currentPage().getParameters().get('id');
        newQuoteId = quoteId;
        initialize();        
    }

    public void addPriceBreaksFromExistingQuote(){
        quoteId = quoteLookupId.QuoteId;        
        initialize();
    }

    private void initialize(){
        if(!Schema.sObjectType.Quote_Multi_Price_Breaks__c.isAccessible()){
            throw new ApexException('You do not have permission to multi price break object, This is only for Automotive Products Quote for Sales Americas');
        }
        if(quoteId == NULL){
            throw new ApexException('Id can not be null');
        }
        
        quoteLineItems = lineItemsList();
        if(quoteLineItems.size() > 0){                
            multiPriceBreaks = addExistingItems(quoteLineItems);
        }else{
            quoteLookupId = new QuoteLineItem();            
            showQuoteLookup = true;
        }
    }

    private list<QuoteLineItem> lineItemsList(){
        
        list<QuoteLineItem> lineItems = new list<QuoteLineItem>();
        lineItems = [SELECT Id, 
                                QuoteId, 
                                Product2Id, 
                                Product2.Name, 
                                Product2.ProductCode, 
                                UnitPrice,CurrencyIsoCode,
                                Quantity,Suggested_resale__c,IPR_Coverage__c,
                                Use_Restriction__c,Price_Level__c,PricebookEntryId,
                                (Select Id,Quote__c,Product__c,Price_Sample_1k__c,Price_Sample_100__c,
                                Price_Sample_4k__c,Price_Sample_50k__c,Price_Sample_100k__c,Price_Sample_250k__c,
                                Price_Sample_500k__c,Price_Sample_1000k__c,Quote_Line_Item__c,Year__c from Price_Breaks__r ORDER BY Year__c ASC)
                                FROM QuoteLineItem WHERE QuoteId =: quoteId];
            
        return lineItems;
    }
    
    private map<Id, list<priceBreaksWrapper>> addExistingItems(list<QuoteLineItem> quoteLineItems){
        map<Id, list<priceBreaksWrapper>> quotePriceBreaks = new map<Id, list<priceBreaksWrapper>>();
        integer counter;
        for(QuoteLineItem item : quoteLineItems){            
            list<priceBreaksWrapper> wrapperList = new list<priceBreaksWrapper>();
            counter = 0;            
            if(item.Price_Breaks__r.size() > 0){
                for(Quote_Multi_Price_Breaks__c pb : item.Price_Breaks__r){
                    priceBreaksWrapper priceBreakWrapper = new priceBreaksWrapper();
                    priceBreakWrapper.productName = item.Product2.Name;
                    priceBreakWrapper.orderingCode = item.Product2.ProductCode;
                    priceBreakWrapper.priceBreak = pb;
                    counter++;
                    wrapperList.add(priceBreakWrapper);                    
                }
                if(counter < 5){
                    for(priceBreaksWrapper wrapper : addPriceBreaks(item, 5-counter)){
                        wrapperList.add(wrapper);
                    }
                }
            }else wrapperList = addPriceBreaks(item, 5);
            
            if (!quotePriceBreaks.containsKey(item.Id)){
                quotePriceBreaks.put(item.Id, new list<priceBreaksWrapper>());
            }
            quotePriceBreaks.put(item.Id, wrapperList);             
        }
        return quotePriceBreaks;
    }

    private list<priceBreaksWrapper> addPriceBreaks(QuoteLineItem item, integer breakSize){        
        list<priceBreaksWrapper> wrapperList = new list<priceBreaksWrapper>();
        integer currentYear = System.today().Year();
        currentYear += 5-breakSize;
        for(integer i=0; i<breakSize; i++){
            priceBreaksWrapper priceBreakWrapper = new priceBreaksWrapper();
            priceBreakWrapper.productName = item.Product2.Name;
            priceBreakWrapper.orderingCode = item.Product2.ProductCode;
            priceBreakWrapper.priceBreak = new Quote_Multi_Price_Breaks__c(
                                                Quote__c = item.QuoteId,
                                                Product__c = item.Product2Id,
                                                Quote_Line_Item__c = item.Id,
                                                Year__c = string.valueOf(currentYear + i),
                                                CurrencyIsoCode = item.CurrencyIsoCode);
                                                wrapperList.add(priceBreakWrapper);            
        }
        return wrapperList; 
    }
       
    public Pagereference saveAll(){
        map<Id,QuoteLineItem> newQuoteItems = new map<Id,QuoteLineItem>();
        list<Quote_Multi_Price_Breaks__c> itemPriceBreaks = new list<Quote_Multi_Price_Breaks__c>();
        list<Quote_Multi_Price_Breaks__c> priceBreaksUpdate = new list<Quote_Multi_Price_Breaks__c>();

        if(showQuoteLookup){
            for(QuoteLineItem item :quoteLineItems){                
                newQuoteItems.put(item.Id, new QuoteLineItem(
                    QuoteId = newQuoteId,
                    Product2Id = item.Product2Id,
                    UnitPrice = item.UnitPrice,                    
                    Quantity = item.Quantity,
                    Suggested_resale__c = item.Suggested_resale__c,
                    IPR_Coverage__c = item.IPR_Coverage__c,
                    Use_Restriction__c = item.Use_Restriction__c,
                    Price_Level__c = item.Price_Level__c,
                    PricebookEntryId = item.PricebookEntryId                    
                ));
            }
            
            insert(newQuoteItems.values());
            for(Id key : newQuoteItems.keySet()){
                for(priceBreaksWrapper wrapper : multiPriceBreaks.get(key)){
                    if(wrapper.priceBreak.Year__c != null && 
                        (wrapper.priceBreak.Price_Sample_100__c != null 
                        || wrapper.priceBreak.Price_Sample_1k__c != null
                        || wrapper.priceBreak.Price_Sample_4k__c != null
                        || wrapper.priceBreak.Price_Sample_50k__c != null
                        || wrapper.priceBreak.Price_Sample_100k__c != null
                        || wrapper.priceBreak.Price_Sample_250k__c != null
                        || wrapper.priceBreak.Price_Sample_500k__c != null
                        || wrapper.priceBreak.Price_Sample_1000k__c != null)){
                        wrapper.priceBreak.Id = null;
                        wrapper.priceBreak.Quote__c = newQuoteId;
                        wrapper.priceBreak.Quote_Line_Item__c = newQuoteItems.get(key).Id;                        
                        itemPriceBreaks.add(wrapper.priceBreak);
                    }                    
                }
            }            
            insert(itemPriceBreaks);
        }else{
            for(QuoteLineItem item : quoteLineItems){
                for(priceBreaksWrapper wrapper : multiPriceBreaks.get(item.Id)){
                    if(wrapper.priceBreak.Year__c != null && 
                        (wrapper.priceBreak.Price_Sample_100__c != null 
                        || wrapper.priceBreak.Price_Sample_1k__c != null
                        || wrapper.priceBreak.Price_Sample_4k__c != null
                        || wrapper.priceBreak.Price_Sample_50k__c != null
                        || wrapper.priceBreak.Price_Sample_100k__c != null
                        || wrapper.priceBreak.Price_Sample_250k__c != null
                        || wrapper.priceBreak.Price_Sample_500k__c != null
                        || wrapper.priceBreak.Price_Sample_1000k__c != null)){
                        if(wrapper.priceBreak.Id != null){
                            priceBreaksUpdate.add(wrapper.priceBreak);
                        }else itemPriceBreaks.add(wrapper.priceBreak);                        
                    }
                }
            }
            update(quoteLineItems);
            update(priceBreaksUpdate);
            insert(itemPriceBreaks);            
        }
        return returnToQuote();
    }

    public Pagereference returnToQuote(){
        return new Pagereference('/'+newQuoteId);
    }

    public class priceBreaksWrapper{
        public string productName   {get; set;}
        public string orderingCode   {get; set;}
        public Quote_Multi_Price_Breaks__c priceBreak {get; set;}
        
    }
}
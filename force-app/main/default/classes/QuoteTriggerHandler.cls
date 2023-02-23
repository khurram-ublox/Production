public with sharing class QuoteTriggerHandler implements ITrigger {
    public List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
    list<Quote> quotes = new List<Quote>();
     public void prepareBefore(){}
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){}
    
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){}
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){}
    
    // Process logic/functioanlities in other classes for before insert  event
    public void beforeInsert(){       
        for(Quote q : (list<Quote>)trigger.new){
            if(q.Special_Price_Request__c == NULL){
                quotes.add(q);
            }
        }
        if(quotes.size() > 0){
            QuoteObjectTriggerHandler.addPriceBook(quotes);
            QuoteObjectTriggerHandler.addContactDetails(quotes);
        }
    }
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
        for(Quote q : (list<Quote>)trigger.new){
            if(q.Special_Price_Request__c == NULL){
                quotes.add(q);
            }
        }
        if(quotes.size() > 0){
            quoteLineItemList= QuoteObjectTriggerHandler.createQuoteLienItem(quotes);
        }        
    }
    public static boolean flag = true;
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){
    }
    
    // Process logic/functioanlities in other classes for after Delete event
    public void afterDelete(){}        
    
    //Finally do operations to Commit 
    public void finish(){
        insert quoteLineItemList;
    }
}
trigger QuoteLineItemTrigger on QuoteLineItem ( after insert) {
    TriggerFactory.createAndExecuteHandler(QuoteLineItemTriggerHandler.Class);
}
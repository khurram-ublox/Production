trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert) {
    TriggerFactory.createAndExecuteHandler(OpportunityLineItemTriggerHandler.Class);
}
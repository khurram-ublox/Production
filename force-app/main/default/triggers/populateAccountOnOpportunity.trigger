trigger populateAccountOnOpportunity on Opportunity (before insert) {
    
    PopulateOpportunityAccount.execute(Trigger.new);
}
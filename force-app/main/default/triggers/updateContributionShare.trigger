trigger updateContributionShare on Billings__c (before insert, before update) {

    // Update contribution share field on new/updated billings records
    BillingsTrigger.updateContributionShareOnBillings(Trigger.new, Trigger.oldMap);

}
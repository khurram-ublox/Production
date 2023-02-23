public with sharing class SalesCloud_ProjectOwnerSummaryCtrl extends SalesCloud_ProjectOwnerAccountSummary{
    public SalesCloud_ProjectOwnerSummaryCtrl() {

    }

    @AuraEnabled
    public static ProjectOwnerAccountSummaryWrapper getAccountSummary(Id AccountId){
        SalesCloud_ProjectOwnerAccountSummary summary = new SalesCloud_ProjectOwnerAccountSummary();
        return summary.BillingAndRevenue(AccountId);       
    }
}
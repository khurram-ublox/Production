public virtual class SalesCloud_ProjectOwnerAccountSummary {
    public SalesCloud_ProjectOwnerAccountSummary() {

    }
    
    public virtual ProjectOwnerAccountSummaryWrapper BillingAndRevenue(Id projectOwnerAccountId){
        ProjectOwnerAccountSummaryWrapper summary = new ProjectOwnerAccountSummaryWrapper();
        if(projectOwnerAccountId != null){            
            /* Booking Contribution calculations of all time in CHF */
            AggregateResult[] results = [Select SUM(Expected_Contribution_CHF__c)AMBookingsContribution                
                                                    from Billings__c 
                                                    where Project_Owner_Account__c =:projectOwnerAccountId
                                                    AND Order_Status__c = 'Open'
                                                    AND Frame_Order__c = false];
            double AMBookingsContributionChf = (double)results[0].get('AMBookingsContribution');
            AMBookingsContributionChf = AMBookingsContributionChf > 0 ? AMBookingsContributionChf : 0;

            /* Booking Revenue calculations of all time in CHF */
            AggregateResult[] results1 = [Select SUM(Total_Value_CHF__c)AMBookingsRevenue                
                                                    from Billings__c 
                                                    where Project_Owner_Account__c =:projectOwnerAccountId
                                                    AND Order_Status__c = 'Open'
                                                    AND Frame_Order__c = false];
            double AMBookingsRevenueChf = (double)results1[0].get('AMBookingsRevenue');
            AMBookingsRevenueChf = AMBookingsRevenueChf > 0 ? AMBookingsRevenueChf : 0;

            /* Billing Contribution calculations of last 365 days */
            AggregateResult[] results2 = [Select SUM(Total_Contribution_CHF__c)AMBillingsContributionTmt                
                                                    from Billings__c 
                                                    where Project_Owner_Account__c =:projectOwnerAccountId
                                                    AND Order_Status__c = 'Closed'
                                                    AND Invoice_Date__c >= LAST_N_DAYS:365];
            double AMBillingsContributionTmtChf = (double)results2[0].get('AMBillingsContributionTmt');
            AMBillingsContributionTmtChf = AMBillingsContributionTmtChf > 0 ? AMBillingsContributionTmtChf : 0;

            /* Billing Revenue calculations of last last 365 days */
            AggregateResult[] results3 = [Select SUM(Total_Value_CHF__c)AMBillingsRevenueTmt                
                                                    from Billings__c 
                                                    where Project_Owner_Account__c =:projectOwnerAccountId
                                                    AND Order_Status__c = 'Closed'
                                                    AND Invoice_Date__c >= LAST_N_DAYS:365];
            double AMBillingsRevenueTmtChf = (double)results3[0].get('AMBillingsRevenueTmt');
            AMBillingsRevenueTmtChf = AMBillingsRevenueTmtChf > 0 ? AMBillingsRevenueTmtChf : 0;

            /* AM Billing Contribution calculations of current fiscal year */
            AggregateResult[] results4 = [Select SUM(Total_Contribution_CHF__c)AMBillingsContributionYtd                
                                                    from Billings__c 
                                                    where Project_Owner_Account__c =:projectOwnerAccountId
                                                    AND Order_Status__c = 'Closed'
                                                    AND Invoice_Date__c >= THIS_FISCAL_YEAR];
            double AMBillingsContributionYtdChf = (double)results4[0].get('AMBillingsContributionYtd');
            AMBillingsContributionYtdChf = AMBillingsContributionYtdChf > 0 ? AMBillingsContributionYtdChf : 0;

            /* AM Billing Revenue calculations of current fiscal year */
            AggregateResult[] results5 = [Select SUM(Total_Value_CHF__c)AMBillingsRevenueYtd                
                                                    from Billings__c 
                                                    where Project_Owner_Account__c =:projectOwnerAccountId
                                                    AND Order_Status__c = 'Closed'
                                                    AND Invoice_Date__c >= THIS_FISCAL_YEAR];
            double AMBillingsRevenueYtdChf = (double)results5[0].get('AMBillingsRevenueYtd');
            AMBillingsRevenueYtdChf = AMBillingsRevenueYtdChf > 0 ? AMBillingsRevenueYtdChf : 0;

            /* AM Billing Contribution calculations of last fiscal year */
            AggregateResult[] results6 = [Select SUM(Total_Contribution_CHF__c)AMBillingsContributionPrevYr                
                                                    from Billings__c 
                                                    where Project_Owner_Account__c =:projectOwnerAccountId
                                                    AND Order_Status__c = 'Closed'
                                                    AND Invoice_Date__c >= LAST_FISCAL_YEAR];
            double AMBillingsContributionPrevYrChf = (double)results6[0].get('AMBillingsContributionPrevYr');
            AMBillingsContributionPrevYrChf = AMBillingsContributionPrevYrChf > 0 ? AMBillingsContributionPrevYrChf : 0;

            /* AM Billing Revenue calculations of last fiscal year */
            AggregateResult[] results7 = [Select SUM(Total_Value_CHF__c)AMBillingsRevenuePrevYr                
                                                    from Billings__c 
                                                    where Project_Owner_Account__c =:projectOwnerAccountId
                                                    AND Order_Status__c = 'Closed'
                                                    AND Invoice_Date__c >= LAST_FISCAL_YEAR];
            double AMBillingsRevenuePrevYrChf = (double)results7[0].get('AMBillingsRevenuePrevYr');
            AMBillingsRevenuePrevYrChf = AMBillingsRevenuePrevYrChf > 0 ? AMBillingsRevenuePrevYrChf : 0;

            list<Account> projectOwnerAccount = [Select Priority__c 
                                                    from Account 
                                                    where Id =: projectOwnerAccountId];
            
            string Priority;
            if(projectOwnerAccount[0].Priority__c != 'A'
                    && AMBillingsContributionTmtChf >= 800000){
                    Priority = 'A';
            }else if(projectOwnerAccount[0].Priority__c != 'B'
                    && AMBillingsContributionTmtChf < 800000
                    && AMBillingsContributionTmtChf >= 175000){
                    Priority = 'B';
            }else if((projectOwnerAccount[0].Priority__c == 'A' 
                    || projectOwnerAccount[0].Priority__c == 'B')
                    && AMBillingsContributionTmtChf < 175000){
                    Priority = 'CXZ';
            }else Priority = projectOwnerAccount[0].Priority__c;        
            
            summary.AMBookingsContributionChf = AMBookingsContributionChf;
            summary.AMBookingsRevenueChf = AMBookingsRevenueChf;
            summary.AMBillingsContributionTmtChf = AMBillingsContributionTmtChf;
            summary.AMBillingsRevenueTmtChf = AMBillingsRevenueTmtChf;
            summary.AMBillingsContributionYtdChf = AMBillingsContributionYtdChf;
            summary.AMBillingsRevenueYtdChf = AMBillingsRevenueYtdChf;
            summary.AMBillingsContributionPrevYrChf = AMBillingsContributionPrevYrChf;
            summary.AMBillingsRevenuePrevYrChf = AMBillingsRevenuePrevYrChf;
            summary.AMPrioChangeProposed = Priority;
        }
        return summary;
    }
    
    public class ProjectOwnerAccountSummaryWrapper {
        @AuraEnabled public double AMBookingsContributionChf {get; set;}
        @AuraEnabled public double AMBookingsRevenueChf {get; set;}
        @AuraEnabled public double AMBillingsContributionTmtChf {get; set;}
        @AuraEnabled public double AMBillingsRevenueTmtChf {get; set;}
        @AuraEnabled public double AMBillingsContributionYtdChf {get; set;}
        @AuraEnabled public double AMBillingsRevenueYtdChf {get; set;}
        @AuraEnabled public double AMBillingsContributionPrevYrChf {get; set;}
        @AuraEnabled public double AMBillingsRevenuePrevYrChf {get; set;}
        @AuraEnabled public string AMPrioChangeProposed {get; set;}        
    }
}
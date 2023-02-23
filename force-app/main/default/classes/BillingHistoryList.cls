public class BillingHistoryList {
    private static final string ACCOUNTOBJ = 'Account';
    private static final string OPEN = 'Open';
    private static final string CLOSED = 'Closed';
    public BillingHistoryList(){
    }
	@AuraEnabled
    public static Map<string, Map<Integer,BillingHistoryWrapper>> bHistoryOrders(Id recordId){
        Map<string, Map<Integer,BillingHistoryWrapper>> resmap = new Map<string, Map<Integer,BillingHistoryWrapper>>();
        if(recordId != null){       
            String sobjectType = recordId.getSObjectType().getDescribe().getName();
            if(sobjectType == ACCOUNTOBJ){
                List<Account> acc = [SELECT SF_Account_Number__c FROM Account WHERE id=:recordId Limit 1];            
                List<AggregateResult> aggriRes = [ SELECT SUM(Qty_Invoiced__c)QtyInvoiced, 
                                                  SUM(Total_Contribution_USD__c)TotalContributionUSD, 
                                                  SUM(Total_Value_USD__c)TotalValueUSD, 
                                                  CALENDAR_YEAR(Invoice_Date__c)InvoiceDate, 
                                                  Product__r.Product_Center__c 
                                                  From Billings__c 
                                                  Where
                                                  Invoice_Date__c >= LAST_N_YEARS:4 
                                                  AND ( Account__r.SF_Account_Number__c=:acc[0].SF_Account_Number__c OR SF_Account_Number__c=:acc[0].SF_Account_Number__c OR Project_Owner_SF_Acc_No__c =:acc[0].SF_Account_Number__c)
                                                  AND (Order_Status__c =:OPEN OR Order_Status__c =:CLOSED ) 
                                                  GROUP BY CALENDAR_YEAR(Invoice_Date__c), Product__r.Product_Center__c ];
                If( aggriRes.size() > 0 ) 
                {                   
                        set<string> pCenterSet = new set<string>();
                        set<integer> iDate = new set<integer>();
                        for(AggregateResult res: aggriRes ){
                            String productCenter =(String) res.get('Product_Center__c');
                            pCenterSet.add(productCenter);
                                if (!resmap.containsKey(productCenter)){
                                    resmap.put(productCenter, New Map<Integer,BillingHistoryWrapper>());
                                }
                            Map<Integer,BillingHistoryWrapper> currentProdMap = resmap.get(productCenter);
                                Integer invoiceDate =(Integer) res.get('InvoiceDate');
                                iDate.add(invoiceDate);                               
                                currentProdMap.put(invoiceDate, New BillingHistoryWrapper((Double)res.get('QtyInvoiced'),(Double)res.get('TotalContributionUSD'), (Double)res.get('TotalValueUSD')));
                                resmap.put(productCenter,currentProdMap);   
                        }
                        for(string c : pCenterSet){
                            for(integer i : iDate){
                                if(!resmap.get(c).containsKey(i)){
                                    Map<Integer,BillingHistoryWrapper> currentProdMap = resmap.get(c);
                                    currentProdMap.put(i,New BillingHistoryWrapper(0,0,0));
                                    resmap.put(c,currentProdMap);                                
                                }
                            }
                        }
                    }
                }
        }
            return resmap;

    }
    public class BillingHistoryWrapper {
        public  BillingHistoryWrapper(Double QtyInvo, Double TotCon, Double TotValUSD) {
          	this.QtyInvoiced = QtyInvo;
            this.TotalContributionUSDList = TotCon;
            this.TotalValueUSDList = TotValUSD;
       	}
	    @AuraEnabled
        public  Double QtyInvoiced {get; set;}
        @AuraEnabled
        public  Double TotalContributionUSDList {get; set;}
        @AuraEnabled
        public  Double TotalValueUSDList {get; set;}
        @AuraEnabled
        public  Double totalValues {get; set;}
      
	}
    /*
    public class ProductCenter {
        @AuraEnabled
        public string productCenter {get; set;}
        @AuraEnabled
        public list<Years> Years	{get; set;}
        @AuraEnabled
        public Double totalByProductCenter	{get; set;}
    }
    public class Years {
        @AuraEnabled
        public string Year	{get; set;}
        @AuraEnabled
        public BillingHistoryWrapper billing{get; set;}
    }
		*/
}
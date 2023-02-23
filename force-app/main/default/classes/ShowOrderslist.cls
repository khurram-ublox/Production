public class ShowOrderslist {

    private static final string ACCOUNTOBJ = 'Account';
    private static final string OPPRTUNITYOBJ = 'Opportunity';
    private static final string OPEN = 'Open';
    private static final string CLOSED = 'Closed';
    @AuraEnabled
    public static List<Billings__c> getOrders(Id recordId){
        Date deliverDateRange = Date.newInstance(2021,01,01);
        List<Billings__c> reportOrdersList = new List<Billings__c>();
        String sobjectType = recordId.getSObjectType().getDescribe().getName();

        // IF Record is Account
        if(sobjectType == ACCOUNTOBJ){
                    List<Account> acc = [SELECT SF_Account_Number__c FROM Account WHERE id=:recordId Limit 1];
            try{
                    reportOrdersList = [Select id, Name, 
                              Order_No__c, PO_No_Line_Item__c, Invoice_Number__c, 
                              Reference__c, Account__c,
                              Account__r.Name, Reporting_uB_Office__c, 
                              Order_Status__c, Product_ID__c, 
                              Frame_Order__c, Order_Date__c, 
                              Request_Date__c, Delivery_Date__c, 
                              Qty_Ordered__c, Qty_Invoiced__c, 
                              Price_per_unit__c, Total_Value__c, 
                              End_Customer_Account__c,End_Customer_Account__r.Name, Project_Owner_Account__c,Project_Owner_Account__r.Name,
                              End_Customer_Account_SF_Number__c, Project_Owner_SF_Acc_No__c
                              From Billings__c
                              Where Delivery_Date__c >=:deliverDateRange 
                              AND (Account__r.SF_Account_Number__c=:acc[0].SF_Account_Number__c OR 
                                   End_Customer_Account_SF_Number__c =:acc[0].SF_Account_Number__c OR 
                                   Project_Owner_SF_Acc_No__c =:acc[0].SF_Account_Number__c)
                              AND (Order_Status__c =:OPEN OR Order_Status__c =:CLOSED )
                                       Order By CreatedDate DESC];
            }catch(Exception e){                
                throw new AuraHandledException('Error: '+e.getMessage());                
            }

                return reportOrdersList;
            }
        // IF record is Opportunity
        else if(sobjectType == OPPRTUNITYOBJ){            
            List<Opportunity> oppData = [select AccountId,product_1__r.Name,product_2__r.Name,
                                          product_3__r.Name,product_4__r.Name,product_5__r.Name 
                                          From Opportunity Where Id=:recordId Limit 1];
               if(oppData.size() > 0){
                   try{
                    reportOrdersList = [Select id, Name, 
                          Order_No__c, PO_No_Line_Item__c, Invoice_Number__c, 
                          Reference__c, Account__c,
                          Account__r.Name, Reporting_uB_Office__c, 
                          Order_Status__c, Product_ID__c,Product__c, 
                          Frame_Order__c, Order_Date__c, 
                          Request_Date__c, Delivery_Date__c, 
                          Qty_Ordered__c, Qty_Invoiced__c, 
                          Price_per_unit__c, Total_Value__c, 
                          End_Customer_Account__c,End_Customer_Account__r.Name, Project_Owner_Account__c,Project_Owner_Account__r.Name,
                          End_Customer_Account_SF_Number__c, Project_Owner_SF_Acc_No__c,
                          End_Customer_Account_ID__c, 
                          Project_Owner_Account_ID__c, Product__r.Name            
                          From Billings__c 
                          Where Delivery_Date__c >= LAST_N_DAYS:730 AND (Order_Status__c =:OPEN OR Order_Status__c =:CLOSED)   
                          AND ( Product__r.Name =: oppData[0].product_1__r.Name
                                OR Product__r.Name =: oppData[0].product_2__r.Name 
                                OR Product__r.Name =: oppData[0].product_3__r.Name
                                OR Product__r.Name =: oppData[0].product_4__r.Name
                                OR Product__r.Name =: oppData[0].product_5__r.Name)
                                AND (Account__c=:oppData[0].AccountId OR End_Customer_Account__c=:oppData[0].AccountId OR Project_Owner_Account__c=:oppData[0].AccountId )
                                       Order By CreatedDate DESC];
                   }catch(Exception e){                       
                       throw new AuraHandledException('Error: '+e.getMessage());
                   }
               }
            return reportOrdersList;
        }
        return reportOrdersList; 
    }
}
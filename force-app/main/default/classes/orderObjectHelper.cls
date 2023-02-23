public class orderObjectHelper {
    private static final string OBJECT_NAME = 'Contribution_Share__c';
    private static final String FIELD_NAME = 'Product_Filter_Field__c';
      
    public static void updateCS(list<Billings__c> ordersToUpdate, set<Id> targetAccounts){
        map<string,string> productFilterFieldMap = new map<string,string>();
        map<Id,Product2> productsMap = new Map<Id,Product2>();
        list<Product2> prodList = new list<Product2>(); 
        set<Id> productIds = new set<Id>();

        // Get all accounts related to the orders including all of the contribution share related records 
        Map<Id, Account> accountDetails = new Map<Id, Account>([Select Id, 
                                        (Select Id, 
                                            Project_Owner_Account_ID__c, 
                                            End_Customer_Account_ID__c, 
                                            Product_Name__c, Status__c, 
                                            Product_Filter_Value__c,
                                            Product_Filter_Field__c 
                                            From Contribution_Share__r ORDER BY product__c ASC NULLS LAST)
                                        From Account Where Id in :targetAccounts]);
              
        // product field label
        productFilterFieldMap = utility.getFieldValues(OBJECT_NAME,FIELD_NAME);
        
        for(Billings__c order : ordersToUpdate){
            productIds.add(order.Product__c);
        }

        string prodFields = string.join(productFilterFieldMap.values(), ',');      
        string dynamicQuery = 'SELECT Id ,'+prodFields+ ' FROM product2 where id IN :productIds';
        
        try{
            for(product2 prod : database.query(dynamicQuery)){
                productsMap.put(prod.Id, prod);
            }
        }catch(QueryException e){
            system.debug('An error has occurred. '+ e.getMessage());
        }
        
        // Loop through orders
        for(Billings__c order : ordersToUpdate) {

            // Set Contribution Share field to null
            order.Contribution_Share__c = null;
            // If there is an account related to this order
            if (accountDetails.containsKey(order.Account__c)) {
                // Get account
                Account target = accountDetails.get(order.Account__c);
                // Match order fields to contribution share
                Contribution_Share__c match = matchReportinguBOffice(order, target, productsMap, productFilterFieldMap);                
                // If there was a match, add record id to lookup field                
                if (match != null) order.Contribution_Share__c = match.Id;
            }
        }        
    }
    
    private static Contribution_Share__c matchReportinguBOffice(Billings__c order, Account relatedAccount,map<Id,Product2> productsMap ,map<String,String> productFilterFieldMap ){
        // If the order record has no matchable fields - return null
        if (order.Project_Owner_Account_ID__c == null || order.Project_Owner_Account_ID__c == '') return null;
        // Loop through all contribution share records for this account
        for (Contribution_Share__c cs : relatedAccount.Contribution_Share__r) {

            String CSproductFieldName = productFilterFieldMap.get(cs.Product_Filter_Field__c);
            String OrderproductFieldValue;
            if(CSproductFieldName != NULL){
                product2 pordObj = productsMap.get(order.Product__c);
                OrderproductFieldValue = (String) pordObj.get(CSproductFieldName);
            }
                        
            // If this contribution share has no matchable fields, go to next record
            if (cs.Project_Owner_Account_ID__c == null 
                || cs.Project_Owner_Account_ID__c == '' 
                || cs.End_Customer_Account_ID__c == '' 
                || cs.End_Customer_Account_ID__c == null) continue;
            
            // Try to match the contribution share field with the order field of the same name
            // 2018.04.12 :khir: End Customer, Product Name and Approval Status added for matching
            //add product family to relax the CS unique Id
            if (cs.Project_Owner_Account_ID__c == order.Project_Owner_Account_ID__c 
                && cs.End_Customer_Account_ID__c == order.End_Customer_Account_ID__c 
                && cs.Product_Name__c == order.Product_Name__c 
                && cs.Status__c == 'Activated'){

                return cs;
                // comparing product family
            }else if(productFilterFieldMap.containsKey(CS.Product_Filter_Field__c) && productsMap.size() > 0 
                    && (cs.Project_Owner_Account_ID__c == order.Project_Owner_Account_ID__c 
                    && cs.End_Customer_Account_ID__c == order.End_Customer_Account_ID__c 
                    && cs.Product_Filter_Value__c == OrderproductFieldValue
                    && cs.Status__c == 'Activated')){
                return cs;
            }
        }       
        return null;
    }

    /* 
    * disabled by Khurram 3/3/22 moved the CPN assignment to Order Interface Mapping
    *
    public static void setCPN(List<Billings__c> orderList, List<String> accountList, List<String> productList){
        
        Map<String, String> cpnMap = new Map<String, String>();
                 
        if(accountList.size() > 0 && productList.size() > 0){
            
            for(Customer_Part_Number__c cpn : [SELECT Id, 
                                                    Account_Name__c, Type_No_c__c
                                                    FROM Customer_Part_Number__c 
                                                    WHERE Account_Name__c =: accountList 
                                                    AND Type_No_c__c =: productList]){
                cpnMap.put(cpn.Account_Name__c+';'+cpn.Type_No_c__c, cpn.Id);
            }
            
            for(Billings__c  tempOrder :orderList){
                String cpnKey = tempOrder.Account__c+';'+tempOrder.Product__c;               
                if(cpnMap.containsKey(cpnKey)){
                    tempOrder.Customer_Part_Number_ID__c = cpnMap.get(cpnKey);                    
                }else tempOrder.Customer_Part_Number_ID__c = null;
            }
        }
    }*/
}
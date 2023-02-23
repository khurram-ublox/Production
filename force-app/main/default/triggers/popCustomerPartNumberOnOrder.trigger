trigger popCustomerPartNumberOnOrder on Billings__c (before insert, before update) {

    Boolean doUpdate = false;
    List<String> products    = new List<String>();
    List<String> accounts    = new List<String>();
    
    Map<String, String> cpnMap = new Map<String, String>();
    List<Billings__c> ordersToUpdate = new List<Billings__c>();

    for(Billings__c oNew : Trigger.new)
    {
        doUpdate = false;

        if(Trigger.isUpdate) {
            Billings__c oOld = Trigger.oldMap.get(oNew.Id);

            if (oNew.Customer_Part_Number_ID__c == null || 
                oOld.Account__c != oNew.Account__c ||
                oOld.Product__c != oNew.Product__c
            ) doUpdate = true;
        }
        else {
            doUpdate = true;
        }

        if(doUpdate) {
            accounts.add(oNew.Account__c);
            products.add(oNew.Product__c);
        }
    }

    if(!accounts.isEmpty()) {
        // Type_No_c__c is product_id !!
        for(Customer_Part_Number__c cpn : [SELECT Id, Account_Name__c, Type_No_c__c
                                        FROM Customer_Part_Number__c WHERE Account_Name__c =: accounts AND Type_No_c__c =: products]) 
        {
            cpnMap.put(cpn.Account_Name__c+';'+cpn.Type_No_c__c, cpn.Id);
        }

        for(Billings__c o : Trigger.new)
        {

            String cpnKey = o.Account__c+';'+o.Product__c;

            doUpdate = false;

            if(Trigger.isUpdate) {
                Billings__c oOld = Trigger.oldMap.get(o.Id);

                if (o.Customer_Part_Number_ID__c == null || 
                    oOld.Account__c != o.Account__c ||
                    oOld.Product__c != o.Product__c
                ) doUpdate = true;
            }
            else {
                doUpdate = true;
            }

            if(doUpdate) {
                if(cpnMap.containsKey(cpnKey)) o.Customer_Part_Number_ID__c = cpnMap.get(cpnKey);
                else o.Customer_Part_Number_ID__c = null;
            }
        }   
    }

}
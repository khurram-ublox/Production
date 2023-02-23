public class SPRPTriggerHandler implements ITrigger {

    // This trigger does the following
   // 0. Updates currencies on every record
   // 1. Identify which SPRPs need to be updated/processed => SPRPtoBeUpdated
   // 2. Lookup the COGS4 values and the ID of the COGS Set (if existing) for the products connected to the SPRPs from 1. Store also the link SPRPID => ProductID
   // 3. Retrieve all COGS Set Values with their dates for the Sets identified in 2. and store them in a map COGSSetToCOGSValueList
   // 4. Loop through all the SPRPs to be updated, identify the COGS Set value (if existing) or set the COGS4 value. Also update the textfield accordingly
   
   String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
   Set<ID> Prodids     = new Set<Id>();
   Set<ID> COGSSetids  = new Set<Id>();
   List<Special_Price_Request_Product__c> SPRPtoBeUpdated = new List<Special_Price_Request_Product__c>();
   
   Map<Id, Id> SPRP2Prod        = new Map<Id, Id>();
   Map<Id, Id> Prod2Set         = new Map<Id, Id>();
   Map<Id, Decimal> Prod2COGS4  = new Map<Id, Decimal>();
   Map<Id, Map<Date,Decimal>> COGSSetToCOGSValueList = new Map<Id, Map<Date,Decimal>>();
   
   
   // Prepare the data for catering to Before Trigger events
   public void prepareBefore(){
       
    list<User> u = [Select Id, USDtoEUR__c, USDtoCHF__c, USDtoJPY__c from User where Id=:Userinfo.getUserId()];

       for(SObject tempSPRPObj : Trigger.new) {
           Special_Price_Request_Product__c sprpObj = (Special_Price_Request_Product__c) tempSPRPObj;
           
           // Get exchange rates and update them in sprp
           if(u.size() > 0 && u[0].USDtoCHF__c != null && u[0].USDtoEUR__c != null && u[0].USDtoJPY__c != null){
                sprpObj.CHFtoUSD__c = 1/u[0].USDtoCHF__c;
                sprpObj.EURtoUSD__c = 1/u[0].USDtoEUR__c;
                sprpObj.JPYtoUSD__c = 1/u[0].USDtoJPY__c;
                sprpObj.Exchange_Rate_Date__c = System.now().date();
           }
               
           
           // if update
           if (Trigger.isUpdate) {
               Special_Price_Request_Product__c o =(Special_Price_Request_Product__c) Trigger.oldMap.get(sprpObj.Id);
               
               // In case of a manual interaction, we just stop here and insert a proper text in the field
               if (
                   ( o.Product_Cost_P1__c != sprpObj.Product_Cost_P1__c && sprpObj.Product_Cost_P1__c != NULL )
                   || ( o.Product_Cost_P2__c != sprpObj.Product_Cost_P2__c && sprpObj.Product_Cost_P2__c != NULL )
                   || ( o.Product_Cost_P3__c != sprpObj.Product_Cost_P3__c && sprpObj.Product_Cost_P3__c != NULL )
                   || ( o.Product_Cost_P4__c != sprpObj.Product_Cost_P4__c && sprpObj.Product_Cost_P4__c != NULL )
                   || ( o.Product_Cost_P5__c != sprpObj.Product_Cost_P5__c && sprpObj.Product_Cost_P5__c != NULL )
               ) {
                   
                   sprpObj.COGS_data_source_RT__c = '<span style="color:red">ATTENTION</span> At least one COGS value was changed manually! Delete all "Product Cost" values for auto retrieval.';
                   continue;
               }
               
               // Check if we have to update anything...
               if (
                   (sprpObj.Product__r.Id != o.Product__r.Id)
                   || (sprpObj.Product_Cost_P1__c == NULL && sprpObj.Year_P1__c != NULL)
                   || (sprpObj.Product_Cost_P2__c == NULL && sprpObj.Year_P2__c != NULL)
                   || (sprpObj.Product_Cost_P3__c == NULL && sprpObj.Year_P3__c != NULL)
                   || (sprpObj.Product_Cost_P4__c == NULL && sprpObj.Year_P4__c != NULL)
                   || (sprpObj.Product_Cost_P5__c == NULL && sprpObj.Year_P5__c != NULL)
                   || o.Year_P1__c!= sprpObj.Year_P1__c
                   || o.Year_P2__c!= sprpObj.Year_P2__c
                   || o.Year_P3__c!= sprpObj.Year_P3__c
                   || o.Year_P4__c!= sprpObj.Year_P4__c
                   || o.Year_P5__c!= sprpObj.Year_P5__c ) {
                       
                       Prodids.add(sprpObj.Product__c);
                       SPRP2Prod.put(sprpObj.Id, sprpObj.Product__c);
                       SPRPtoBeUpdated.add(sprpObj);
                   }
           }
           // if insert
           else {
               if (    sprpObj.Product_Cost_P1__c != NULL ||
                   sprpObj.Product_Cost_P2__c != NULL ||
                   sprpObj.Product_Cost_P3__c != NULL ||
                   sprpObj.Product_Cost_P4__c != NULL ||
                   sprpObj.Product_Cost_P5__c != NULL
                  ) {
                      
                      sprpObj.COGS_data_source_RT__c = '<span style="color:red">ATTENTION</span> At least one COGS value was inserted manually! Delete all "Product Cost" values for auto retrieval.';
                      continue;
                  }
               
               // Check if we have to update anything...
               if (
                   (sprpObj.Product_Cost_P1__c == NULL && sprpObj.Year_P1__c != NULL) ||
                   (sprpObj.Product_Cost_P2__c == NULL && sprpObj.Year_P2__c != NULL) ||
                   (sprpObj.Product_Cost_P3__c == NULL && sprpObj.Year_P3__c != NULL) ||
                   (sprpObj.Product_Cost_P4__c == NULL && sprpObj.Year_P4__c != NULL) ||
                   (sprpObj.Product_Cost_P5__c == NULL && sprpObj.Year_P5__c != NULL) ) {
                       //System.debug('ckoe Year P1 has changed for '+n.Name+', so including in update');
                       Prodids.add(sprpObj.Product__c);
                       SPRP2Prod.put(sprpObj.Id, sprpObj.Product__c);
                       SPRPtoBeUpdated.add(sprpObj);
                   }
           }
           
       }//end-for
       
       // 2.
   for (Product2 prod: [select Id, Valid_COGS_Info__c, COGS_4__c from Product2 where Id in:Prodids]) {
       Prod2Set.put(prod.Id, prod.Valid_COGS_Info__c);
       COGSSetids.add(prod.Valid_COGS_Info__c);
       Prod2COGS4.put(prod.Id, prod.COGS_4__c);
   }
       
       
           // Now get the list of all values...
   // 3.
   for (COGS_Set_Value__c singleValue: [select Id, Value__c ,COGS_Set__c, COGS_Quarter__r.Start_Date__c, COGS_Quarter__c  from COGS_Set_Value__c where COGS_Set__c in:COGSSetids order by COGS_Quarter__r.Start_Date__c ASC]) {
       // System.debug('ckoe list:  '+singleValue.Id);
       // System.debug('ckoe value:  '+singleValue.Value__c);
       // System.debug('ckoe date:  '+singleValue.COGS_Quarter__r.Start_Date__c);
       // Now add that stuff into the map
       Map<Date,Decimal> thisMap = COGSSetToCOGSValueList.get(singleValue.COGS_Set__c);
       if (thisMap == NULL) {
           // Create a new map
           thisMap = new Map<Date,Decimal>();
           COGSSetToCOGSValueList.put(singleValue.COGS_Set__c,thisMap);
       }
       thisMap.put(singleValue.COGS_Quarter__r.Start_Date__c,singleValue.Value__c);
   }
       
       // Now we have all info to update the values
   // 4.
   for(Special_Price_Request_Product__c n : SPRPtoBeUpdated) {
   
       Boolean y1changed = false;
       Boolean y2changed = false;
       Boolean y3changed = false;
       Boolean y4changed = false;
       Boolean y5changed = false;

       if(Trigger.isUpdate) {
           Special_Price_Request_Product__c o =(Special_Price_Request_Product__c) Trigger.oldMap.get(n.Id);

           if(o.Year_P1__c!= n.Year_P1__c) y1changed=true;
           if(o.Year_P2__c!= n.Year_P2__c) y2changed=true;
           if(o.Year_P3__c!= n.Year_P3__c) y3changed=true;
           if(o.Year_P4__c!= n.Year_P4__c) y4changed=true;
           if(o.Year_P5__c!= n.Year_P5__c) y5changed=true;
       }

       Decimal currFactor = 1;
       if (n.CurrencyIsoCode == 'CHF') {
           currFactor = 1/n.CHFtoUSD__c;
       }
       else if (n.CurrencyIsoCode == 'EUR') {
           currFactor = 1/n.EURtoUSD__c;
       }
       else if (n.CurrencyIsoCode == 'JPY') {
           currFactor = 1/n.JPYtoUSD__c; 
       }

   
       // Check if we have PCOGS data set
       ID setId = Prod2Set.get(SPRP2Prod.get(n.Id));
       if (setId != null) {
           // System.debug('ckoe We have a set for this SPRP');
           Map<Date,Decimal> thisMap = COGSSetToCOGSValueList.get(setId);
           
           List<Date> dateList = new List<Date>();
           dateList.addAll(thisMap.keySet());
           dateList.sort();
           
           Boolean costEmpty = false;
           
           // Now the BAD and UGLY check for all the different Years
           if ((n.Product_Cost_P1__c == NULL && n.Year_P1__c != NULL) || y1changed) {
               n.Product_Cost_P1__c = NULL;

               for(Date checkDate: dateList) {
                   if (checkDate <= n.Year_P1__c) {
                       // System.debug('ckoe Setting now the PCOGS 1 value');
                       n.Product_Cost_P1__c = (thisMap.get(checkDate)*currFactor).setscale(3);
                   }
               }
               if(n.Product_Cost_P1__c == NULL) costEmpty = true;
           }
           
           
           if ((n.Product_Cost_P2__c == NULL && n.Year_P2__c != NULL) || y2changed) {
               n.Product_Cost_P2__c = NULL;

               for(Date checkDate: dateList) {
                   //System.debug('ckoe Comparing '+checkDate+' with '+n.Year_P2__c);
                   if (checkDate <= n.Year_P2__c) {
                       // System.debug('ckoe Setting now the PCOGS 2 value');
                       n.Product_Cost_P2__c = (thisMap.get(checkDate)*currFactor).setscale(3);
                   }
               }
               if(n.Product_Cost_P2__c == NULL) costEmpty = true;
           }            
           
           
           if ((n.Product_Cost_P3__c == NULL && n.Year_P3__c != NULL) || y3changed) {
               n.Product_Cost_P3__c = NULL;

               for(Date checkDate: dateList) {
                   //System.debug('ckoe Comparing '+checkDate+' with '+n.Year_P3__c);
                   if (checkDate <= n.Year_P3__c) {
                       // System.debug('ckoe Setting now the PCOGS 3 value');
                       n.Product_Cost_P3__c = (thisMap.get(checkDate)*currFactor).setscale(3);
                   }
               }
               if(n.Product_Cost_P3__c == NULL) costEmpty = true;
           }           
           
           
           if ((n.Product_Cost_P4__c == NULL && n.Year_P4__c != NULL) || y4changed) {
               n.Product_Cost_P4__c = NULL;

               for(Date checkDate: dateList) {
                   // System.debug('ckoe Comparing '+checkDate+' with '+n.Year_P4__c);
                   if (checkDate <= n.Year_P4__c) {
                       // System.debug('ckoe Setting now the PCOGS 4 value');
                       n.Product_Cost_P4__c = (thisMap.get(checkDate)*currFactor).setscale(3);
                   }
               }
               if(n.Product_Cost_P4__c == NULL) costEmpty = true;
           }
           
           
           if ((n.Product_Cost_P5__c == NULL && n.Year_P5__c != NULL) || y5changed) {
               n.Product_Cost_P5__c = NULL;

               for(Date checkDate: dateList) {
                   // System.debug('ckoe Comparing '+checkDate+' with '+n.Year_P5__c);
                   if (checkDate <= n.Year_P5__c) {
                       // System.debug('ckoe Setting now the PCOGS 5 value');
                       n.Product_Cost_P5__c = (thisMap.get(checkDate)*currFactor).setscale(3);
                   }
               }
               if(n.Product_Cost_P5__c == NULL) costEmpty = true;
           }

           String setLink = '<a href="'+baseUrl+'/'+setId+'">COGS Set</a>.';
           if(costEmpty) n.COGS_data_source_RT__c = 'PCOGS values from PM tool prediction, see '+setLink+' At least one price has no value as there is no data for the inserted date.';
           else n.COGS_data_source_RT__c = 'PCOGS values from PM tool prediction, see '+setLink;

       }
       else {
           if(Prod2COGS4.get(n.Product__c)>0) n.COGS_data_source_RT__c = '<span style="color:red">ATTENTION</span> COGS values from Logistics prediction in product.';
           else n.COGS_data_source_RT__c = '<span style="color:red">ATTENTION</span> No COGS values found.';
           // Now lookup the COGS 4 Value from the product...
           if ((n.Product_Cost_P1__c == NULL && n.Year_P1__c != NULL) || y1changed) {
               if(Prod2COGS4.get(n.Product__c)>0) n.Product_Cost_P1__c = (Prod2COGS4.get(n.Product__c)*currFactor).setscale(3);
               else n.Product_Cost_P1__c = NULL;
           }
           if ((n.Product_Cost_P2__c == NULL && n.Year_P2__c != NULL) || y2changed) {
               if(Prod2COGS4.get(n.Product__c)>0) n.Product_Cost_P2__c = (Prod2COGS4.get(n.Product__c)*currFactor).setscale(3);
               else n.Product_Cost_P2__c = NULL;
           }
           if ((n.Product_Cost_P3__c == NULL && n.Year_P3__c != NULL) || y3changed) {
               if(Prod2COGS4.get(n.Product__c)>0) n.Product_Cost_P3__c = (Prod2COGS4.get(n.Product__c)*currFactor).setscale(3);
               else n.Product_Cost_P3__c = NULL;
           }
           if ((n.Product_Cost_P4__c == NULL && n.Year_P4__c != NULL) || y4changed) {
               if(Prod2COGS4.get(n.Product__c)>0) n.Product_Cost_P4__c = (Prod2COGS4.get(n.Product__c)*currFactor).setscale(3);
               else n.Product_Cost_P4__c = NULL;
           }
           if ((n.Product_Cost_P5__c == NULL && n.Year_P5__c != NULL) || y5changed) {
               if(Prod2COGS4.get(n.Product__c)>0) n.Product_Cost_P5__c = (Prod2COGS4.get(n.Product__c)*currFactor).setscale(3);
               else n.Product_Cost_P5__c = NULL;
           }
       }//els-end
   }
       
   }
   
   // Prepare the data for catering to After Trigger events 
   public void prepareAfter(){
   }
   
   // Process logic/functioanlities in other classes for before Insert event  
   public void beforeInsert(){}
   
   // Process logic/functioanlities in other classes for before Update  event
   public void beforeUpdate(){}
   
   // Process logic/functioanlities in other classes for before Delete event
   public void beforeDelete(){
       //Process 4
      
   }
   
   // Process logic/functioanlities in other classes for after Update  event
   public void afterInsert(){
       //Process 2 Logic : calling Helper functions to get desired result.
      
   }
   
   // Process logic/functioanlities in other classes for after Update  event 
   public void afterUpdate(){
   
       
   }
   
   // Process logic/functioanlities in other classes for after Delete  event
   public void afterDelete(){

   } 
   //Finally do operations to Commit 
   public void finish(){
       
       //Process 1 Result Commit
    
       
   }
}
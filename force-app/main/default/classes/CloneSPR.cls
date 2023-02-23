public class CloneSPR {
	@AuraEnabled
     public static String cloneSPRConform(String recordId){
       String SPRId;
       String NewSPRId;
         //System.debug('aaaaaaaaaaaaaaa'+recordId);
       if(!string.isEmpty(recordId)){ 
         SPRId=recordId;
        list<Special_Price_Request__c>  spPriReqObjLst=[SELECT id,Account__c,Opportunity__c,Contact__c,CurrencyIsoCode,Comment_by_Requestor__c,Delivery__c,Payment__c,Price_Level__c from Special_Price_Request__c Where id=: SPRId];   
        Special_Price_Request__c spPriceReqObj=new Special_Price_Request__c();        
        spPriceReqObj.Account__c = spPriReqObjLst[0].Account__c;
        spPriceReqObj.Opportunity__c = spPriReqObjLst[0].Opportunity__c;
        spPriceReqObj.Contact__c = spPriReqObjLst[0].Contact__c;
        spPriceReqObj.CurrencyIsoCode = spPriReqObjLst[0].CurrencyIsoCode;
        spPriceReqObj.Comment_by_Requestor__c = spPriReqObjLst[0].Comment_by_Requestor__c;
        spPriceReqObj.Delivery__c = spPriReqObjLst[0].Delivery__c;
        spPriceReqObj.Payment__c = spPriReqObjLst[0].Payment__c ;
        spPriceReqObj.Price_Level__c = spPriReqObjLst[0].Price_Level__c;
        insert spPriceReqObj;   
        NewSPRId = spPriceReqObj.id;    
        //queries all SPR Products related to this SPR   
        list<Special_Price_Request_Product__c>  spPriReqProObjLst=[SELECT Id, Product__c, Quantity_P1__c, Quantity_P2__c, Quantity_P3__c, Quantity_P4__c, Quantity_P5__c, Unit_Price_P1__c, Unit_Price_P2__c, Unit_Price_P3__c, Unit_Price_P4__c, Unit_Price_P5__c, Year_P1__c, Year_P2__c, Year_P3__c, Year_P4__c, Year_P5__c, Use_Restriction__c, IPR_Coverage__c, CurrencyIsoCode, Distributor_Resale_Unit_Price_P1__c, Distributor_Additional_Fee_P1__c, Distributor_Commission_P1__c, Distributor_Resale_Unit_Price_P2__c, Distributor_Additional_Fee_P2__c, Distributor_Commission_P2__c, Distributor_Resale_Unit_Price_P3__c, Distributor_Additional_Fee_P3__c, Distributor_Commission_P3__c, Distributor_Resale_Unit_Price_P4__c, Distributor_Additional_Fee_P4__c, Distributor_Commission_P4__c, Distributor_Resale_Unit_Price_P5__c, Distributor_Additional_Fee_P5__c, Distributor_Commission_P5__c, Product_Cost_P1__c, Product_Cost_P2__c, Product_Cost_P3__c, Product_Cost_P4__c, Product_Cost_P5__c FROM Special_Price_Request_Product__c WHERE Special_Price_Request__c =: SPRId];                            
         //Loop through the SPR Products in the records set
         for(Special_Price_Request_Product__c spPriReqProObj: spPriReqProObjLst){
			Special_Price_Request_Product__c newspPriceReqObj=new Special_Price_Request_Product__c();    
                    newspPriceReqObj.Special_Price_Request__c = NewSPRId;
                    newspPriceReqObj.Product__c = spPriReqProObj.Product__c;
                    newspPriceReqObj.CurrencyIsoCode = spPriReqProObj.CurrencyIsoCode;
                    newspPriceReqObj.Use_Restriction__c = spPriReqProObj.Use_Restriction__c;
                    newspPriceReqObj.IPR_Coverage__c = spPriReqProObj.IPR_Coverage__c;
            
                    newspPriceReqObj.Year_P1__c = spPriReqProObj.Year_P1__c;
                    newspPriceReqObj.Unit_Price_P1__c = spPriReqProObj.Unit_Price_P1__c;
                    newspPriceReqObj.Product_Cost_P1__c = spPriReqProObj.Product_Cost_P1__c;
                    newspPriceReqObj.Quantity_P1__c = spPriReqProObj.Quantity_P1__c;
                    newspPriceReqObj.Distributor_Resale_Unit_Price_P1__c = spPriReqProObj.Distributor_Resale_Unit_Price_P1__c;
                    newspPriceReqObj.Distributor_Additional_Fee_P1__c = spPriReqProObj.Distributor_Additional_Fee_P1__c;
                    newspPriceReqObj.Distributor_Commission_P1__c = spPriReqProObj.Distributor_Commission_P1__c;
            
                    newspPriceReqObj.Year_P2__c = spPriReqProObj.Year_P2__c;
                    newspPriceReqObj.Unit_Price_P2__c = spPriReqProObj.Unit_Price_P2__c;
                    newspPriceReqObj.Product_Cost_P2__c = spPriReqProObj.Product_Cost_P2__c;
                    newspPriceReqObj.Quantity_P2__c = spPriReqProObj.Quantity_P2__c;
                    newspPriceReqObj.Distributor_Resale_Unit_Price_P2__c = spPriReqProObj.Distributor_Resale_Unit_Price_P2__c;
                    newspPriceReqObj.Distributor_Additional_Fee_P2__c = spPriReqProObj.Distributor_Additional_Fee_P2__c;
                    newspPriceReqObj.Distributor_Commission_P2__c = spPriReqProObj.Distributor_Commission_P2__c;
            
                    newspPriceReqObj.Year_P3__c = spPriReqProObj.Year_P3__c;
                    newspPriceReqObj.Unit_Price_P3__c = spPriReqProObj.Unit_Price_P3__c;
                    newspPriceReqObj.Product_Cost_P3__c = spPriReqProObj.Product_Cost_P3__c;
                    newspPriceReqObj.Quantity_P3__c = spPriReqProObj.Quantity_P3__c;
                    newspPriceReqObj.Distributor_Resale_Unit_Price_P3__c = spPriReqProObj.Distributor_Resale_Unit_Price_P3__c;
                    newspPriceReqObj.Distributor_Additional_Fee_P3__c = spPriReqProObj.Distributor_Additional_Fee_P3__c;
                    newspPriceReqObj.Distributor_Commission_P3__c = spPriReqProObj.Distributor_Commission_P3__c;
            
                    newspPriceReqObj.Year_P4__c = spPriReqProObj.Year_P4__c;
                    newspPriceReqObj.Unit_Price_P4__c = spPriReqProObj.Unit_Price_P4__c;
                    newspPriceReqObj.Product_Cost_P4__c = spPriReqProObj.Product_Cost_P4__c;
                    newspPriceReqObj.Quantity_P4__c = spPriReqProObj.Quantity_P4__c;
                    newspPriceReqObj.Distributor_Resale_Unit_Price_P4__c = spPriReqProObj.Distributor_Resale_Unit_Price_P4__c;
                    newspPriceReqObj.Distributor_Additional_Fee_P4__c = spPriReqProObj.Distributor_Additional_Fee_P4__c;
                    newspPriceReqObj.Distributor_Commission_P4__c = spPriReqProObj.Distributor_Commission_P4__c;
             
                    newspPriceReqObj.Year_P5__c = spPriReqProObj.Year_P5__c;
                    newspPriceReqObj.Unit_Price_P5__c = spPriReqProObj.Unit_Price_P5__c;
                    newspPriceReqObj.Product_Cost_P5__c = spPriReqProObj.Product_Cost_P5__c;
                    newspPriceReqObj.Quantity_P5__c = spPriReqProObj.Quantity_P5__c;
                    newspPriceReqObj.Distributor_Resale_Unit_Price_P5__c = spPriReqProObj.Distributor_Resale_Unit_Price_P5__c;
                    newspPriceReqObj.Distributor_Additional_Fee_P5__c = spPriReqProObj.Distributor_Additional_Fee_P5__c;
                    newspPriceReqObj.Distributor_Commission_P5__c = spPriReqProObj.Distributor_Commission_P5__c;            
                    
             		insert newspPriceReqObj;        
                }                                   
       }
       return NewSPRId;
     }     
     
}
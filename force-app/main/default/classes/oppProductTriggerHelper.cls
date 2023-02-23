public with sharing class oppProductTriggerHelper {
    
    /**
* @description: get 5 products by Ranking and Last Modified date.
**/
    public static List<Opportunity> updateProductRankings(Map<Id, Opp_Product__c> oppProducts){
        
        List<Id> oppIds = new List<Id>();
        List<Opportunity> opps = new List<Opportunity>();
        Boolean isServiceProduct = FALSE;
        if (oppProducts == null) return null;
        
        // Get list of opportunitie ids.
        for (Opp_Product__c oppProduct : oppProducts.values()){
            oppIds.add(oppProduct.Opportunity__c);
        }
        if(oppIds.size() > 0){  opps = [SELECT Id, Product_1__c, Product_2__c, 
                                        Product_3__c, Product_4__c, Product_5__c,
                                        Services_Opportunity__c,Product_1__r.Product_Center__c,
                                        Product_2__r.Product_Center__c,Product_3__r.Product_Center__c
                                        FROM Opportunity  WHERE Id IN:oppIds];
                              
        }
        
        if (opps.size()==0) return null;
        
        
        // Get list of Opp Products for each opportunity - ranked.
        // 2015.09.09 khir: List only Opp Products in certain Status
        // 2016.01.20 khir: Lost Opp Product added only if Reason is the same as the Opportunity.
        List<Opp_Product__c> allOppProducts = [SELECT Id, 
                                                    Name, 
                                                    Ranking__c, 
                                                    Contribution__c, 
                                                    Product__c,
                                               		Product__r.product_center__c,
                                                    Opportunity__c, 
                                                    Opportunity__r.Name, 
                                                    LastModifiedDate, 
                                                    Product__r.Name, 
                                                    Status__c
                                               FROM Opp_Product__c 
                                               WHERE Opportunity__c IN :opps 
                                                    AND (Status__c IN ('Evaluation', 'Won') 
                                                    OR (Status__c = 'Lost' AND Reason_Same_As_Opportunity__c = true 
                                                    AND Opportunity__r.StageName='1 Lost' )
                                                    )                                                   
                                               ORDER BY Opportunity__c, Ranking__c DESC, LastModifiedDate DESC];
        
        List<Opportunity> OppToUpdate = new List <Opportunity>{}; // List of product which have changed
            // Loop through opportunity - get related products which should be ordered correctly.
            for (Opportunity opp : opps){
                Integer i=0;
                Boolean change =  false;  // remember if any change has happened.
                for (Opp_Product__c oppProduct : allOppProducts){
                    if (opp.Id == oppProduct.Opportunity__c){
                        // Only assign the Product_*__c if there is an actual change
                        // below three lines for Service Opportunity
                        if(oppProduct.Product__r.product_Center__c != 'Services' && !isServiceProduct){
                            isServiceProduct = TRUE;
                            opp.Services_Opportunity__c = FALSE;
                        }
                        if (i==0 && opp.Product_1__c != oppProduct.Product__c) {opp.Product_1__c = oppProduct.Product__c; change = true;}
                        if (i==1 && opp.Product_2__c != oppProduct.Product__c) {opp.Product_2__c = oppProduct.Product__c; change = true;}
                        if (i==2 && opp.Product_3__c != oppProduct.Product__c) {opp.Product_3__c = oppProduct.Product__c; change = true;}
                        if (i==3 && opp.Product_4__c != oppProduct.Product__c) {opp.Product_4__c = oppProduct.Product__c; change = true;}
                        if (i==4 && opp.Product_5__c != oppProduct.Product__c) {opp.Product_5__c = oppProduct.Product__c; change = true;}
                        i++;
                    } // if
                } // for
                for (Integer j = i; j < 5; j++) {
                    // Set the remainding Products to null if they are not null already
                    if (j==0 && opp.Product_1__c != null) {opp.Product_1__c = null; change = true;}
                    if (j==1 && opp.Product_2__c != null) {opp.Product_2__c = null; change = true;}
                    if (j==2 && opp.Product_3__c != null) {opp.Product_3__c = null; change = true;}
                    if (j==3 && opp.Product_4__c != null) {opp.Product_4__c = null; change = true;}
                    if (j==4 && opp.Product_5__c != null) {opp.Product_5__c = null; change = true;}
                } // for
                if(opp.Product_1__c == NULL && opp.Product_2__c == NULL && opp.Product_3__c == NULL){
                    opp.Services_Opportunity__c=false;
                }
                if (change) {
                    OppToUpdate.add(opp);
                } // if
            } // for
        return OppToUpdate; 
    }   
    
    /**To bind the Standard product value with Custom Product lookup**/
	
    // Commenting out this(updateProduct) method. It is for the removal of custom Product obj. By ufar, 12-6-22.
	/*    
    
    public static list<Opp_Product__c> updateProduct(Map<Id,Opp_Product__c> oppProducts){
        
        List<Opp_Product__c> oppProdList = new List<Opp_Product__c>();
        oppProdList = [select Id,Product__c,Products__c,Calculate_CogsBudget__c,Next_Year_COGS_Budget__c from Opp_Product__c where ID IN: oppProducts.keyset()];
        //List<Opp_Product__c> oppProdList1 = new List<Opp_Product__c>();
        Map<Id,Opp_Product__c> oppProdMap1 = new Map<Id,Opp_Product__c>();
        Map<Id,Id> standardProdId = new Map<Id,Id>();  
        List<Product__c> customProdList = new List<Product__c>();
        
        for(Opp_Product__c oppProd : oppProdList) {
            
            if(oppProd.Product__c != null) { 
                standardProdId.put(oppProd.Id,oppProd.Product__c);
            }
        }
        customProdList = [select Id,Name,Referred_Product__c from Product__c where Referred_Product__c IN: standardProdId.values()];
        for(Opp_Product__c oppProd : oppProdList){
            for(Product__c prod : customProdList){
                if(oppProd.Product__c == prod.Referred_Product__c){
                    oppProd.Products__c = prod.id;
                    //oppProdList1.add(oppProd);
                    oppProdMap1.put(oppProd.id,oppProd);
                }
            }
        }
        
        oppProdMap1 = updateBudgetCOGSVal(oppProducts,oppProdList,oppProdMap1,standardProdId);        
        return oppProdMap1.values();
    }
	*/

    public static boolean isFirstTime = true;
    
    public static Map<Id,Opp_Product__c> updateBudgetCOGSVal(Map<Id,Opp_Product__c> oppProducts,
        List<Opp_Product__c> oppProdList,Map<Id,Opp_Product__c> oppProdMap1,Map<Id,Id> standardProdId)
    {
        Map<Id,Id> prodCOGSSetMap = new Map<Id,Id>();
        
        Map<Id,Product2> stdProdMap = new Map<Id,Product2>([select Id,Name,Next_Year_COGS_Value__c,Valid_COGS_Info__c from Product2 where Id IN: standardProdId.values()]);
        
        for(Product2 prod : stdProdMap.values()){
            prodCOGSSetMap.put(prod.id,prod.Valid_COGS_Info__c);
        }
        List<COGS_Set_Value__c> cogsSetValList = [select Id,Name,COGS_Set__c,Value__c,Next_Year_Quarter__c from COGS_Set_Value__c where COGS_Set__c IN: prodCOGSSetMap.values() AND Next_Year_Quarter__c IN ('1','2','3','4')];
        Map<Id,Map<String,COGS_Set_Value__c>> COGSSetAndValueMap = new Map<Id,Map<String,COGS_Set_Value__c>>();
        for(COGS_Set_Value__c cogsValSet : cogsSetValList)
        {
            if(!COGSSetAndValueMap.containsKey(cogsValSet.COGS_Set__c)) {
                COGSSetAndValueMap.put(cogsValSet.COGS_Set__c,new Map<String,COGS_Set_Value__c>());
            }   
            COGSSetAndValueMap.get(cogsValSet.COGS_Set__c).put(cogsValSet.Next_Year_Quarter__c,cogsValSet);
        }
        Boolean considerCogs = false;
        Process_Settings__c pSetting = Process_Settings__c.getInstance();
        if(pSetting.Consider_Cogs_In_Next_Year_Budget__c == true)
        {
            considerCogs = pSetting.Consider_Cogs_In_Next_Year_Budget__c;
        }
        for(Opp_Product__c oppProd : oppProdList){
            if(oppProd.Calculate_CogsBudget__c == TRUE){
                Opp_Product__c tempOppProd = oppProdMap1.containsKey(oppProd.id)?oppProdMap1.get(oppProd.id):oppProd;
                
                string cogsSetId = prodCOGSSetMap.get(oppProd.Product__c);
                
                if(considerCogs && cogsSetId!=null && COGSSetAndValueMap.containsKey(cogsSetId))
                    tempOppProd.Next_Year_COGS_Budget__c = generateCOGSStringFromMap(COGSSetAndValueMap.get(cogsSetId));
                
                else{
                    List<String> cogsValList = splitNextValCOGSString(stdProdMap.get(oppProd.Product__c).Next_Year_COGS_Value__c,':');
                    String cogsValString =generateCOGSStringFromList(cogsValList);
                    tempOppProd.Next_Year_COGS_Budget__c = cogsValString; 
                }
				oppProdMap1.put(tempOppProd.id,tempOppProd);
            }            
        }
        return oppProdMap1;      
    }
    
    private static List<String> splitNextValCOGSString(String fText,String delimeter)
    {
        List<String> res = new List<String>();
        
        if(!String.isEmpty(fText)){ res = fText.split(delimeter);
            for(integer i=res.size();i<4;i++)  {
                res.add('');
            }
        }
        return res;
    }
    
    private static String generateCOGSStringFromList(List<String> cogsValList){
        String cogsValString ='';
        if(cogsValList.size() == 4) {
            cogsValString = generateCOGSString(cogsValList[0],cogsValList[1],cogsValList[2],cogsValList[3]);
        }
        return cogsValString;
    }
    
    private static String generateCOGSStringFromMap(Map<String,COGS_Set_Value__c> COGSSetAndValueMap){
        String cogsValString ='';
        if(COGSSetAndValueMap.size()>0) { 
            
            String q1Str = COGSSetAndValueMap.containsKey('1')?String.valueOf(COGSSetAndValueMap.get('1').Value__c):'';
            String q2Str= COGSSetAndValueMap.containsKey('2')?String.valueOf(COGSSetAndValueMap.get('2').Value__c):'';
            String q3Str= COGSSetAndValueMap.containsKey('3')?String.valueOf(COGSSetAndValueMap.get('3').Value__c):'';
            String q4Str= COGSSetAndValueMap.containsKey('4')?String.valueOf(COGSSetAndValueMap.get('4').Value__c):'';
            cogsValString = generateCOGSString(q1Str,q2Str,q3Str,q4Str);
        }
        return cogsValString;
    }
    
    private static string generateCOGSString(String q1,String q2,String q3,String q4)
    {
        String cogsQString ='1#'+q1+':2#'+q2+':3#'+q3+':4#'+q4;
        return cogsQString;
    }
}
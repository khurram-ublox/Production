public with sharing class OpportunityHelper {
    private static final string STAGE_LOST =  '1 Lost';
    private static final string EVALUATION =  'Evaluation';
    private static final string WON =  'Won';
    private static final string LOST =  'Lost';
    private static final string ALT_PRODUCT =  'Alternative Product';
    private static final string NA =  'Not applicable';
    private static final set<string> OPPORTUNITY_STAGES = new set<string>{        
        '5 Design-in',
        '6 Prototypes',
        '7 Pre-Production',
        '8 Production',
        '9 Closed EoL'        
    };

    public void updateOppProductStatus(map<Id, Opportunity> newMap, map<Id, Opportunity> oldMap) {
        set<Id> opportunityIdSet = new set<Id>();        

        for(Opportunity opp : newMap.values()){
            if(opp.StageName != oldMap.get(opp.Id).StageName){
                if(opp.StageName == STAGE_LOST || 
                    (OPPORTUNITY_STAGES.contains(opp.StageName) && !OPPORTUNITY_STAGES.contains(oldMap.get(opp.Id).StageName))){
                    opportunityIdSet.add(opp.Id);
                }
            }        
        }
        if(opportunityIdSet.size() > 0){
            map<Id,list<Opp_Product__c>> lostOppsAndOppProductsMap = new map<Id,list<Opp_Product__c>>();
            list<Opp_Product__c> OppProdToUpdate = new list<Opp_Product__c>();         
            
            for(Opp_Product__c OppProd:[SELECT Id,
                                                Product__c, 
                                                Opportunity__c, 
                                                Status__c, 
                                                Loss_Reason__c, 
                                                Opportunity__r.StageName, 
                                                Opportunity__r.Reason__c, 
                                                Loss_Reason_Remark__c, 
                                                No_Opp_Update__c
                                        FROM Opp_Product__c
                                        WHERE Opportunity__c IN :opportunityIdSet
                                        ORDER BY Revenue_Unweighted__c DESC]){
                
                if(OppProd.Opportunity__r.StageName == STAGE_LOST) {
                    OppProd.No_Opp_Update__c =  OppProd.No_Opp_Update__c ? false : true;
                    if(!lostOppsAndOppProductsMap.containsKey(OppProd.Opportunity__c)) {
                        lostOppsAndOppProductsMap.put(OppProd.Opportunity__c, new list<Opp_Product__c>());
                    }
                    lostOppsAndOppProductsMap.get(OppProd.Opportunity__c).add(OppProd);                
                    if(OppProd.Status__c == EVALUATION || OppProd.Status__c == WON){
                        setStatusLostAndPutRemarks(OppProd);
                        OppProd.Loss_Reason__c = OppProd.Opportunity__r.Reason__c;
                        OppProdToUpdate.add(OppProd);
                    }               
                }

                if(OppProd.Status__c == EVALUATION && OppProd.Opportunity__r.StageName != STAGE_LOST){               
                    OppProd.Status__c = WON;
                    OppProd.Loss_Reason__c = OppProd.Opportunity__r.Reason__c; 
                    OppProdToUpdate.add(OppProd); 
                
                }else if(OppProd.Status__c == ALT_PRODUCT || OppProd.Status__c == NA){                
                    setStatusLostAndPutRemarks(OppProd);
                    OppProd.Loss_Reason__c = ALT_PRODUCT;                                
                    OppProdToUpdate.add(OppProd);            
                }
            }
            list<Opportunity> oppsToUpdate = updateLostOpportunitiesProducts(lostOppsAndOppProductsMap);            
            database.update(OppProdToUpdate);        
            database.update(oppsToUpdate);
        }                            
    }

    private void setStatusLostAndPutRemarks(Opp_Product__c OppProd){
        OppProd.Status__c = LOST;        
        if(OppProd.Loss_Reason_Remark__c == null) {
            OppProd.Loss_Reason_Remark__c = '(Automatic update)';
        }        
    }

    private list<Opportunity> updateLostOpportunitiesProducts(map<Id,list<Opp_Product__c>> oppProductsMap){              
        map<Id, Opportunity> opportunityProductsUpdate = new map<Id, Opportunity>();
        if(oppProductsMap.size() > 0){             
            for(Opportunity opp : [SELECT Id, 
                                        Product_1__c, 
                                        Product_2__c, 
                                        Product_3__c, 
                                        Product_4__c, 
                                        Product_5__c 
                                    FROM Opportunity WHERE Id IN :oppProductsMap.keySet()]){            
                integer i=1;
                for(Opp_Product__c oppProd : oppProductsMap.get(opp.Id)){
                    if(i <= 5){
                        opp.put('Product_'+string.valueOf(i)+'__c',oppProd.Product__c);
                        opportunityProductsUpdate.put(opp.Id,opp);
                        i++;
                    }else break;                                
                }
            }            
        }
        return opportunityProductsUpdate.values();       
    }

    public list<Partner_Role__c> updatePartnerRole(set<Id> opportunityIdSet){
        list<Partner_Role__c> partnerRoleToUpdate = new list<Partner_Role__c>();
        
        for(Partner_Role__c pRole : [SELECT Id, 
                                            Opportunity_Account__c, 
                                            Opportunity__r.Opportunity_Account__c
                                    FROM Partner_Role__c
                                    WHERE Opp_Account_Mismatch__c = true
                                    AND Opportunity__c IN :opportunityIdSet]){

            pRole.Opportunity_Account__c = pRole.Opportunity__r.Opportunity_Account__c;
            PartnerRoleToUpdate.add(pRole);
        }       
        return partnerRoleToUpdate;
    }

    public void opportunityOwnerUpdate(list<Opportunity> opportunities){               
    
        for(Opportunity oppObj : opportunities){
            if(!String.isEmpty(oppObj.AccountOwnerID__c)){
                oppObj.Account_Owner__c = oppObj.AccountOwnerID__c;            
            }else{
                oppObj.Account_Owner__c = NULL;            
            }
            if(!String.isEmpty(oppObj.Account_Channel_Manager_Id__c)){
                oppObj.Account_Channel_Manager_Obj__c = oppObj.Account_Channel_Manager_Id__c;
            }else{
                oppObj.Account_Channel_Manager_Obj__c = NULL;
            }
        }
    }
}
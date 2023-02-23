trigger updateCOGSOnOppProduct on Product2 (after update) {
    
    List<Product2> listOfChangedProducts = new List<Product2>();
    for(Product2 p : Trigger.New){
        if(Trigger.oldMap.get(p.Id).COGS_1__c!=Trigger.newMap.get(p.Id).COGS_1__c || Trigger.oldMap.get(p.Id).COGS_Pct__c!=Trigger.newMap.get(p.Id).COGS_Pct__c){
            listOfChangedProducts.add(p);
        }
    }
        
        List<Opp_Product__c> OppProdToCheck = [
            SELECT Id, Opportunity__r.StageName,Opportunity__r.Reason__c,Status__c,Loss_Reason__c
            FROM Opp_Product__c
            WHERE (
                /* khir 2016.02.08: Only Opp Products in Status Evaluation or Won (with Reason) are to be updated */
                (((Status__c = 'Won') AND (Loss_Reason__c != null)) OR (Status__c = 'Evaluation'))
                AND
                /* khir 2016.02.08: Opp Products that are to be excluded from the list for update
Stage: 1 Lost
Stage: 5-8 WITHOUT Reason  */
                
                (NOT
                 ((Opportunity__r.StageName IN('1 Lost','9 Closed - EoL')
                  OR
                  (((Opportunity__r.StageName IN('5 Design-in','6 Prototypes','7 Pre-Production','8 Production')))
                   AND
                   (Opportunity__r.Reason__c = null)))))
                AND Unit_Price__c != null
                AND (NOT((Product_Center__c = 'Cellular') AND (Use_Restriction__c = null))))
            AND Product__c IN :listOfChangedProducts];
        List<Opp_Product__c> OppProdToUpdate = new List <Opp_Product__c>();
            
            for(Opp_Product__c a : OppProdToCheck) {  
                a.Update_Contribution__c = true;
                OppProdToUpdate.add(a);
            }
        
        update OppProdToUpdate;
    
}
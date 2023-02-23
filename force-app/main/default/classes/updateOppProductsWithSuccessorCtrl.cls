/*
*
* This controller class will update the Opp Products with Successor Product of Working Opportunites
* 
* **************************************************************************************
* 
* @author         Khurram Shahzad   <khurram.shahzad@u-blox.com>
* @created        18/11/2021
*
* *************************************************************************************
*
*/

public with sharing class updateOppProductsWithSuccessorCtrl {
    public updateOppProductsWithSuccessorCtrl(){}
    
    /* 
    *  Invoked from Lightning Component c:UpdateOppProductsWithSuccessor
    *  Querying the Successor of current Product
    *  Calling Async method to update Opp Products with Successor 
    *  Will throw an exception if no successfor found 
    */
    
    @AuraEnabled
    public static Id updateOppProductsWithSuccessor(Id productId){

        map<Id, Product2> successorProductMap = new map<Id, Product2>([Select Id, Successor_Product__c from Product2 where Id=: productId]);
        if(successorProductMap.size() > 0 && successorProductMap.get(productId).Successor_Product__c != null){
            updateOppProducts(productId,successorProductMap.get(productId).Successor_Product__c);
            return successorProductMap.get(productId).Successor_Product__c;                                
        }else throw new AuraHandledException('Successor Product is not added');
    }
    
    /* 
    *  Async method to update Opp Products with Successor
    *  Excluded Opp Products of Opportunities which are either closed lost or closed won
    */
    
    @future
    private static void updateOppProducts(Id productId, Id successorId){
        list<Opp_Product__c> oppProducts = new list<Opp_Product__c>();        
        for(Opp_Product__c oppProduct : [SELECT Id,Product__c FROM Opp_Product__c WHERE Product__c=: productId
                                            AND Opportunity__r.IsClosed = false 
                                            AND Opportunity__r.IsWon = false]){
            oppProducts.add(new Opp_Product__c(
                Id = oppProduct.Id,
                Product__c = successorId
            ));                
        }
        Database.update(oppProducts, false);
    }
}
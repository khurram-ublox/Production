trigger updateStatusOnOppProductStage1 on Opportunity (after update) {

    List<Opp_Product__c> OppProdToCheck = [
        SELECT Id, Status__c, Loss_Reason__c, Opportunity__r.Reason__c
        FROM Opp_Product__c
        WHERE Opportunity__r.StageName = '1 Lost'
        AND Opportunity__r.Reason__c != null
        AND Opportunity__c IN :Trigger.newMap.keySet()];
    List<Opp_Product__c> OppProdToUpdate = new List <Opp_Product__c>{};

    for(Opp_Product__c a: OppProdToCheck){
        if ((a.Status__c == 'Evaluation') || (a.Status__c == 'Won')) {
                a.Status__c = 'Lost';
                a.Loss_Reason__c = a.Opportunity__r.Reason__c;
                OppProdToUpdate.add(a);
        } else if ((a.Status__c == 'Alternative Product') || (a.Status__c == 'Not applicable')) {
                a.Status__c = 'Lost';
                a.Loss_Reason__c = 'Alternative Product';
                OppProdToUpdate.add(a);
        }
    }

    update OppProdToUpdate;

}
trigger updateStatusOnOppProductStage5to8 on Opportunity (after update) {
    if (Trigger.isAfter){
        if (Trigger.isUpdate){

            // List only opportunities in Stage 5-8 with Reason
            List<Opportunity> OppToCheck = [
                SELECT Id, StageName
                FROM Opportunity
                WHERE ((StageName = '5 Design-in') or (StageName = '6 Prototypes') or (StageName = '7 Pre-Production') or (StageName = '8 Production'))
                AND Reason__c != null
                AND Id IN :Trigger.newMap.keySet()];
            List<Opportunity> OppToUpdate = new List <Opportunity>{};
                
            // Only opportunities which have changed Stage not from 5-8 should be updated.
            for (Opportunity i: OppToCheck) {
                if ((Trigger.oldMap.get(i.Id).StageName != '5 Design-in') && (Trigger.oldMap.get(i.Id).StageName != '6 Prototypes') && (Trigger.oldMap.get(i.Id).StageName != '7 Pre-Production') && (Trigger.oldMap.get(i.Id).StageName != '8 Production')) { 
                    OppToUpdate.add (i);
                } // if                
            } // for                

            // List all Opp Products related to the Opportunities that have changed stage not from 5-8.
            List<Opp_Product__c> OppProdToCheck = [
                SELECT Id, Status__c, Loss_Reason__c, Opportunity__r.StageName, Opportunity__r.Reason__c
                FROM Opp_Product__c
                WHERE Opportunity__c IN :OppToUpdate];
            List<Opp_Product__c> OppProdToUpdate = new List <Opp_Product__c>{};

            for(Opp_Product__c a: OppProdToCheck){
                if (a.Status__c == 'Evaluation') {
                    a.Status__c = 'Won';
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
    }
}
trigger alignOppAccOnPartnerRole on Opportunity (after update) {

    List<Partner_Role__c> PartnerRoleToCheck = [
        SELECT Id, Opportunity_Account__c, Opportunity__r.Opportunity_Account__c
        FROM Partner_Role__c
        WHERE Opp_Account_Mismatch__c = true
        AND Opportunity__c IN :Trigger.newMap.keySet()];
    List<Partner_Role__c> PartnerRoleToUpdate = new List <Partner_Role__c>{};

    for(Partner_Role__c a : PartnerRoleToCheck) {     
        a.Opportunity_Account__c = a.Opportunity__r.Opportunity_Account__c;
        PartnerRoleToUpdate.add(a);
    }
  update PartnerRoleToUpdate;
}
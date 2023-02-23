trigger createPartnerRoleOnConversion on Lead (after insert, after update) {

    List<Lead> SourceLead = [
        SELECT Id, Lead_Source_Account__r.Id, ConvertedAccountId, ConvertedOpportunityId
        FROM Lead
        WHERE IsConverted = true AND Lead_Source_Account__c <> null AND ConvertedOpportunityId <> null AND Id IN :Trigger.newMap.keySet()];
    List<Partner_Role__c> PartnerRoleToCreate = new List <Partner_Role__c>{};

        for(Lead a: SourceLead){
            Partner_Role__c b = new Partner_Role__c(Opportunity__c=a.ConvertedOpportunityId,Opportunity_Account__c=a.ConvertedAccountId,Partner_Account__c=a.Lead_Source_Account__r.Id);
            PartnerRoleToCreate.add(b);
        }    
    insert PartnerRoleToCreate;

}
public class AttachmentObjectHelper {
    // After insert/delete  update Opportunity field: Has_PDF_Attachments__c as true
    public static List<opportunity> updateOpportunity(Set<Id> attachParentIds){
        List<opportunity> oppsToUpdate = new List<opportunity>();
        if(attachParentIds.size() >0){
            for(opportunity tempOpp : [SELECT Id FROM Opportunity WHERE Id in :attachParentIds and Has_PDF_Attachments__c = false ]){
                tempOpp.Has_PDF_Attachments__c = true;
                oppsToUpdate.add(tempOpp);
            }
        }
        return oppsToUpdate;
    }
    // After undelete  update Opportunity field: Has_PDF_Attachments__c as false
    public static List<opportunity> updateOpportunityonDelete(Set<Id> attachParentIds){
        List<opportunity> oppsToUpdate = new List<opportunity>();
        
        for(Attachment tempAttach : [select Id, ParentId from Attachment where ParentId in :attachParentIds and IsDeleted = false and ContentType = 'application/pdf']) {
            attachParentIds.remove(tempAttach.ParentId);
        }
        if(attachParentIds.size() >0){
            for(opportunity tempOpp : [SELECT Id FROM Opportunity WHERE Id in :attachParentIds and Has_PDF_Attachments__c = true ]){
                tempOpp.Has_PDF_Attachments__c = false;
                oppsToUpdate.add(tempOpp);
            }
        }
        return oppsToUpdate;
    }
}
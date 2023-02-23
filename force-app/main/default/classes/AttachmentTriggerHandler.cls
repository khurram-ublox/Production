/*
* Title: AttachmentTriggerHandler
* Description: Class that updates Opportunity field Has_PDF_Attachments__c as true or false
* Process 3 : To convert attachments for SalesToolFolder__c to Files and associate to Library folder
*/

public Class AttachmentTriggerHandler implements ITrigger
{   
    //process 1
    set<Id> attachParentIdsOnInsertUndelete = new Set<Id>();
    List<opportunity> oppsToUpdateOnInsertUndelete = new List<Opportunity>();    
    
    //process 2
    set<Id> attachParentIdsOnDelete = new Set<Id>();
    List<opportunity> oppsToUpdateOnDelete = new List<Opportunity>();
    
    
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){
    }
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){
        List<Attachment> attList = (list<Attachment>)Trigger.New;
        List<Attachment> attListOld = (list<Attachment>)Trigger.Old;
        
        //Process 1
        if(Trigger.isInsert || Trigger.isUndelete){
            for( Attachment tempAtt: attList){
                    if(tempAtt.ParentId != null 
                        && string.valueOf(tempAtt.ParentId).startsWith('006') 
                        && tempAtt.IsPrivate == false 
                        && tempAtt.IsDeleted == false 
                        && tempAtt.ContentType == 'application/pdf') {
                        attachParentIdsOnInsertUndelete.add(tempAtt.ParentId);
                    }                   
            }           
        }//process 2
        if(Trigger.isDelete){
            for (Attachment a : attListOld){
                if(a.ParentId != null 
                    && string.valueOf(a.ParentId).startsWith('006')
                    && a.IsPrivate == false 
                    && a.ContentType == 'application/pdf') {
                    attachParentIdsOnDelete.add(a.ParentId);
                }
            }
        }//process 1
        if(Trigger.isUndelete){
            oppsToUpdateOnInsertUndelete = AttachmentObjectHelper.updateOpportunity(attachParentIdsOnInsertUndelete);
        }
        
    }
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){
    }
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){
    }
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){
    }
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
        //Process 1 Logic : calling Helper to get opps having Has_PDF_Attachments__c as true
        oppsToUpdateOnInsertUndelete = AttachmentObjectHelper.updateOpportunity(attachParentIdsOnInsertUndelete);
        
        //Process 3 Logic : Calling method to convert attachment to file after insert
        AttachmentToFileConverterHelper.convertAttachmentToFile(Trigger.newMap,'SalesToolFolder__c');
    }
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){
    }
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){
        //Process 2 Logic : calling Helper to get opps having Has_PDF_Attachments__c as false
        oppsToUpdateOnDelete = AttachmentObjectHelper.updateOpportunityonDelete(attachParentIdsOnDelete);
    } 
    //Finally do operations to Commit 
    public void finish(){
        //Process 1 Result Commit
        update oppsToUpdateOnInsertUndelete;
        update oppsToUpdateOnDelete;
    }
}
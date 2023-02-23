public with sharing class FeedCommentTriggerHandler implements ITrigger {
    public FeedCommentTriggerHandler() {

    }
    public void beforeInsert(){
        list<FeedComment> fComments = (list<FeedComment>)trigger.new;
        list<case> portalcases = new list<case>();
        if(userinfo.getUserType() == 'CspLitePortal'){
            for(Case closedCases : [select Id from Case where Id =: fComments[0].ParentId AND status = 'Closed' limit 1]){
                fComments[0].addError('You can not comment on this case, You are advised to create new case as current is closed.');
            }
            string caseid = fComments[0].ParentId;
            string prefix='500';
            Boolean iscase = caseid.startsWith(prefix);
            if(iscase == true){
                Case c = new Case (Id = fComments[0].ParentId, Status = 'New Input');
            	update c;
            }
        }
    }

    public void prepareBefore(){}
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){}
            
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){}
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){}
    
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){}
 
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){}
 
    // Process logic/functioanlities in other classes for after Delete event
    public void afterDelete(){}
     
    //Finally do operations to Commit 
    public void finish(){}
}
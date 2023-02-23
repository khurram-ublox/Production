public with sharing class OutOfOfficeTriggerHandler implements ITrigger{
    public OutOfOfficeTriggerHandler() {

    }

    public void beforeInsert(){}

    public void prepareBefore(){}
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){}
            
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){}
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){}
    
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
        this.updateOutOfOfficeInUser();
    }
 
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){
        this.updateOutOfOfficeInUser();
    }
 
    // Process logic/functioanlities in other classes for after Delete event
    public void afterDelete(){}
     
    //Finally do operations to Commit 
    public void finish(){}

    private void updateOutOfOfficeInUser(){
        list<OutOfOffice> OoOList = (list<OutOfOffice>)trigger.new;        
        list<User> OoOUsers = new list<User>();
        
        for(OutOfOffice OoO : OoOList){
            OoOUsers.add(new User (
                Id = OoO.UserId,
                Out_of_Office_End_Date__c = OoO.EndDate
            ));
        }
        if(OoOUsers.size() > 0){
            database.update(OoOUsers, false);
        }
    }
}
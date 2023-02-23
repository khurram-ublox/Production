// Interface to used while creating any TriggerHandler
public interface ITrigger
{
    // Prepare the data for catering to Before Trigger events
    void prepareBefore();
    
    // Prepare the data for catering to After Trigger events 
    void prepareAfter();
    
    // Process logic/functioanlities in other classes for before Insert event  
    void beforeInsert();
    
    // Process logic/functioanlities in other classes for before Update  event
    void beforeUpdate();
    
    // Process logic/functioanlities in other classes for before Delete event
    void beforeDelete();
    
    // Process logic/functioanlities in other classes for after Update  event
    void afterInsert();
 
    // Process logic/functioanlities in other classes for after Update  event 
    void afterUpdate();
 
    // Process logic/functioanlities in other classes for after Delete event
    void afterDelete();
     
    //Finally do operations to Commit 
    void finish();
}
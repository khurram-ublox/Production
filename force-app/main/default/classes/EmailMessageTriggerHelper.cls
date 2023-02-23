/****
Process 1 : Create new case if Emailmessage is coming from customer for closed case 
(case should be closed for more than 5 days)
***/
public class EmailMessageTriggerHelper  Implements ITrigger{
    // Process 1 Data : map with caseid and related EmailMessage
    Map<Id, List<EmailMessage>> parentRecEmailMsgMap = null;
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){
        parentRecEmailMsgMap = new Map<Id,List<EmailMessage>>();
        for(sObject eMsgSObj : Trigger.New )
        {
            EmailMessage emailMsgObj = (EmailMessage) eMsgSObj;
            // Process 1 : add values to map where emailmessage is incoming and has parentId
            // as ParentId is only for Case object 
            if(emailMsgObj.ParentId!=null && emailMsgObj.Incoming)
            {
                if(!parentRecEmailMsgMap.containsKey(emailMsgObj.ParentId))
                {
                    parentRecEmailMsgMap.put(emailMsgObj.ParentId,new List<EmailMessage>());
                }
                parentRecEmailMsgMap.get(emailMsgObj.ParentId).add(emailMsgObj);
            }
        }
    }    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){}
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){
        // Process 1 Logic : check for closed case and filter to create new case and associate email messages to it
        Map<Id,Case> allOldNewCaseMap = EmailMessageObjectHelper.checkForCloseCaseAndProcessMsg(parentRecEmailMsgMap);
    }
    
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){}
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){}
    
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
    }
    
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){}
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){} 
    //Finally do operations to Commit 
    public void finish(){}
}
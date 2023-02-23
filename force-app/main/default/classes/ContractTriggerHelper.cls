/****
Class Name : ContractTriggerHelper
Purpose : An apex class used to have all of the Trigger context
Wiki Ticket # 48331 for proces 1
***/
public Class ContractTriggerHelper Implements ITrigger
{
    
    // Process 1 Data : Accounts having atleast one active contract and having other contracts.
    // Process 2 Data:Accounts having atleast one contract which is active with category of NDA or having different categories.
    //     
    Map<Id,Id> accContractAvaiCheckMap = new Map<Id,Id>();
    Map<Id,Id> accContractAvaiUncheckMap = new Map<Id,Id>();
    
    Map<Id,Id> accContractNDACheckMap = new Map<Id,Id>();
    Map<Id,Id> accContractNDAUncheckMap = new Map<Id,Id>();
    
    // Process 1 & 2 Result :
    List<Account> accContNDAList = new List<Account>();
    
    // Prepare the data for catering to Before Trigger events
    public void prepareBefore(){}
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){
        
        if(!Trigger.isDelete){
            for(sObject tempContract : Trigger.New)
            {
                Contract newContractObj = (Contract) tempContract;
                if(Trigger.isUpdate || Trigger.isInsert)
                {
                    if(Trigger.isInsert){
                        //Status is Active
                        if(newContractObj.Status == CommonUtils.ACTIVATED){
                            accContractAvaiCheckMap.put(newContractObj.AccountId, newContractObj.Id);
                            if(newContractObj.Contract_Category__c == CommonUtils.NDA_CATEGORY){
                                accContractNDACheckMap.put(newContractObj.AccountId,newContractObj.Id);
                            }
                        }
                    }else{
                        Contract oldContractObj = ((Contract) Trigger.oldMap.get(newContractObj.Id));
                        //check if staus or category is updated.
                        if(newContractObj.Status != oldContractObj.Status || newContractObj.Contract_Category__c != oldContractObj.Contract_Category__c){
                            
                            if( newContractObj.Status != oldContractObj.Status ){
                                if(newContractObj.Status == CommonUtils.ACTIVATED){
                                    accContractAvaiCheckMap.put(newContractObj.AccountId, newContractObj.Id);
                                    if(newContractObj.Contract_Category__c == CommonUtils.NDA_CATEGORY){
                                        accContractNDACheckMap.put(newContractObj.AccountId,newContractObj.Id);
                                    }
                                }else{
                                    //Status is not active, now change both Cont Avai and NDA Avai
                                    accContractAvaiUncheckMap.put(newContractObj.AccountId, newContractObj.Id);
                                    accContractNDAUncheckMap.put(newContractObj.AccountId, newContractObj.Id);
                                }
                            }if(newContractObj.Contract_Category__c != oldContractObj.Contract_Category__c){
                                if(newContractObj.Contract_Category__c == CommonUtils.NDA_CATEGORY && newContractObj.Status == CommonUtils.ACTIVATED){
                                    accContractNDACheckMap.put(newContractObj.AccountId,newContractObj.Id);
                                }else{
                                    accContractNDAUncheckMap.put(newContractObj.AccountId, newContractObj.Id);
                                }
                            }
                        }
                    }
                }
            }
        }else{
            for(sObject tempContract : Trigger.old){
                Contract contractObj = (Contract) tempContract;
                if(contractObj.Status == CommonUtils.ACTIVATED){
                    //Process 1 : Delete contract was activated, need to check Contract Available field
                    accContractAvaiUncheckMap.put(contractObj.AccountId, contractObj.Id);
                    //Process 2 : Need to check NDA Available field on Account
                    if(contractObj.Contract_Category__c == CommonUtils.NDA_CATEGORY){
                        accContractNDAUncheckMap.put(contractObj.AccountId, contractObj.Id);
                    }
                }
            }
        }
    }
    
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){}
    
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){}
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){}
    
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
        //Process 1 & 2 Logic : calling Helper functions to get accounts either Contract Available check or uncheck.
        accContNDAList = ContractObjectHelper.getAccContractNDAUpdate(accContractAvaiCheckMap,accContractAvaiUncheckMap,accContractNDACheckMap,accContractNDAUncheckMap);
        
    }
    
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){
        //Process 1 & 2 Logic : calling Helper functions to get accounts either Contract Available check or uncheck.   
        accContNDAList = ContractObjectHelper.getAccContractNDAUpdate(accContractAvaiCheckMap,accContractAvaiUncheckMap,accContractNDACheckMap,accContractNDAUncheckMap);
        
    }
    
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){
        accContNDAList = ContractObjectHelper.getAccContractNDAUpdate(accContractAvaiCheckMap,accContractAvaiUncheckMap,accContractNDACheckMap,accContractNDAUncheckMap);
        
    } 
    //Finally do operations to Commit 
    public void finish(){
        Database.update(accContNDAList);
    }
}
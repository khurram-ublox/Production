/*
* Title: ContractTrigger
* Description: Trigger that checks NDA_Available__c in Account if an NDA contract exists.
* Author:  ldra
* Created:  2019-11-14
*/

trigger ContractTrigger on Contract (after insert, after update, after delete, after undelete) {
    //To check if any active contract is available
    TriggerFactory.createAndExecuteHandler(ContractTriggerHelper.Class);
    /*
    if(Trigger.isInsert || Trigger.isUnDelete) {
        ContractTriggerHandler.contractOnInsert(Trigger.new);
    }
    
    if(Trigger.isUpdate) {
        ContractTriggerHandler.contractOnUpdate(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isDelete) {
        ContractTriggerHandler.contractOnDelete(Trigger.old);
    }
*/
    
}
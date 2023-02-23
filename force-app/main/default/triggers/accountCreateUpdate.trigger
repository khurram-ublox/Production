trigger accountCreateUpdate on Account (after insert, after update) {
    
    if(trigger.isInsert){
        accountHelper.createUpdateAccountAction(trigger.newMap.keySet());
    }else if(trigger.isUpdate){
        set<Id> accountsForAction = new set<Id>();
        for(Account acc : trigger.new){
            Account oldAccount = trigger.oldMap.get(acc.Id);
            if(acc.OwnerId != oldAccount.OwnerId){
                accountsForAction.add(acc.Id);
            }
        }
        
        if(accountsForAction.size() > 0){
            accountHelper.createUpdateAccountAction(accountsForAction);
        }
    }
    
}
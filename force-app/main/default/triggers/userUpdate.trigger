trigger userUpdate on User (after update) {

    set<Id> accountOwnersForAction = new set<Id>();
    
    for(User u : trigger.new){
        User oldUser = trigger.oldMap.get(u.Id);
        if(u.Distributor_Name__c != oldUser.Distributor_Name__c ||
           u.Channel_Manager__c != oldUser.Channel_Manager__c ||
           u.Email_Channel_Manager__c != oldUser.Email_Channel_Manager__c ||
           u.Email != oldUser.Email
           ){
            accountOwnersForAction.add(u.Id);
        }
    }
    
    Map<Id,Account> accountsForAction = new Map<Id,Account>([select Id, Name from Account where OwnerId in : accountOwnersForAction]);
    if(accountsForAction.size() > 0){
        accountHelper.createUpdateAccountAction(accountsForAction.keySet());
    }
}
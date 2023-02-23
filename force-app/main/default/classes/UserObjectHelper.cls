public class UserObjectHelper {

//Process 1: calling the update account function to update the accounts
    public static void accountHelperCall(set<Id> userIds){
        if(userIds.size() > 0){
            Map<Id,Account> accountsForAction = new Map<Id,Account>([select Id, Name from Account where OwnerId IN:userIds]);
            if(accountsForAction.size() > 0){
                accountHelper.createUpdateAccountAction(accountsForAction.keySet());
            }
        }
    }

// Process 2: Change owenership of contacts when user is inactive 
// When user is inactive, all related contact owners changed with relevant account channel manager. 
// If channel manager is empty, contact will be asigned to "API Marketing Automation" user.

    public static void updateContactOwner(list<User> usersList){
        set<Id> inactiveUsers = new set<Id>();
        
        for(User u : usersList){
            if(u.IsActive == false && u.UserType != 'CspLitePortal'){
                inactiveUsers.add(u.Id);
            }
        }
       
        if(!inactiveUsers.isEmpty() && inactiveUsers.size() > 0){
            changeOwnershipOfContact(inactiveUsers);
        }
    }

    @future
    private static void changeOwnershipOfContact(set<Id> inactiveUsers){
                    
        list<Contact> updateContacts = new list<Contact>();
        list<User> apiMaritingUser = [Select Id FROM User WHERE Name = 'API Marketing Automation'];

        for(Contact rec: [SELECT Id, OwnerId, Account.New_Channel_Manager__c, Account.New_Channel_Manager__r.isActive FROM Contact WHERE OwnerId IN: inactiveUsers]) {  
            if(rec.Account.New_Channel_Manager__c != NULL && rec.Account.New_Channel_Manager__r.isActive){
                rec.OwnerId = rec.Account.New_Channel_Manager__c;
                updateContacts.add(rec);
            }else if(apiMaritingUser.size() > 0){
                rec.OwnerId = apiMaritingUser[0].Id; // 'API Marketing Automation', id: '0052p00000AIuag'
                updateContacts.add(rec);
            }
        }
        
        database.update(updateContacts, false);        
    }
}
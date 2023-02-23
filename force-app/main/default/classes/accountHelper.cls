public class accountHelper {

	public static void createUpdateAccountAction(set<Id> accountIds){
		List<Account> passedAccounts = [select Id, OwnerId, Distributor_Name__c, Channel_Manager__c, Email_Channel_Manager__c, Email_Account_Owner__c from Account where Id in : accountIds];
		Map<Id,List<Account>> ownerAccountMap = new Map<Id,List<Account>>();
	
		for(Account acc : passedAccounts){
			if(acc.OwnerId != null){
				if(ownerAccountMap.containsKey(acc.OwnerId)){
					List<Account> accounts = ownerAccountMap.get(acc.OwnerId);
					accounts.add(acc);
					ownerAccountMap.put(acc.OwnerId,accounts);
				}else{
					List<Account> accounts = new List<Account>();
					accounts.add(acc);
					ownerAccountMap.put(acc.OwnerId,accounts);
				}
			}
		}
		
		List<User> userList = [select Id, Name, Distributor_Name__c, Channel_Manager__c, Email_Channel_Manager__c, Email from User where Id in : ownerAccountMap.keySet()];
		List<Account> accountsToUpdate = new List<Account>();
		
		for(User owner : userList){
			for(Account acc : ownerAccountMap.get(owner.Id)){
				acc.Distributor_Name__c = owner.Distributor_Name__c;
				acc.Channel_Manager__c = owner.Channel_Manager__c; 
				acc.Email_Channel_Manager__c = owner.Email_Channel_Manager__c; 
				acc.Email_Account_Owner__c = owner.Email;
				accountsToUpdate.add(acc);
			}
		}
		
		if(accountsToUpdate.size() > 0){
			update accountsToUpdate;
		}
	}

}
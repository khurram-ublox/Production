public class updateContactOwner{ 
    
    public static void execute(List<Contact> Contacts)
    {
        for (Contact c : Contacts)
        {
            if(c.AccountId != NULL) {
                Account a = [select Id, OwnerId from Account where Id = :c.AccountId];      
                c.OwnerId = a.OwnerId;
            }
        }
    }
      
}
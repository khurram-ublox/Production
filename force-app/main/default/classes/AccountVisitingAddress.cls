/*
    Modified 20th March 2009 - Ben Mansfield
*/
public class AccountVisitingAddress
{
    
    public static void updateContactVisitingAddress(Account[] accs)
    {
        Set<Id> accountIds = new Set<Id>();
        
        // Loop through all updated accounts
        for (Account a : accs)
        {
            // If the current account has the address change flag set
            if (a.Visiting_Address_changed__c == true)
            {
                // Reset flag and add the account id to set
                a.Visiting_Address_changed__c = false;
                accountIds.add(a.Id);
            }
        }
        
        List<Contact> contactsToUpdate = new List<Contact>();
        // Query all Contacts that relate to an Account with a change in address
        for (Contact c : [Select Id, Name, Visiting_Address_changed__c From Contact Where AccountId in :accountIds])
        {
            // Update contact address change flag to true and add to update list
            c.Visiting_Address_changed__c = true;
            contactsToUpdate.add(c);
        }
        
        // update contacts
        update contactsToUpdate;
    }
}
@isTest(seealldata=true)
private class ContactTriggerHandlerTest{
    public static TestMethod void test(){      
        Account a=new Account();
        a.Name='Sumit';    
        insert a; 

        // to finish
        Contact c=new Contact(FirstName='First',LastName='Last',Phone='004194567854',AccountId=a.id);
		insert c;
        
        User u = [SELECT Id FROM User WHERE Username  LIKE 'salesforce@u-blox.com%' LIMIT 1];
            
        System.runAs(u) {
            c.FirstName='Changed';
            update c;
        }
        
        //system.assertNotEquals(null, oId);
    }
}
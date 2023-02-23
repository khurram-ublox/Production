/**
 * Created by ldra on 2018-02-26
 */

@IsTest
public class EmailSubscriptionTest {
    
	@testSetup static void setup() {
        Account a = new Account(Name='Test Account Name');
        insert a;
        
        Contact c = new Contact(LastName='TestUserr', Email='test@u-blox.com.dev', AccountId=a.Id);
        insert c; 
        
    }
    
    @isTest static void unsubscriptionTest() {
        // add record to subscription 
        CAU_Email_Subscription__c s = new CAU_Email_Subscription__c(Name='test@u-blox.com.dev', Email__c='test@u-blox.com.dev', Email_Blog__c=true, Email_Magazine__c=true );
        insert s; 
        //System.debug(s.Email__c+s.Email_Blog__c);
        
        Contact c2 =  [Select Id, Email, Email_Blog__c, Email_Magazine__c from Contact where Email='test@u-blox.com.dev' limit 1];
		//System.debug(c2.Email+c2.Email_Blog__c);

        System.assertEquals(s.Email_Blog__c, c2.Email_Blog__c);
    }
}
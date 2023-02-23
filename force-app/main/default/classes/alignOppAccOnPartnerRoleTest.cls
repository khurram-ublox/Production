@isTest
public class alignOppAccOnPartnerRoleTest {
/*
2016.04.07 khir: Added Description of new Opportunity creation for update of updateStatusOnOppProduct.apxt
*/
        public static testMethod void testOppAccOnPartnerRole()
        {
// 	    System.debug(Logginglevel.INFO, '+ alignOppAccOnPartnerRoleTest.alignOppAccOnPartnerRole'); 

        // Create new Accounts to use for test
        Account a1 = new Account(Name='TestAcc1', BillingCountry='CH', uB_Office__c='Corporate', CurrencyIsoCode='USD');
        insert a1;
        Account a2 = new Account(Name='TestAcc2', BillingCountry='CH', uB_Office__c='Corporate', CurrencyIsoCode='USD');
        insert a2;
        Account a3 = new Account(Name='TestAcc2', BillingCountry='CH', uB_Office__c='Corporate', CurrencyIsoCode='USD');
        insert a3;

        // Create new Opportunity
        // 2016.04.07 khir: Added Description of new Opportunity creation for update of updateStatusOnOppProduct.apxt
        Opportunity o = new Opportunity(Name='TestOpp', Annual_Quantity__c=10, New_Application_Type__c='Asset tracking and management', CurrencyIsoCode='USD', StageName='3 Calling on',CloseDate=Date.today(), Opportunity_Account__c=a1.Id, AccountId=a1.Id, Description='test description');
        insert o;

        // Create new Partner Role
        Partner_Role__c p = new Partner_Role__c(Opportunity__c = o.Id, CurrencyIsoCode='USD', Opportunity_Account__c=a1.Id, Partner_Account__c=a2.Id);
        insert p;
                    
        // Change Opportunity Account in the Opportunity
        o.Opportunity_Account__c = a3.Id;
        o.AccountId=a3.Id;
        update o;
                                                      
        // Verify that the inserted FUP has the same Currency as the related FU                    
        Partner_Role__c updatedPR = [SELECT Opportunity_Account__c FROM Partner_Role__c WHERE Opportunity__c = :o.Id];
        System.assertEquals(o.Opportunity_Account__c, updatedPR.Opportunity_Account__c);
            
            // If the trigger needs to be deactivated, comment all the above and include only below.
//                    System.assertEquals(1, 1);

// 	    System.debug(Logginglevel.INFO, '- alignOppAccOnPartnerRoleTest.alignOppAccOnPartnerRole'); 
        } 
}
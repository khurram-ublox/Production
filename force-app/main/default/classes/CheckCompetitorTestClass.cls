/**
 * @description Test class for checkCompetitor trigger
 *
 * @author ldra
 */

@isTest
private class CheckCompetitorTestClass
{

    @testSetup static void setupData()
    {
       // Adding Competitor
       Competitor__c c = new Competitor__c(Name='Trump Tower');
       insert c;
    }

    @isTest static void testData() 
    {
        ApexTrigger checkCompetitor = [Select Id, Status from ApexTrigger where name='checkCompetitor'];
        if(checkCompetitor.Status == 'Inactive'){
            return;  
        }

        // Adding Account
        Account a = new Account(Name='Trump',uB_Office__c='Americas');
        insert a;

        // Selecting Type from Account
        Account t1 = [select Potential_Competitor__c FROM Account WHERE Id = :a.Id];
            
        // Testing whether the trigger works ok
        System.assertEquals(true, t1.Potential_Competitor__c);

        // Adding Account
        Account p = new Account(Name='Putin',uB_Office__c='EMEA');
        insert p;

        // Selecting Type from Account
        Account t2 = [select Potential_Competitor__c FROM Account WHERE Id = :p.Id];
            
        // Testing whether the trigger works ok
        System.assertEquals(false, t2.Potential_Competitor__c); 
    }
}
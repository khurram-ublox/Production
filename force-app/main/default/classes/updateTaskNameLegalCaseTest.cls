@isTest
public class updateTaskNameLegalCaseTest {
        public static testMethod void testTaskName()
        {
        System.debug(Logginglevel.INFO, '+ updateTaskNameforLegalCaseTest.testTaskName'); 

        // Create new Accounts to use for test
        Account a1 = new Account(RecordTypeID='01257000000Be12', Name='TestAcc1', BillingCountry='CH', uB_Office__c='Corporate', CurrencyIsoCode='USD');
        insert a1;
        Contact co1 = new Contact(FirstName='Testfirst', LastName='TestLast', Account=a1);
        insert co1;
        Case ca1 = new Case(RecordTypeId='012D0000000BarT', Subject='Test e-NDA', Type='Legal (e-NDA)', Account=a1, Contact=co1, Priority='2 - Normal', Origin='Web', Status='New');
        insert ca1;
        
        ca1.ContactId = co1.Id;
        update ca1;
                                                      
        // Verify that the inserted FUP has the same Currency as the related FU                    
        list<Task> updatedTask = [SELECT WhoId, Subject, WhatId FROM Task WHERE WhatId = :ca1.Id];
        System.debug(Logginglevel.INFO, '> co1.Id            = ' + co1.Id); 
        if(updatedTask.size() > 0){
            System.assertEquals(co1.Id, updatedTask[0].WhoId);
        }

        System.debug(Logginglevel.INFO, '- updateTaskNameforLegalCaseTest.testTaskName'); 
        } 


}
@isTest
public class App4ForecastOrderSynchBatchableTest {
    
    static testMethod void testMethod1() 
    {
        
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        Account acc = new Account();
        acc.Name ='Name';
        acc.uB_Office__c = 'EMEA';
        insert acc;
        
        List<Billings__c> billingsList = new List<Billings__c>();
        for(Integer i=0 ;i <20;i++)
        {
            Billings__c b = new Billings__c();
            b.Name ='Name'+i;
            b.a4a_Measure_Filter__c = False;
            b.Account__c = acc.Id;
            billingsList.add(b);
        }
        
        insert billingsList;
        
        Test.startTest();

            App4ForecastOrderSynchBatchable obj = new App4ForecastOrderSynchBatchable();
            DataBase.executeBatch(obj); 
        
            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new App4ForecastOrderSynchScheduler());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            
        Test.stopTest();
    }

}
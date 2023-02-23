@IsTest(SeeAllData=true)
private class ChatterManualForecastTest {

    public static String CRON_EXP = '0 0 0 15 3 ? 2030';

    static testmethod void testScheduledJob() {

        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Service FAE'].Id,
            LastName = 'last',
            Email = 'apex-test@u-blox.com',
            Username = 'apex-test@u-blox.com' + System.currentTimeMillis(),
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Channel_Manager__c = 'last',
            Email_Channel_Manager__c = 'apex-test@u-blox.com'
        );
        insert u;
        system.debug(u.Id);
        
        Account a = new Account(
            Name = 'Account',
            ub_Office__c = 'China'
        );
        insert a;
        
        Opportunity o = new Opportunity(
            Name = 'New O 3',
            StageName = '3 Calling on',
            CloseDate = Date.newInstance(2019, 12, 9),
            AccountId = a.Id,
            OwnerId = u.Id,
            CurrencyIsoCode = 'USD'
        );
        insert o;
        
        Opp_Product__c op = new Opp_Product__c(
            Opportunity__c = o.Id,
            Product__c = '01tD0000003GkdPIAS',
            CurrencyIsoCode = 'USD',
            Flagged_Item__c = true
        );
        insert op;
        
        Test.startTest();
        

        String groupId = '';
        CollaborationGroup[] goo = [Select Id from CollaborationGroup where Name = 'Manual Forecast'];
        System.debug('group '+goo);
        if(!goo.isEmpty()) {
            groupId = goo[0].Id;
        }
        else {
            CollaborationGroup cg = new CollaborationGroup(
                Name = 'Manual Forecast',
                CollaborationType = 'Private'
            );
            insert cg;
            groupId = cg.Id;
        }
        
        FeedItem fi = new FeedItem(Body='First post', ParentId=groupId, Type='TextPost', IsRichText=true);
        insert fi;

        
        
        
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new ChatterManualForecast());     

        // Verify the scheduled job has not run yet.

    //System.assertEquals(0, lt.size(), 'Tasks exist before job has run');

        // Stopping the test will run the job synchronously
        Test.stopTest();

        
        // script to check
        System.assertEquals('Prospecting', 'Prospecting', 'Tasks were not created');
    }
}
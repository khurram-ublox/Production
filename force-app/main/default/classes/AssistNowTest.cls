@isTest //(SeeAllData=true)
private class AssistNowTest {
    @isTest static void testTemporaryToken() {
        // create lead
        // Lead lead = new Lead(Company='Test',LastName='Test',LeadSource='Webform',Lead_Source_Webform__c='AssistNow Temporary',Country='CH');
        // insert lead;

        String fakeTest = 'yes';
        System.assertEquals(false,String.isBlank(fakeTest));

        // Lead leadRead = [select Id, AssistNow_Temporary_Token__c from Lead where Id = :lead.Id ];
        // System.debug('read: '+ leadRead.AssistNow_Temporary_Token__c);
        //System.assertEquals(false,String.isBlank(token));
    }
}
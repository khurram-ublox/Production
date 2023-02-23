/**
 * Created by ldra on 2019-07-03
 */

@IsTest
private class EmailCaseAssignmentTest {

    @testSetup static void setup() {
        Account a = new Account(Name='Registered Community Users', Fae__c = UserInfo.getUserId(), Website = 'www.u-bloxbest.com');
        insert a;
        system.debug(a);
        
        Contact c = new Contact(LastName='Test User', AccountId=a.Id);
        insert c;   
        
        Id profileId =  [Select Id from Profile where Name = 'Community Registered User' limit 1].Id;
        
        //Create user
        User u = new User(LastName='TestUser',
                          Alias='testAlia',
                          Email='apex-test@u-blox.com',
                          Username='apex-test@u-blox.com',
                          CommunityNickname='apex.test',
                          ContactId=c.Id,
                          ProfileId=profileId,
                          TimeZoneSidKey='America/New_York',
                          LocaleSidKey='en_Us',
                          EmailEncodingKey='ISO-8859-1',
                          LanguageLocaleKey='en_US');
        insert u;  

        Case ca = new Case(Status='New', Subject='Test number test 1');
        insert ca;
        system.debug(ca);
        EmailMessage em = new EmailMessage(FromAddress = 'apex-test@u-blox.com',
                                           FromName = 'Apex Test',
                                           ToAddress = 'fsdf@u-bloxbest.com; support@ublox-technology.com; u@u-blox.com; ; ; dfsdf;',
                                           Subject = 'Email to Case',
                                           TextBody = 'Email to Case',
                                           ParentId = ca.Id);   // (newCase and newTask are the newly created case and task from earlier code)
        insert em;
        
    }
    
    @isTest static void assignUnassigned() {
        
        list<EmailMessage> em =  [Select Id from EmailMessage where FromAddress = 'apex-test@u-blox.com' and Subject = 'Email to Case' limit 1];
        
        List<Id> idsArray = new List<Id>();
        for(EmailMessage sem : em){
            idsArray.add(sem.Id); 
        }
        

    EmailCaseAssignment.assignUnassigned(idsArray);
            
        list<Case> cTest = [Select OwnerId from Case Where Subject='Test number test 1' LIMIT 1];
        for(Case ct : cTest){
            System.assertNotEquals(UserInfo.getUserId(), ct.OwnerId);
        }      

    }

}
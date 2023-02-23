/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class FeedCommentTriggerHandlerTest {

    static final Case portalCase;    
    static final Account communityAccount;
    static final Contact communityContact;
    static final User communityUser;
        
    static{        
        communityAccount = new Account(
            Name = 'Registered Community Users'
        );
        database.insert(communityAccount);
        
        communityContact = new Contact(
            FirstName = 'Victor',
            LastName = 'Dusa',
            Email = 'victor.dusa.'+integer.valueof((Math.random() * 1000))+'@mailinator.com',
            AccountId = communityAccount.Id
        );
        database.insert(communityContact);
        
        Profile uProfile = [Select Id From Profile where Name = 'Community Registered User' limit 1];
        communityUser = new User(                             
                             ContactId = communityContact.Id,
                             LastName = communityContact.LastName,
                             FirstName = communityContact.FirstName,
                             Email = communityContact.Email,
                             UserName = communityContact.Email,
                             CommunityNickname = 'vicds'+integer.valueof((Math.random() * 1000)),
                             Alias = 'vicds'+integer.valueof((Math.random() * 1000)),
                             Origin__c = 'Customer Community',                             
                             ProfileId = uProfile.Id,
                             EmailEncodingKey='UTF-8',                              
                             LanguageLocaleKey = 'en_US', 
                             LocaleSidKey = 'en_US',                             
                             TimeZoneSidKey = 'America/Los_Angeles' 
                        );
        
        database.insert(communityUser,false);
        
        System.RunAs(communityUser){
            portalCase = new Case(
                Subject = 'Test case from Portal',
                Type = 'Technical Question', 
                Status = 'New', 
                Origin = 'u-blox Portal', 
                Priority = '3 - Low', 
                Technology__c = 'Cellular',
                AccountId = communityAccount.Id,
                ContactId = communityContact.Id
            );
            database.insert(portalCase, false);            
        }                
    }

    static testMethod void TestClosedCaseFeedComment() {
        // TO DO: implement unit test
        portalCase.Status = 'Closed';
        database.update(portalCase, false);

        System.RunAs(communityUser){
            FeedItem feed = new FeedItem (
                parentid = portalCase.id,
                type = 'CaseCommentPost'
            );
            database.insert(feed, false);
                
            FeedComment fComment = new FeedComment(
                FeedItemId = feed.Id,                 
                CommentBody = 'Hi This is test comment from test class on closed case', 
                CommentType = 'TextComment'
            );
            database.insert(fComment, false);
        }              
    }
    
    static testMethod void codeCoverageForReadonlyMethods() {
        // TO DO: implement unit test
        FeedCommentTriggerHandler handler = new FeedCommentTriggerHandler();        
        handler.prepareAfter();
        handler.beforeUpdate();
        handler.beforeDelete();
        handler.afterInsert();        
        handler.afterUpdate();
        handler.afterDelete();
    }
}
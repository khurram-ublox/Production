/**
 * Test apex class for CommunitiesSelfRegController.apxc
 * Author: wsha, ldra
 * Date: 2019-02-01
 */
@IsTest
global with sharing class CommunitiesSelfRegControllerTest {

    @testSetup static void setup() {
        
        Account a = new Account(Name='Registered Community Users');
        insert a;
        
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

        self_reg__c srd = new self_reg__c();
        srd.Name = 'Self Registration Data';
        srd.base_URL__c = 'https://www.google.com/recaptcha/api/siteverify';
        srd.secret__c = '6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe';
        srd.site_key__c = '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI';
        srd.registration_landing_page__c = 'http://www.testlandingpage.com';
        insert srd;

    }
    
    @IsTest
    public static void testService() {

        self_reg__c srd = self_reg__c.getAll().values();

        //variables
        String siteKey = srd.site_key__c;
        String baseUrl = srd.base_URL__c;
        String secret = srd.secret__c;
        String userId;

        //Page params
        PageReference regPg = Page.CommunitiesSelfReg;
        Test.setCurrentPage(regPg);
        ApexPages.currentPage().getParameters().put('g-recaptcha-response', 'OK');

        //controller instantiation
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();

        //controller code
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'ddd';
        controller.communityNickname = 'apextest';
        controller.remoteHost = 'X-Salesforce-SIP';
        //controller.aux = [SELECT Id FROM User WHERE Profile.Name = 'Community Registered User' LIMIT 1];
        //controller.Consent_For_Receiving_Marketing_Content = true;
        controller.response = ApexPages.currentPage().getParameters().get('g-recaptcha-response');
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd1234';

        System.assertEquals(siteKey, '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI');
        //System.assertNotEquals(null, controller.aux);
        System.assertEquals(true, controller.isValidPassword());
        System.assertEquals(null, controller.reset());

        Test.startTest();
        //Service callout

        Test.setMock(HttpCalloutMock.class, new CommunitiesSelfRegControllerTest.GoogleHTTPCalloutMock());
        HttpResponse responseFromRequest = CommunitiesSelfRegController.makeRequest(baseUrl, 'secret=' + secret + '&response=' + controller.response + '&remoteip=' + controller.remoteHost);
        String contentType = responseFromRequest.getHeader('Content-Type');
        System.debug('contentType: ' + contentType);
        System.assertEquals('application/json', contentType);
        String actualValue = responseFromRequest.getBody();
        System.debug(responseFromRequest.getBody());
        String expectedValue = responseFromRequest.getBody();
        CommunitiesSelfRegController.getValueFromJson(responseFromRequest.getBody(), 'success');
        System.assertNotEquals('false', CommunitiesSelfRegController.getValueFromJson(responseFromRequest.getBody(), 'success'));
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals('OK', responseFromRequest.getStatus());
        System.assertEquals(200, responseFromRequest.getStatusCode());
        
        PageReference getRes = controller.verify();
        System.assertEquals(null, getRes);
        
        controller.email = 'apex-test@u-blox.com';
        controller.firstName = 'e';
        getRes = controller.verify();
        System.assertEquals(null, getRes);
        
        controller.firstName = 'FirstName';
        controller.communityNickname = 'df*';
        getRes = controller.verify();
        System.assertEquals(null, getRes);
        
        controller.communityNickname = 'apextest';
        getRes = controller.verify();        
        System.assertEquals(null, getRes);
        
        //insertedUser = [SELECT count() FROM User WHERE ProfileId =: profileId AND Email =: controller.email AND firstName = 'FirstName' AND communityNickname = 'apextest'];
        //System.debug('profileid:'+profileId+'Email:'+controller.email+'firstname:'+controller.firstName);
        //System.assertEquals(1, insertedUser);
        
        responseFromRequest.setBody('{"success": false,"challenge_ts": "2019-01-23T12:04:27Z","hostname": "uat-u-blox.cs100.force.com"}');
        //System.assertEquals('false', CommunitiesSelfRegController.getValueFromJson(responseFromRequest.getBody(), 'success'));

        Test.stopTest();
    }

    @isTest
    public static void testExceptions(){
        Test.startTest();
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        String uId;

        Account a = new Account(Name = 'Test Account Name');
        insert a;

        Contact c = new Contact(LastName = 'Contact Last Name', AccountId = a.id);
        insert c;

        Id profileId =  [Select Id from Profile where Name = 'Community Registered User' limit 1].Id;
        //String profileId = [SELECT Id FROM User WHERE Profile.Name = 'Community Registered User' LIMIT 1].Id;

        User user = new User(LastName='TestUser',
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

        String password = '123abc';
        try{
            uId = Site.createExternalUser(user, a.Id, password);
        }catch (Site.ExternalUserCreateException ex){
            System.assertEquals(null, uId);

        }     
        //insert user;
        controller.verify();
        

        Test.stopTest();

    }

    global class GoogleHTTPCalloutMock implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"success": true,"challenge_ts": "2019-01-23T12:04:27Z","hostname": "uat-u-blox.cs100.force.com"}');
            res.setStatus('OK');
            res.setStatusCode(200);
            return res;
        }
    }


}
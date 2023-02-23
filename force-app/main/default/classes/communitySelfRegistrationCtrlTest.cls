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
@IsTest
global class communitySelfRegistrationCtrlTest {
    @testSetup static void setup() {
        
        Account a = new Account(Name='Registered Community Users',BillingCountry = 'GB');
        insert a;
        
        Contact c = new Contact(LastName='Test User', AccountId=a.Id);
        insert c;   
        
        Id profileId =  [Select Id from Profile where Name = 'Community Registered User' limit 1].Id;
            
        User u = new User(LastName='TestUser',
                          Alias='testAlia',
                          Email='apex-test@u-blox.com',
                          Username='apex-test003@u-blox.com',
                          CommunityNickname='apex.test003',
                          ContactId=c.Id,
                          ProfileId=profileId,
                          TimeZoneSidKey='America/New_York',
                          LocaleSidKey='en_Us',
                          EmailEncodingKey='ISO-8859-1',
                          LanguageLocaleKey='en_US');
        insert u;

        self_reg__c srd = new self_reg__c();
        srd.Name = 'Self Registration Data';
        srd.base_URL__c = 'https://www.recaptcha.net/recaptcha/api/siteverify';
        srd.secret__c = '6Ld8Gc4UAAAAAEKt4d70oDyt5bFzQgnBtAaL4nhd';
        srd.site_key__c = '6Ld8Gc4UAAAAABNR82HuoD_r2zThMdMQT9gpos0w';
        srd.registration_landing_page__c = '/s/reglandingpage';
        insert srd;

    }

    static testMethod void testUserVerification() {

        self_reg__c srd = self_reg__c.getAll().values();        
        String siteKey = srd.site_key__c;
        String baseUrl = srd.base_URL__c;
        String secret = srd.secret__c;
       
        string captchaResponse = '03AGdBq24tb6qXo66U6i6wZ1OmS5rk6TEHf1nefLz-OYGz8cbQ-JH37L3XbVs0z897re_SJsBf4_knOfZrmg2-yzmw1xNHit56pKi-EpAb6JCxlBxtU0j5pwYfOOW1wA1GaX1t0omuh1dt6g0ztdw6iiVb-6eKVw_ghX63RZhBPGaAqfGCL_twPHgvF3gXV1s66cFSMf98EutZVkSlFojatd_wFKVOL3-GjWEno1Z3uqM3RyGEfaBMqGZvdpDWJzGsbYSNbwCEtATchyC34o8vTMu5NJuFdnKTWvxsBD6VqudqFn9zVsTfJR50uAn7RYEWiibSOp1scRoeccbtu-YT8-ckDN33nLj73kKdxeZhzWzCI5NHvR82H14PLP5-yEaHscLFDEKWJAkOrV7qcl1elY_Ly_ouKREgC4VhfS2C46pDErOEZVdLacGbJRCHld4RwS1P3jayhcJFwMvT_TVNLt9XPql_s2_fkxRCVnSv17osIvpwlDyQ7ps';
        
        Test.setMock(HttpCalloutMock.class, new communitySelfRegistrationCtrlTest.GoogleHTTPCalloutMock());      
              
        communitySelfRegistrationCtrl.verifyUser('FirstName','LastName','test_cu@u-blox.com','','','',true,false);       
    }

    static testMethod void NameException() {

        self_reg__c srd = self_reg__c.getAll().values();        
        String siteKey = srd.site_key__c;
        String baseUrl = srd.base_URL__c;
        String secret = srd.secret__c;
       
        string captchaResponse = '03AGdBq24tb6qXo66U6i6wZ1OmS5rk6TEHf1nefLz-OYGz8cbQ-JH37L3XbVs0z897re_SJsBf4_knOfZrmg2-yzmw1xNHit56pKi-EpAb6JCxlBxtU0j5pwYfOOW1wA1GaX1t0omuh1dt6g0ztdw6iiVb-6eKVw_ghX63RZhBPGaAqfGCL_twPHgvF3gXV1s66cFSMf98EutZVkSlFojatd_wFKVOL3-GjWEno1Z3uqM3RyGEfaBMqGZvdpDWJzGsbYSNbwCEtATchyC34o8vTMu5NJuFdnKTWvxsBD6VqudqFn9zVsTfJR50uAn7RYEWiibSOp1scRoeccbtu-YT8-ckDN33nLj73kKdxeZhzWzCI5NHvR82H14PLP5-yEaHscLFDEKWJAkOrV7qcl1elY_Ly_ouKREgC4VhfS2C46pDErOEZVdLacGbJRCHld4RwS1P3jayhcJFwMvT_TVNLt9XPql_s2_fkxRCVnSv17osIvpwlDyQ7ps';
        
        Test.setMock(HttpCalloutMock.class, new communitySelfRegistrationCtrlTest.GoogleHTTPCalloutMock());      
        try{
            communitySelfRegistrationCtrl.verifyUser('','LastName','test_cu@u-blox.com','','','',true,false);
        }catch(Exception ex){}      
               
    }

    static testMethod void emailException() {

        self_reg__c srd = self_reg__c.getAll().values();        
        String siteKey = srd.site_key__c;
        String baseUrl = srd.base_URL__c;
        String secret = srd.secret__c;
       
        string captchaResponse = '03AGdBq24tb6qXo66U6i6wZ1OmS5rk6TEHf1nefLz-OYGz8cbQ-JH37L3XbVs0z897re_SJsBf4_knOfZrmg2-yzmw1xNHit56pKi-EpAb6JCxlBxtU0j5pwYfOOW1wA1GaX1t0omuh1dt6g0ztdw6iiVb-6eKVw_ghX63RZhBPGaAqfGCL_twPHgvF3gXV1s66cFSMf98EutZVkSlFojatd_wFKVOL3-GjWEno1Z3uqM3RyGEfaBMqGZvdpDWJzGsbYSNbwCEtATchyC34o8vTMu5NJuFdnKTWvxsBD6VqudqFn9zVsTfJR50uAn7RYEWiibSOp1scRoeccbtu-YT8-ckDN33nLj73kKdxeZhzWzCI5NHvR82H14PLP5-yEaHscLFDEKWJAkOrV7qcl1elY_Ly_ouKREgC4VhfS2C46pDErOEZVdLacGbJRCHld4RwS1P3jayhcJFwMvT_TVNLt9XPql_s2_fkxRCVnSv17osIvpwlDyQ7ps';
        
        Test.setMock(HttpCalloutMock.class, new communitySelfRegistrationCtrlTest.GoogleHTTPCalloutMock());      
        try{
            communitySelfRegistrationCtrl.verifyUser('FirstName','LastName','','','','',true,false);
        }catch(Exception ex){}     
               
    }

    static testMethod void certificateException() {

        self_reg__c srd = self_reg__c.getAll().values();        
        String siteKey = srd.site_key__c;
        String baseUrl = srd.base_URL__c;
        String secret = srd.secret__c;
       
        string captchaResponse = '03AGdBq24tb6qXo66U6i6wZ1OmS5rk6TEHf1nefLz-OYGz8cbQ-JH37L3XbVs0z897re_SJsBf4_knOfZrmg2-yzmw1xNHit56pKi-EpAb6JCxlBxtU0j5pwYfOOW1wA1GaX1t0omuh1dt6g0ztdw6iiVb-6eKVw_ghX63RZhBPGaAqfGCL_twPHgvF3gXV1s66cFSMf98EutZVkSlFojatd_wFKVOL3-GjWEno1Z3uqM3RyGEfaBMqGZvdpDWJzGsbYSNbwCEtATchyC34o8vTMu5NJuFdnKTWvxsBD6VqudqFn9zVsTfJR50uAn7RYEWiibSOp1scRoeccbtu-YT8-ckDN33nLj73kKdxeZhzWzCI5NHvR82H14PLP5-yEaHscLFDEKWJAkOrV7qcl1elY_Ly_ouKREgC4VhfS2C46pDErOEZVdLacGbJRCHld4RwS1P3jayhcJFwMvT_TVNLt9XPql_s2_fkxRCVnSv17osIvpwlDyQ7ps';
        
        Test.setMock(HttpCalloutMock.class, new communitySelfRegistrationCtrlTest.GoogleHTTPCalloutMock());      
        try{
            communitySelfRegistrationCtrl.verifyUser('FirstName','LastName','test_cu@u-blox.com','','','',false,false);
        }catch(Exception ex){}      
               
    }

    static testMethod void recapchaException() {

        self_reg__c srd = self_reg__c.getAll().values();        
        String siteKey = srd.site_key__c;
        String baseUrl = srd.base_URL__c;
        String secret = srd.secret__c;
       
        string captchaResponse = null;
        
        Test.setMock(HttpCalloutMock.class, new communitySelfRegistrationCtrlTest.GoogleHTTPCalloutMock());      
        try{
            communitySelfRegistrationCtrl.verifyUser('FirstName','LastName','test_cu@u-blox.com','','','',false,false);
        }catch(Exception ex){}      
               
    }

    static testMethod void duplicateUserException() {

        self_reg__c srd = self_reg__c.getAll().values();        
        String siteKey = srd.site_key__c;
        String baseUrl = srd.base_URL__c;
        String secret = srd.secret__c;
       
        string captchaResponse = '03AGdBq24tb6qXo66U6i6wZ1OmS5rk6TEHf1nefLz-OYGz8cbQ-JH37L3XbVs0z897re_SJsBf4_knOfZrmg2-yzmw1xNHit56pKi-EpAb6JCxlBxtU0j5pwYfOOW1wA1GaX1t0omuh1dt6g0ztdw6iiVb-6eKVw_ghX63RZhBPGaAqfGCL_twPHgvF3gXV1s66cFSMf98EutZVkSlFojatd_wFKVOL3-GjWEno1Z3uqM3RyGEfaBMqGZvdpDWJzGsbYSNbwCEtATchyC34o8vTMu5NJuFdnKTWvxsBD6VqudqFn9zVsTfJR50uAn7RYEWiibSOp1scRoeccbtu-YT8-ckDN33nLj73kKdxeZhzWzCI5NHvR82H14PLP5-yEaHscLFDEKWJAkOrV7qcl1elY_Ly_ouKREgC4VhfS2C46pDErOEZVdLacGbJRCHld4RwS1P3jayhcJFwMvT_TVNLt9XPql_s2_fkxRCVnSv17osIvpwlDyQ7ps';
        
        Test.setMock(HttpCalloutMock.class, new communitySelfRegistrationCtrlTest.GoogleHTTPCalloutMock());      
        try{
            communitySelfRegistrationCtrl.verifyUser('FirstName','LastName','test_cu@u-blox.com','','','',true,false);
            communitySelfRegistrationCtrl.verifyUser('FirstName','LastName','test_cu@u-blox.com','','','',true,false);
        }catch(Exception ex){}      
               
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
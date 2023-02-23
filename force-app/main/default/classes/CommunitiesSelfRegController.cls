/*

  An apex page controller that supports self registration of users in communities that allow self registration
*/


public without sharing class CommunitiesSelfRegController {

    public String firstName { get; set {firstName = value == null ? value : value.trim();} }
    public String lastName { get; set {lastName = value == null ? value : value.trim();} }
    public String email { get; set {email = value == null ? value : value.trim();} }
    //public Boolean Consent_For_Receiving_Marketing_Content {get; set; }
    public String password { get; set {password = value == null ? value : value.trim();} }
    public String confirmPassword { get; set {confirmPassword = value == null ? value : value.trim();} }
    public String communityNickname { get; set {communityNickname = value == null ? value : value.trim();} }
    public boolean marketingConcent {get; set;}{
        marketingConcent = false;
    }
    public Boolean showInfo { get; private set; }
    public String projectInfo { get; set {projectInfo = value == null ? value : value.trim();} }
    public String accountInfo { get; set {accountInfo = value == null ? value : value.trim();} }
    public String userOrigin {get;set;}

    private static self_reg__c sr {
        get {
            return self_reg__c.getall().values();
        }
        set;
    }
    public Boolean verified { get; private set; }
    public User aux{
        get{
            User u = [SELECT Id, Incremental_Number__c, Profile.Id FROM User
            WHERE Incremental_Number__c!=NULL AND Profile.Name='Community Registered User'
            ORDER BY CreatedDate DESC LIMIT 1];
            return u;
        } set;
    }


    public CommunitiesSelfRegController() {
        this.verified = false;
        this.showInfo = false;
        this.verified = false;
        this.userOrigin= null;
        String showInfoParam ='';
        System.PageReference cPage =  ApexPages.currentPage();
        if(cPage!=null){
            String refererUrl = cPage.getHeaders()!=null ? cPage.getHeaders().get('Referer'):null;
            if(!String.isEmpty(refererUrl)){
                PageReference pRefUrl = new PageReference(refererUrl);
                this.userOrigin = pRefUrl.getParameters().get('UserSource');
                        
                String showInfoVal = cPage.getParameters().get('si');
                if(String.isEmpty(showInfoVal))
                {
                    showInfoParam = pRefUrl.getParameters().get('si');                               
                }else
                {
                    showInfoParam = showInfoVal;
                }
            }    
            if((!String.isEmpty(showInfoParam)) && showInfoParam == '1')
                this.showInfo = true;
            
            String expid = ApexPages.currentPage().getParameters().get('expid');
            if (expId != null) {
                Site.setExperienceId(expId);
            }
        }
    }

    private static String baseUrl = sr.base_URL__c;
    private static String secret = sr.secret__c;

    public String sitekey {
        get {
            return sr.site_key__c;
        }
    }
    @TestVisible
    public String response {
        get {
            return ApexPages.currentPage().getParameters().get('g-recaptcha-response');
        }
    }

    @TestVisible
    public PageReference verify() {
        System.debug('reCAPTCHA verification attempt');
        if (response == null) {
            System.debug('reCAPTCHA verification attempt with empty form');
            return null;
        }

        HttpResponse http_response = makeRequest(baseUrl, 'secret=' + secret + '&response=' + response + '&remoteip=' + remoteHost);
        String responseBody = http_response.getBody();
        String success = getValueFromJson(responseBody, 'success');
               
        if (success.equalsIgnoreCase('true')) {

            String profileId = [SELECT Id FROM Profile WHERE Name='Community Registered User'].Id;
            String roleEnum = null;

            String accountId = [SELECT Id FROM Account WHERE Name='Registered Community Users'].Id;

            String userName = email;
            Integer IncNum = Integer.valueOf(aux.Incremental_Number__c)+1;
            System.debug('aux: '+aux.Profile.Id+' '+aux.Incremental_Number__c);

            String newUserNickname = communityNickname;

            if(!Pattern.matches('^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}$', email)) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ' Please type a valid email.');
                ApexPages.addMessage(errorMsg);
                return null;
            }

            if(firstName.length()<2 || lastName.length()<2 || !Pattern.matches('^[A-Za-z]+$', firstName) || !Pattern.matches('^[A-Za-z]+$', lastName)) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Your first and last name must contain at least 2 characters (only letters).');
                ApexPages.addMessage(errorMsg);
                return null;
            }            

            if(communityNickname.length()<3 || !Pattern.matches('^[A-Za-z0-9._-]+$', communityNickname)) {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Your nickname must contain at least 3 characters (letters/numbers/./_/-).');
                ApexPages.addMessage(errorMsg);
                return null;
            }
            /*            
            User u = new User();
            u.Username = userName;
            u.Email = email;
            u.FirstName = firstName;
            u.LastName = lastName;
            u.CommunityNickname = communityNickname;
            u.Alias = 'cu'+IncNum;
            u.ProfileId = profileId;
            u.Origin__c = 'Customer Community';
            //u.Consent_For_Receiving_Marketing_Content__c = Consent_For_Receiving_Marketing_Content;
            */
            boolean optOutFlag = marketingConcent == true ? false : true;
            String userId;
            
            /*string userOrigin = URL.getCurrentRequestUrl().getQuery();           
            if(userOrigin != null && userOrigin.contains('webshop')){
                userOrigin = 'webshop';
            }else if(userOrigin != null && userOrigin.contains('website'))
            {
                userOrigin = 'website';
            }else
                userOrigin = null;
            */
            PageReference cPage = ApexPages.currentPage();
            if(this.userOrigin == null)
            {
                if(cPage.getParameters().get('UserSource')!=null)
                {
                    this.userOrigin = cPage.getParameters().get('UserSource');
                }
            }
            
            CommunityUserAPIClassHelper.CreateUserInput portalUserInput = new CommunityUserAPIClassHelper.CreateUserInput();
            portalUserInput.FirstName = firstName;
            portalUserInput.LastName = lastName;
            portalUserInput.Username = userName;      
            portalUserInput.Email = email;            
            portalUserInput.CommunityNickname = communityNickname;
            portalUserInput.TimeZoneSidKey = 'GMT';
            portalUserInput.UserSource = this.userOrigin;
            portalUserInput.MarketingCommunicationOptOut = optOutFlag;
            portalUserInput.AccountInfo = accountInfo;
            portalUserInput.ProjectInfo = projectInfo;
                                
            try {
                Contact conObj = CreateCommunityUserAPIHelper.createContact(portalUserInput);                             
                User createdUser = CreateCommunityUserAPIHelper.createUser(portalUserInput,conObj.id);
                Case createdCase = CreateCommunityUserAPIHelper.createCase(portalUserInput,createdUser.id,conObj.id);
                
                /*
                userId = Site.createExternalUser(u, accountId, password);
                list<Contact> newContact = [Select Id, 
                                                   Marketing_Communication_Opt_Out__c 
                                                   from Contact 
                                                   where Id IN (Select ContactId from User where Id =: userId) limit 1];                
                if(newContact.size() > 0){
                    newContact[0].Marketing_Communication_Opt_Out__c = optOutFlag;
                    database.update(newContact[0], false);
                }*/      
                
            } catch(exception ex) {
                String msg = 'Sorry, there was an error in the registration. Please try to register with another email or contact admin@u-blox.com.';
                /*
                if(ex.getMessage()=='[User already exists.]'){
                    msg = 'Sorry, user with this email already exists. Please choose another email.';
                }

                if(ex.getMessage()=='[That nickname already exists. Enter a unique nickname.]'){
                    msg = 'Sorry, your nickname already exists. Please choose another nickname.';
                }*/

                if(ex.getMessage().contains('DUPLICATE_USERNAME')){
                    msg = 'Sorry, user with this email already exists. Please choose another email.';
                }

                if(ex.getMessage().contains('DUPLICATE_COMM_NICKNAME')){
                    msg = 'Sorry, your nickname already exists. Please choose another nickname.';
                }
                
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ' '+msg);
                ApexPages.addMessage(errorMsg); 
                return null;
            }


            String PgLink = sr.registration_landing_page__c;
            PageReference page = new PageReference(PgLink);
            page.setRedirect(true);
            return page;

        } else {

            if(success.equalsIgnoreCase('false') ){
                // stay on page to re-try reCAPTCHA
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ' Please verify the captcha.');
                ApexPages.addMessage(errorMsg);
            }

            return null;
        }
    }


    public PageReference reset() {
        return null;
    }

    @TestVisible
    public static String getValueFromJson(String strJson, String field) {
        JSONParser parser = JSON.createParser(strJson);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                if (parser.getText() == field) {
                    parser.nextToken();
                    return parser.getText();
                }
            }
        }
        return null;
    }


    @TestVisible
    private static HttpResponse makeRequest(string url, string body) {

        HttpResponse response = null;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            response = http.send(req);
            System.debug('reCAPTCHA response: ' + response);
            System.debug('reCAPTCHA body: ' + response.getBody());
            return response;
        } catch (System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        System.debug('response:' + response);
        return response;
    }


    @TestVisible
    private String remoteHost {
        get {
            String ret = '127.0.0.1';
            // also could use x-original-remote-host
            Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
            if (hdrs.get('x-original-remote-addr') != null) {
                ret = hdrs.get('x-original-remote-addr');
            }
            else if (hdrs.get('X-Salesforce-SIP') != null) {
                ret = hdrs.get('X-Salesforce-SIP');
            }
            return ret;
        }
    }

    //reCAPTCHA implementation ends
    @TestVisible
    private boolean isValidPassword() {
        return password == confirmPassword;
    }


}
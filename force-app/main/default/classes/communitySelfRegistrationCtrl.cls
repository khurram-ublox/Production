global without sharing class communitySelfRegistrationCtrl {
    
    private static self_reg__c sr {
        get {
            return self_reg__c.getall().values();
        }
        set;
    }

    private static User aux{
        get{
            User u = [SELECT Id, Incremental_Number__c, Profile.Id FROM User
            WHERE Incremental_Number__c!=NULL AND Profile.Name='Community Registered User'
            ORDER BY CreatedDate DESC LIMIT 1];
            return u;
        } set;
    }
    
    private static String baseUrl = sr.base_URL__c;
    private static String secret = sr.secret__c;
       
    @AuraEnabled
    public static string verifyUser(string firstName, string lastName,string email,string accountInfo,string projectInfo,string userOrigin,boolean acceptanceCertificate,boolean marketingConcent){
    
        if(!isValidName(firstName, lastName)){
            AuraHandledException ex = new AuraHandledException('Your first and last name must contain at least 2 characters (only letters).');
            ex.setMessage('Your first and last name must contain at least 2 characters (only letters).');
            throw ex;            
        }

        if(!isValidEmail(email)){
            AuraHandledException ex = new AuraHandledException('Please type a valid email.');
            ex.setMessage('Please type a valid email.');
            throw ex;            
        }
        
        if(acceptanceCertificate == false) {            
            AuraHandledException ex = new AuraHandledException('Please Accept the Terms and Conditions');
            ex.setMessage('Please Accept the Terms and Conditions');
            throw ex;                        
        }
                               
        firstName = firstName == null ? firstName : firstName.trim(); 
        lastName = lastName == null ? lastName : lastName.trim(); 
        email = email == null ? email : email.trim();
        accountInfo = accountInfo == null ? accountInfo : accountInfo.trim();  
        projectInfo = projectInfo == null ? projectInfo : projectInfo.trim();  
        
        boolean optOutFlag = marketingConcent == true ? false : true;
        string inputNickName = CreateCommunityUserAPIHelper.createCommunityNickname(firstName,lastName,aux);
        
        CommunityUserAPIClassHelper.CreateUserInput portalUserInput = new CommunityUserAPIClassHelper.CreateUserInput();
        portalUserInput.FirstName = firstName;
        portalUserInput.LastName = lastName;
        portalUserInput.Username = email;      
        portalUserInput.Email = email;            
        portalUserInput.CommunityNickname = inputNickName;
        portalUserInput.TimeZoneSidKey = 'GMT';
        portalUserInput.UserSource = userOrigin;
        portalUserInput.MarketingCommunicationOptOut = optOutFlag;
        portalUserInput.AccountInfo = accountInfo;
        portalUserInput.ProjectInfo = projectInfo;
                                
        try {
            Contact conObj = CreateCommunityUserAPIHelper.createContact(portalUserInput);                             
            User createdUser = CreateCommunityUserAPIHelper.createUser(portalUserInput,conObj.id);
            Case createdCase = CreateCommunityUserAPIHelper.createCase(portalUserInput,createdUser.id,conObj.id);
        }catch(Exception ex) {
            String msg = 'Sorry, there was an error in the registration. Please try to register with another email or contact admin@u-blox.com.';
    
            if(ex.getMessage().contains('DUPLICATE_USERNAME')){
                msg = 'Sorry, user with this email already exists. Please choose another email.';
            }

            if(ex.getMessage().contains('DUPLICATE_COMM_NICKNAME')){
                msg = 'Sorry, your nickname already exists. Please choose another nickname.';
            }               
            
            AuraHandledException exp = new AuraHandledException(msg);
            exp.setMessage(msg);
            throw exp;
        }
        String PgLink = sr.registration_landing_page__c;           
        return PgLink;               
    }

    private static boolean isValidEmail(string userEmail){
        if(!Pattern.matches('^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}$', userEmail)) {
            return false;         
        }
        return true;
    }

    private static boolean isValidName(string userFName, string userLName){
        if(userFName.length()<2 || userLName.length()<2 || !Pattern.matches('^[A-Za-z]+$', userFName) || !Pattern.matches('^[A-Za-z]+$', userLName)) {
            return false;
        }
        return true;
    }

    @AuraEnabled
    public static string reCaptchaRequest(string recaptchaResponse){        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(baseUrl);
        request.setMethod('POST');
        request.setBody('secret=' + secret + '&response=' + recaptchaResponse);
        
        if(!Test.isRunningTest()){
            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {                
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                
                if(result.containsKey('success') && result.get('success') == true) {
                    if (result.containsKey('score')) {                   
                        String action = (String)result.get('action');                    
                        Decimal threshold = .6;
                        Decimal score = (Decimal)result.get('score');
                        if(score > threshold) {                        
                            return 'Success';
                        }else return 'Invalid reCAPTCHA Verification';                                                   
                    }else return 'Invalid reCAPTCHA Verification';                    
                }else return 'Invalid reCAPTCHA Verification';
            }
            return 'Invalid Verification Request';
        }else return 'Success';          
    }
}
public class CreateCommunityUserAPIHelper {
    
    public static final String COMM_ACCOUNT_NAME = 'Registered Community Users';
    public static final String COMM_PROFILE_NAME = 'Community Registered User';
    public static final String COMM_USER_DEFAULT_ORIGIN = 'Customer Community';
	public static final String CASE_DEFAULT_RECORD_TYPE = 'Support Case';
    public static final String CASE_DEFAULT_TYPE = 'Authentication';
    public static final String CASE_DEFAULT_ORIGIN = 'web';
    
    public static final String LBL_DUP_USERNAME_ERROR = Label.SSO_duplicate_user_error;
    public static final String LBL_DUP_COMM_NICKNAME_ERROR = Label.SSO_duplicate_nickname_error;
    public static final String LBL_GENERAL_ERROR = Label.SSO_general_user_error;
    public static final String LBL_VALID_EMAIL_ERROR = Label.SSO_email_validation_error;
    public static final String LBL_VALID_NAME_ERROR = Label.SSO_contact_name_validation_error;
    public static final String LBL_VALID_COMM_NICKNAME_ERROR = Label.SSO_nickname_validation_error;
    
    public static CommunityUserAPIClassHelper.CreateUserResponse createCommunityUser(CommunityUserAPIClassHelper.CreateUserInput userInput)
    {
        CommunityUserAPIClassHelper.CreateUserResponse response = null;
        Contact conObj = null;
        User userObj = null;
        try{
            response = validateUserInput(userInput);
            if(response!=null)
            {
                return response;
            }
            conObj = CreateCommunityUserAPIHelper.createContact(userInput);
            
            if(conObj!=null && conObj.id!=null){
                userObj = CreateCommunityUserAPIHelper.createUser(userInput,conObj.id);
                if(userObj!=null){
                    response = new CommunityUserAPIClassHelper.CreateUserResponse();
                    response.isSuccess = true;
                    response.userRecord = userObj;
                }else {
                    delete conObj;
                    response = CommunityUserAPIClassHelper.getErrorResponse(LBL_GENERAL_ERROR,'EC-10');
                }
            }else {
                response = CommunityUserAPIClassHelper.getErrorResponse(LBL_GENERAL_ERROR,'EC-11');
            }
        }catch(exception ex)
        {
            try{
                if(conObj!=null && conObj.id!=null)
                    delete conObj;
            }catch(Exception exc)
            {
                response = CommunityUserAPIClassHelper.getErrorResponse(LBL_GENERAL_ERROR,'EC-12');
            }            
            
            if(ex.getMessage().contains('DUPLICATE_USERNAME')){
                response = CommunityUserAPIClassHelper.getErrorResponse(LBL_DUP_USERNAME_ERROR,'EC-4');
                return response;
            }

            if(ex.getMessage().contains('DUPLICATE_COMM_NICKNAME')){
                response = CommunityUserAPIClassHelper.getErrorResponse(LBL_DUP_COMM_NICKNAME_ERROR ,'EC-5');
                return response;
            }           
            response = CommunityUserAPIClassHelper.getErrorResponse(LBL_GENERAL_ERROR+ex.getMessage()+ex.getStackTraceString()+ex.getLineNumber(),'EC-10');
        }
        return response;
    }
    public static Contact createContact(CommunityUserAPIClassHelper.CreateUserInput userInput)
    {
        String accountId = [SELECT Id FROM Account WHERE Name=:COMM_ACCOUNT_NAME].Id;
        list<Contact> dupContacts = [SELECT Id,Marketing_Communication_Opt_Out__c FROM Contact WHERE Email=:userInput.Email];
        Contact contactObj = new Contact();
        If(dupContacts.size() == 0 || dupContacts.size() > 1){
            contactObj = new Contact(
                FirstName = userInput.FirstName,
                Lastname = userInput.LastName,
                AccountId = accountId,
                Email = userInput.Email,
                Marketing_Communication_Opt_Out__c = userInput.MarketingCommunicationOptOut
            );
            insert contactObj;
        }else {
            contactObj = dupContacts[0];
            contactObj.Marketing_Communication_Opt_Out__c = userInput.MarketingCommunicationOptOut;
            database.update(contactObj, false);

        } 
        return contactObj; 
    }
    
    public static CommunityUserAPIClassHelper.CreateUserResponse validateUserInput(CommunityUserAPIClassHelper.CreateUserInput userInput)
    {
        CommunityUserAPIClassHelper.CreateUserResponse response = null;
        if(String.isBlank(userInput.Email) || !Pattern.matches('^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}$', userInput.Email)) {
            response = CommunityUserAPIClassHelper.getErrorResponse(LBL_VALID_EMAIL_ERROR, 'EC-1');
            return response;
        }

        if(String.isBlank(userInput.FirstName) || String.isBlank(userInput.LastName) ||
           (userInput.FirstName.length()<2 || userInput.LastName.length()<2 || 
            !Pattern.matches('^[A-Za-z]+$', userInput.FirstName) || 
            !Pattern.matches('^[A-Za-z]+$', userInput.LastName))) {
            response = CommunityUserAPIClassHelper.getErrorResponse(LBL_VALID_NAME_ERROR, 'EC-2');
            return response;
        }            

        if(String.isBlank(userInput.CommunityNickname) || (userInput.CommunityNickname.length()<3 
                                                           ||!Pattern.matches('^[A-Za-z0-9._-]+$', userInput.CommunityNickname))) {
            response = CommunityUserAPIClassHelper.getErrorResponse(LBL_VALID_COMM_NICKNAME_ERROR, 'EC-3');
            return response;
        }
        
        return response;
    }
    
    public static User createUser(communityUserAPIClassHelper.CreateUserInput userInput,String contactId)
    {
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name=:COMM_PROFILE_NAME Limit 1];
        list<User> uAux = [SELECT Id, Incremental_Number__c, Profile.Id FROM User
            WHERE Incremental_Number__c!=NULL AND Profile.Name=:COMM_PROFILE_NAME
            ORDER BY CreatedDate DESC LIMIT 1];
        Integer IncNum = 1;
        if(uAux.size() > 0){
            IncNum = Integer.valueOf(uAux[0].Incremental_Number__c)+1;
        }
              
        User userObj = new User(
                    UserName = userInput.Username,
                    FirstName = userInput.FirstName,
                    LastName = userInput.LastName,
                    Alias = 'cu'+IncNum,
                    email = userInput.Email,
                    ContactId = contactId,
                    ProfileId = portalProfile.Id,
                    EmailEncodingKey = 'UTF-8',
                    CommunityNickname = userInput.CommunityNickname,
                    TimeZoneSidKey = String.isBlank(userInput.TimeZoneSidKey)? 'America/Los_Angeles' : userInput.TimeZoneSidKey,
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US',
                    Origin__c = String.isBlank(userInput.UserSource)? COMM_USER_DEFAULT_ORIGIN :userInput.UserSource,
                    System_Redirect_Required__c = String.isBlank(userInput.UserSource)? false : true
        );
        
        insert userObj;
        return userObj; 
    }   
    public static Case createCase(CommunityUserAPIClassHelper.CreateUserInput userInput,String userId,String cId)
    {
        if(!String.isEmpty(userInput.AccountInfo)){
            String caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(CASE_DEFAULT_RECORD_TYPE).getRecordTypeId();
            String subject = Label.Case_Subject+' '+userInput.Email;
            String detailDesc= Label.Detail_Description;
            String descStr = getStringFromUserInput(userInput);
            Case newCase = new Case(
                subject = subject,
                Description = descStr,
                IsVisibleInSelfService = true,            
                Type = CASE_DEFAULT_TYPE,
                recordTypeId = caseRecordTypeId,
                Detailed_Description__c = detailDesc,
                Origin = CASE_DEFAULT_ORIGIN,
                ContactId = cId,
				Case_Initiator_Source__c = userId                
            );        
            insert newCase;
            return newCase;
        }else{
            return null;
        }
    } 
    
    private static String getStringFromUserInput(CommunityUserAPIClassHelper.CreateUserInput userInput)
    {
        String userInputString = '';
        userInputString+='FirstName : '+userInput.FirstName;
        userInputString+='\n LastName : '+userInput.LastName;
        userInputString+='\n Username : '+userInput.Username;
        userInputString+='\n Email : '+userInput.Email;
        userInputString+='\n CommunityNickname : '+userInput.CommunityNickname;
        userInputString+='\n MarketingCommunicationOptOut : '+userInput.MarketingCommunicationOptOut;
        userInputString+='\n AccountInfo : '+userInput.AccountInfo;
        userInputString+='\n ProjectInfo : '+userInput.ProjectInfo;
        return userInputString;
    }

    public static string createCommunityNickname(string firstName, String lastName, User userinfo) {
        if(lastName != null && lastName.length()>2){
            lastName = lastName.substring(0,3);
        }
        string nickName = 'cu_' + firstName.substring(0,1) + lastName + userinfo.Incremental_Number__c;
        

        return nickName.toLowerCase();
    }
}
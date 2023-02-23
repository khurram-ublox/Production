global class CommunityUserAPIClassHelper{
    global class CreateUserResponse{
        public boolean isSuccess {get;set;}        
        public String errorMsg {get;set;}
        public String code {get;set;}       
        public sObject userRecord {get;set;}
    }

    global class CreateUserInput{
        public String FirstName {get;set;}
        public String LastName {get;set;}
        public String Username {get;set;}        
        public String Email {get;set;}
        public String Alias {get;set;}
        public String CommunityNickname {get;set;}
        public String TimeZoneSidKey {get;set;} //'America/Los_Angeles'
        public String LocaleSidKey {get;set;} //'en_US'
        public String LanguageLocaleKey {get;set;} //'en_US'
        public String UserSource {get;set;}
        public boolean MarketingCommunicationOptOut    {get; set;} //Marketing Concent from end user
        public String AccountInfo {get;set;}
        public String ProjectInfo {get;set;}
    }
    
    static public CreateUserResponse getErrorResponse(String errorMessage,String errCode)
    {   
        CreateUserResponse cUserResp = new CreateUserResponse();
        cUserResp.isSuccess = false;
        cUserResp.code = errCode;
        cUserResp.errorMsg = errorMessage; 
        return cUserResp;    
    }
}
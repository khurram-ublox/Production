public class userFileComponentHelper {
	@AuraEnabled
    static public UFileAddResponse addUserFile(String contactId)
    {
        UFileAddResponse respObj = null;
        if(!String.isEmpty(contactId)){
            User_File__c userFileObj = UserFileObjectHelper.isUserFilePresent(contactId); 
            
            if(userFileObj==null)
            {
               User uObj = UserFileObjectHelper.getUserForContact(contactId); 
               if(uObj!=null)
               {
                   User_File__c createdUFile = UserFileObjectHelper.createUserFile(uObj);  
                   respObj = createResponse(createdUFile.id,'Success',Label.UserFileCreation) ;     
               }else
               {
                   respObj = createResponse('','Error',Label.NotACommunityUserContact); 
               }       
            }
            else{
                 respObj = createResponse(userFileObj.id,'Success',Label.UserFilePresentMessage) ; 
            }     
        }
        return respObj; 
    }
    
    @AuraEnabled
    static public User_File__c getUserFileForLoggedInUser()
    {
        string userId = UserInfo.getUserId();
        User userObj = [select id,FirstName,LastName,contactId from User where id =: userId ];        
        return UserFileObjectHelper.isUserFilePresent(userObj.contactId);
    }
	
	static UFileAddResponse createResponse(String uFileId,String status,String message)
    {
        UFileAddResponse uResponse = new UFileAddResponse();
        uResponse.uFileId = uFileId;
        uResponse.status = status;
        uResponse.message = message;
        return uResponse;        
    }
    
    public class UFileAddResponse
    {
        @AuraEnabled
        public string uFileId {get;set;}
        @AuraEnabled
        public string status {get;set;}
        @AuraEnabled
        public string message {get;set;}
    }
}
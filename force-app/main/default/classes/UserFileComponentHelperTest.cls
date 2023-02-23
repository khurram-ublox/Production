@isTest
class UserFileComponentHelperTest{
    @isTest
    public static void addUserFileTest(){
        User commUser = DocumentLibCommonTest.createCommunityUser();
        Test.startTest();
        userFileComponentHelper.addUserFile(commUser.contactId);
        Test.stopTest();
    }
    
    @isTest
    public static void getUserFileForLoggedInUserTest(){
        User commUser = DocumentLibCommonTest.createCommunityUser();
        
        User_File__c uFile = DocumentLibCommonTest.createUserFile(commUser.contactId,commUser.Id);
        
        Test.startTest();
        System.runAs(commUser){
            userFileComponentHelper.getUserFileForLoggedInUser();
        }
        Test.stopTest();
    }
    
    @isTest
    public static void getUserFileForLoggedInUserWOTest(){
        User commUser = DocumentLibCommonTest.createCommunityUser();                
        User_File__c uFile = DocumentLibCommonTest.createUserFile(commUser.contactId,commUser.Id);
        userFileComponentHelper.addUserFile(commUser.contactId);        
    }
    
    @isTest
    public static void getUserFileForContactTest(){
        User commUser = DocumentLibCommonTest.createCommunityUser(); 
        
        Account acc = DocumentLibCommonTest.createAccountWithOwner(UserInfo.getUserId());
        Contact con = DocumentLibCommonTest.createContact(acc.Id) ;
        Test.startTest();
        
        userFileComponentHelper.addUserFile(con.Id);
        Test.stopTest();
    }
    

}
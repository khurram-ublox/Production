@isTest
public class CommunityUserAPIClassHelperTest {

    @testSetup static void setup(){
        Account accObj = new Account(Name='Registered Community Users');
        //insert accObj;
    }
    
    @isTest
    public static void CreateUserResponseTest(){
        Account accObj = new Account(Name='Registered Community Users');
        insert accObj;

        CommunityUserAPIClassHelper.CreateUserInput userInputObj  = new CommunityUserAPIClassHelper.CreateUserInput();
        userInputObj.FirstName = 'Test First';
        //When I put the last name as 'Test Last, it was failing and it shouldn't be failing.
        userInputObj.LastName = 'Test Last';
        
       // userInputObj.Source = 'Webform';
        userInputObj.Email = 'tes@example.com';
        userInputObj.CommunityNickname = 'testNickName';
        userInputObj.LanguageLocaleKey = 'en_US';
        userInputObj.Username = 'testUser@example.com';
        userInputObj.Alias = 'testAlias';
        //'en_US'
        //LocaleSidKey {get;set;} //'en_US'
        //public String LanguageLocaleKey {get;set;
        //userInputObj.LanguageLocaleKey = 'en_US';
        
        CreateCommunityUserAPIHelper.createCommunityUser(userInputObj);
        
        CreateCommunityUserAPI.createCommunityUserPOST(userInputObj);
            /*
             * global static CommunityUserAPIClassHelper.CreateUserResponse createCommunityUserPOST(CommunityUserAPIClassHelper.CreateUserInput userInput) {
        CommunityUserAPIClassHelper.CreateUserResponse response = CreateCommunityUserAPIHelper.createCommunityUser(userInput);
        return response;
    }
*/
        system.debug('email validate-->>'+ CreateCommunityUserAPIHelper.validateUserInput(userInputObj));
    }
    
    @isTest
    public static void CreateUserErrorResponse(){
        //Account accObj = [Select id from Account where name = 'Registered Community Users'];
        //delete accObj;
        
        CommunityUserAPIClassHelper.CreateUserInput userInputObj  = new CommunityUserAPIClassHelper.CreateUserInput();
        userInputObj.FirstName = 'TestFirst';
        //When I put the last name as 'Test Last, it was failing and it shouldn't be failing.
        userInputObj.LastName = 'TestLast';        
       // userInputObj.Source = 'Webform';
        userInputObj.Email = 'tes@example.com';
        userInputObj.CommunityNickname = 'testNickName';
        userInputObj.LanguageLocaleKey = 'en_US';
        userInputObj.Username = 'testUser@example.com';
        userInputObj.Alias = 'testAlias';
        //'en_US'
        //LocaleSidKey {get;set;} //'en_US'
        //public String LanguageLocaleKey {get;set;
        //userInputObj.LanguageLocaleKey = 'en_US';
        
        CreateCommunityUserAPIHelper.createCommunityUser(userInputObj);
        
        
        system.debug('email validate-->>'+ CreateCommunityUserAPIHelper.validateUserInput(userInputObj));
    }
}



/*
 * @isTest
public class createUserForCommunityAPITest {
    
    @isTest
    public static void testPostCallout(){    
        createUserForCommunityAPI.CreateUserInput userInputObj = new createUserForCommunityAPI.CreateUserInput();
        userInputObj.FirstName = 'firstName';
        userInputObj.LastName = 'lastName';
        userInputObj.Email='firstNamelastName@example.com';
        //userInputObj.UserName = 'firstNamelastName@example.com';
        //userInputObj.Psd = 'tempPassword.88!';
        createUserForCommunityAPI.CreateUserResponse responseObj = new createUserForCommunityAPI.CreateUserResponse();
        
        
        
        system.debug(createUserForCommunityAPI.createCommunityUserPOST(userInputObj));
        responseObj = createUserForCommunityAPI.createCommunityUserPOST(userInputObj);
        
    }
}
*/
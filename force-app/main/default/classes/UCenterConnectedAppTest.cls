@IsTest
public class UCenterConnectedAppTest {

    @isTest
    public static void customAttributesTest(){
        Map<String,String> mapstr = new Map<String,String>();
        
        user userObj = portalUser('example','user');
        system.runAs(userObj){
            
            Test.startTest();
            UCenterConnectedApp  cap = new UCenterConnectedApp ();
            Id userId = userObj.Id;
            Id testId;
            Map<String,String> respMapStr = cap.customAttributes(userId,testId,mapstr,Auth.InvocationContext.SAML_ASSERTION);
            Test.stopTest();
        }
        
    }
    public static user portalUser(String fName, String lName){
      
        user userObj = new User();
        Account acc = new Account (
            Name = 'newAcc1'
        );  
        insert acc;
        
        Contact con = new Contact (
            AccountId = acc.id,
            LastName = 'portalTestUser'
        );
        insert con;
        String userType = 'CspLitePortal';
        
        Profile p = [select Id,name from Profile where UserType = :userType limit 1];
        
        User newUser = new User(
            profileId = p.id,
            username = 'newUser@example.com',
            email = 'pb@ff.com',
            emailencodingkey = 'UTF-8',
            localesidkey = 'en_US',
            languagelocalekey = 'en_US',
            timezonesidkey = 'America/Los_Angeles',
            alias='nuser',
            lastname=lName,
            contactId = con.id
        );
        insert newUser;
        
        return newUser;
    }
}
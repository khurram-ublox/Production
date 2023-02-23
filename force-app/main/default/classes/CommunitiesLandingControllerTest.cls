/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
@IsTest public with sharing class CommunitiesLandingControllerTest {
    static final Account communityAccount;
    static final Contact communityContact;
    static final User communityUser;
    static final list<externalPortalsMap__c> externalPortals = new list<externalPortalsMap__c>{
        new externalPortalsMap__c(Name='webshop', value__c='https://wwwdev.u-blox.com')
    };
    
    static{
        database.insert(externalPortals,false);
        
        communityAccount = new Account(
            Name = 'Registered Community Users'
        );
        database.insert(communityAccount);
        
        communityContact = new Contact(
            FirstName = 'Riccardo',
            LastName = 'Corsini',
            Email = 'riccardo.corsini@mailinator.com',
            AccountId = communityAccount.Id
        );
        database.insert(communityContact);
        
        Profile uProfile = [Select Id From Profile where Name = 'Community Registered User' limit 1];
        communityUser = new User(                             
                             ContactId = communityContact.Id,
                             LastName = communityContact.LastName,
                             FirstName = communityContact.FirstName,
                             Email = communityContact.Email,
                             UserName = communityContact.Email,
                             CommunityNickname = 'rcni',
                             Alias = 'rcni'+integer.valueof((Math.random() * 1000)),
                             Origin__c = 'webshop',
                             System_Redirect_Required__c = true,
                             ProfileId = uProfile.Id,
                             EmailEncodingKey='UTF-8',                              
                             LanguageLocaleKey = 'en_US', 
                             LocaleSidKey = 'en_US',                             
                             TimeZoneSidKey = 'America/Los_Angeles' 
                        );
        
        database.insert(communityUser,false);
        
    }
    
    static testMethod void testExternalSystemRedirectionAsCommunityUser() {
        // TO DO: implement unit test        
        System.RunAs(communityUser){
            CommunitiesLandingController controller = new CommunitiesLandingController();
            PageReference pageRef = controller.forwardToStartPage();
            if(pageRef != null){
                String url = pageRef.getUrl();                
                System.assertEquals(externalPortalsMap__c.getAll().get(communityUser.Origin__c).value__c, url);
            }
        }       
    }
    
    @IsTest(SeeAllData=true) public static void testCommunitiesLandingController() {
        // Instantiate a new controller with all parameters in the page
        CommunitiesLandingController controller = new CommunitiesLandingController();
        PageReference pageRef = controller.forwardToStartPage();
        //PageRef is either null or an empty object in test context
        if(pageRef != null){
            String url = pageRef.getUrl();
            if(url != null){
                System.assertEquals(true, String.isEmpty(url));
                //show up in perforce
            }
        }
    }
}
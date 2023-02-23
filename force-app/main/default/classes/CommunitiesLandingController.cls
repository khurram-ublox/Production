/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public without sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {      
        
        User uInfo = [Select Id, System_Redirect_Required__c, Origin__c from User where Id =: userinfo.getUserId()];
        
        /* check if user signup from outside the commmunity then redirected back to that location otherwise to community home*/        
        if(uInfo.System_Redirect_Required__c){
            uInfo.System_Redirect_Required__c = false;
            database.update(uInfo, false);
            string externalUrl = externalPortalsMap__c.getAll().get(uInfo.Origin__c).value__c; 
            PageReference pr = new PageReference(externalUrl);            
            return pr;
        }else return Network.communitiesLanding();
        
    }   
    
    public CommunitiesLandingController() {}
}
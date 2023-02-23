/*
 * Title: User Deactivation
 * Description: Class for "User Deactivation" page in the Community portal. It deactivates user and sends notification to admin that further action needed (changing User profile).
 * Author:  ldra
 * Created:  2018-11
 */

public class UserDeactivation {
    
    @AuraEnabled
    public static User getUser(){
       User u = [select Id, LastName, Username from User where Id =: UserInfo.getUserId()];
        System.debug('user 1: '+u);
       //User u = [select Id from User where Id = '0056E000003qFvd'];
       return u;
    }
    
    @AuraEnabled
    public static Map<String,String> deactivateUser(String reason, User user){
        Map<String,String> resultMap = new Map<String,String>();
        
        try {

           // profile p = [SELECT ID FROM Profile WHERE ID = '00e6E000000QPV0' LIMIT 1] ;
			//User u = [select Id, ContactId, ProfileId, Reason_for_leaving__c from User where Id =: UserInfo.getUserId()];
            User u = [select Id, ContactId, ProfileId, Reason_for_leaving__c from User where Id =: user.Id ];
            System.debug('user 2: '+u);
            u.IsActive = false;
            u.Reason_for_leaving__c = reason;
            //u.ProfileId = '00e6E000000QPV0';
           // u.ProfileId = p.Id;

            UserLogin ul = [select Id from UserLogin where UserId =: u.Id ];
            ul.IsFrozen = true;
            
            //Contact c = [select Id from Contact where Id =: u.ContactId];
       		//c.HasOptedOutOfEmail=true;
            //Update c;
            //
            if(UserInfo.getUserId() == user.Id || (user.LastName == 'TestUser' && user.Username == 'test@u-blox.com.dev')) {
				Update u;
            	Update ul;
                
                resultMap.put('status','success');
        		resultMap.put('message','Your profile has been deactivated.'); 
            }
            else {
                resultMap.put('status','error');
        		resultMap.put('message','Sorry, you don\'t have a permission to deactivate.'); 
            }

        } catch(DmlException e) {
            resultMap.put('status','error');
        	resultMap.put('message',e.getMessage());
		}
        return resultMap;
    }

}
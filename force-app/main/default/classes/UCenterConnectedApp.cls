/*
*
* This class extends u-center2 connected app
* Purpose is to add u-center access level in the Id Token
* u-center access level maintained in Contact by FAE users
*
* ***** Access Level *****
* No Access 0   
* Public    1   
* NDA       2   
* FAE       3
* 
* **************************************************************************************
* 
* @author         Sami Azam   <sami.azam@u-blox.com>
* @created        2/7/2022
*
* *************************************************************************************
*
* @changes
* IN_SF_MTC-1184  khurram.shahzad@u-blox.com
* 16/03/2022      Added Access level for internal users
*                 Service Profile Users -> FAE
*                 All Internal Users -> NDA
*                 
* *************************************************************************************
*/

global class UCenterConnectedApp extends Auth.ConnectedAppPlugin {
    private static final set<string> SERVICE_PROFILE = new set<string>{
        'Service Technical Manager',
        'Service FAE',
        'Service RAE',        
        'AE Head',
        'R&D / Quality'
    };

    // Return a user’s u center access level
    global override Map<String,String> customAttributes(Id userId, Id connectedAppId, Map<String,String>
        formulaDefinedAttributes, Auth.InvocationContext context) {  
        // ticket No.IN_SF_MTC-753 request to get u center access from user's contact
        //getting user's u center access level 
        String uCenterAccess;       
        for(user tempUser : [SELECT Id,contact.u_Center_Access__c,Profile.Name,UserType FROM User WHERE Id =: userId]){
            if(tempUser.UserType == 'Standard'){
                if(SERVICE_PROFILE.contains(tempUser.Profile.Name)){
                    uCenterAccess = '3';
                }else uCenterAccess = '2';
            }else {
                uCenterAccess = String.isblank(tempUser.contact.u_Center_Access__c) || tempUser.contact.u_Center_Access__c == NULL  ? '1' : tempUser.contact.u_Center_Access__c ;
            }
        }        
        formulaDefinedAttributes.put('u_center_access_level', uCenterAccess);
        return formulaDefinedAttributes;     
    } 
}
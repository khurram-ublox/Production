/**
* @date 2020
* @description sending emails to frozen user's manager for successor, so that they could be deactivated successfully.
* @History created date 10/22/2020
* @Author: saaz
*/
global class EmailTOFrozenUserManagers implements Schedulable {
    
    Map<Id,emailManagerWrapper> emailManagerWrapperMap = new Map<Id,emailManagerWrapper>(); 
    
    global void execute(SchedulableContext ctx) {
        OrgWideEmailAddress fromEmail = [select Id from OrgWideEmailAddress where Address = 'salesforce@u-blox.com'];
        //fetch frozen users from last 30(60) days
        for(User tempUser : [SELECT Id, Name,ManagerId,Manager.FirstName FROM User WHERE Id IN  (SELECT UserId FROM UserLogin where isFrozen = true) AND UserType = 'Standard' AND isActive = TRUE AND  ManagerId != NULL AND Manager.isActive = TRUE AND LastModifiedDate =  LAST_N_DAYS:30 ]){
            //Fetch frozen user's managers,Names, User Ids and User Names and put them in map
            emailManagerWrapper obj = new emailManagerWrapper(tempUser.ManagerId,tempUser.Manager.FirstName,tempUser.Name);
            emailManagerWrapperMap.put(tempUser.Id,obj);
        }
        if(emailManagerWrapperMap != NULL && !String.isEmpty(fromEmail.Id)   ){
            sendEmail.toEmailManager(emailManagerWrapperMap, fromEmail.Id);
        }
    }//Apex Wrapper class for storing Manager Id, mgr Names and User Names
    global class emailManagerWrapper{
        public Id managerIds;
        public String managerName;
        public String userName;
        public emailManagerWrapper(Id managerIds,String managerName,String userName){
            this.managerIds = managerIds;
            this.managerName = managerName;
            this.userName = userName;
        }
    }
}
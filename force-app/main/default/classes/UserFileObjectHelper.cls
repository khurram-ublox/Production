public class UserFileObjectHelper{
    
    public static User_File__c isUserFilePresent(String contactId)
    {
        User_File__c userFileObj = null;
        if(!String.isEmpty(contactId)){
            List<User_File__c> uFileList = [select id,contactId__c from User_File__c where contactId__c =: contactId ];
            if(uFileList.size()>0)
                 userFileObj = uFileList[0];
        }
        return userFileObj;
    }
    
    public static User getUserForContact(String conId)
    {
        User userObj = null;
        if(!String.isEmpty(conId)){
            List<User> uList = [select id,FirstName,LastName,contactId from User where contactId =: conId ];
            if(uList.size()>0)
                 userObj = uList[0];
        }
        return userObj;        
    }
    
    public static User_File__c createUserFile(User userObj)
    {
        User_File__c uFileObj = new User_File__c();
        uFileObj.Name = userObj.FirstName+' '+userObj.LastName;
        uFileObj.OwnerId = userObj.id;
        uFileObj.ContactId__c = userObj.ContactId;
        insert uFileObj;
        return uFileObj;
    }
}
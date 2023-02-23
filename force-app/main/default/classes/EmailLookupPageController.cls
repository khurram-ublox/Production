/*
    Name         : EmailLookupPageController
    Author       : PARX
    Date         : 11th Oct 2017
    Description  : This class is used for pupulate user selectOption list.
*/
public class EmailLookupPageController{
   
    public List<SelectOption> userOptionList {get;set;}
    public List<SelectOption> showOptionList {get;set;}
    public String selectedShow {get;set;}
    
    private Map<Id,String> userMap;
    
    public EmailLookupPageController(){
        selectedShow = '';
        showOptionList = new List<SelectOption>();
        userOptionList = new List<SelectOption>();
        showOptionList.add(new SelectOption('All Co-workers in Company','All Co-workers in Company'));
        
        userMap  = new Map<Id, String>();
       
        for(User usr : [Select Id,Name from User where IsActive = true AND userType = 'Standard' Order By Name ]) {
            userMap.put(usr.Id,usr.Name);
            userOptionList.add(new SelectOption(usr.Id,usr.Name));  
        }
    }
}
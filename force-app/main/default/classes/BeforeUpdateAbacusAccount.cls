/*
** Check before Account modification
** @rule:
** if account linked to Abacus (connected) prevent user from modifying for some fileds (Name, Phone, Fax, Customer No)
** else OK
*/


public class BeforeUpdateAbacusAccount{
    
    //Determine if Account from Abacus import or not
    public static boolean fromAbacus=false;
    public static User thisUser=[select u.isUserSpecial__c, u.Profile.Name from user u where u.Id=:UserInfo.getUserId()];
    public static String profileName=(String)thisUser.Profile.Name;
    public static boolean specialUser = thisUser.isUserSpecial__c;
    public static String errorMessage = 'Account linked to Abacus. Customer No, Phone, Fax, and Credit information are not modifiable.';
   
    
    public static void beforeUpdateAbacusAccount(List<Account> listNewAccount,List<Account> listOldAccount){
    
        for(Integer i=0;i<listNewAccount.size();i++){            
            
            Account newAcc=listNewAccount.get(i);
            Account oldAcc=listOldAccount.get(i);
            String street=oldAcc.ShippingStreet!=null?oldAcc.ShippingStreet:'';
            String state=oldAcc.ShippingState!=null?oldAcc.ShippingState:'';
            String city=oldAcc.ShippingCity!=null?oldAcc.ShippingCity:'';
            String code=oldAcc.ShippingPostalCode!=null?oldAcc.ShippingPostalCode:'';
            String country=oldAcc.ShippingCountry!=null?oldAcc.ShippingCountry:'';
            String address=street+city+state+code+country;
            
            //System.debug('============Address:'+address);
            
      
            if(address==null || address.length()==0) //i.e. not linked to Abacus
                continue;
            

            //i.e. linked to Abacus(cannot update name,phone,fax,cus no)
            //Account linked to Abacus, this field is not modifiable
            if(newAcc.Name!=oldAcc.Name && !specialUser){
                newAcc.Name.addError(errorMessage);
            }
            if(newAcc.Phone!=oldAcc.Phone && !specialUser){
                newAcc.Phone.addError(errorMessage);
            }
            if(newAcc.Fax!=oldAcc.Fax && !specialUser){
                newAcc.Fax.addError(errorMessage);
            }
            if(newAcc.Customer_No__c!=oldAcc.Customer_No__c && !specialUser){
                newAcc.Customer_No__c.addError(errorMessage);
            }
        } //end for      
    }
    
     /*
    ** Test Methods
    */
    
    
    
}
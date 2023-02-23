/**
** This class is used for:
** 1- Update Account Owner based on the acc's Country and/or State in the Country__c
** 2- Update Accocunt UB Office based on respective UB Office in the Country__c
** 3- Replaced Account_Manager__c with OwnerId of Country object Ticket # IN_SF_MTC-1364 

** ----------- last modified: 09-03-2009 -----------
*/

public class UpdateAccount {
    
    //this class for befor insert account    
        static Map<String,String> mapCtyWithStates=new Map<String,String>();
        
        static {
            mapCtyWithStates.put('US','US');
            mapCtyWithStates.put('CA','CA');
            mapCtyWithStates.put('CN','CN');
        }
    
    //create on trigger on Account, before insert, which set properly the owner of the account
    //owner is choosen based on the country : country code/state code or full state  
    public static void beforUpdateAccount(List<Account> accounts){
        
        Set<String> setCountryCode=new Set<String>();
        Set<String> setStateCode=new Set<String>();
        Set<String> setAccManager=new Set<String>();
        
        Map<String,User> mapUser=new Map<String,User>();
        Map<String,User> mapUser2=new Map<String,User>();
        
        List<String[]> lstAliasCountry=new List<String[]>();//
        List<String[]> lstAliasCountry2=new List<String[]>();//
        
        Map<String,String> mapCountryUbOffice=new Map<String,String>();//key is Country or ISO code and value is UB office       
        
        Map<String,String> mapCountryState=new Map<String,String>();    
            
        for(Account acct : accounts){
            
            if(acct.ShippingCountry!=null){
                setCountryCode.add(acct.ShippingCountry);           
            }       
            if(acct.ShippingState!=null)
                setStateCode.add(acct.ShippingState);//State Code    
        }
            
        for(Account acct : accounts){
            
            //for US CA and CN
            if(mapCtyWithStates.get(acct.ShippingCountry)!=null){                               
                String state=(acct.ShippingState!=null?acct.ShippingState:'');            
                
                if(state!='')
                    mapCountryState.put(acct.ShippingCountry+'#'+state,acct.ShippingCountry+'#'+state);
                else{
                    String city=(acct.ShippingCity!=null?acct.ShippingCity:'');
                    mapCountryState.put(acct.ShippingCountry+'#'+city,acct.ShippingCountry+'#'+city);
                }
            }
            else{
                mapCountryState.put(acct.ShippingCountry,acct.ShippingCountry);
            }
        
        }
                
        for(Country__c c : [select uB_Office__c,OwnerId,ISO_Code__c,State_Code__c,State__c from Country__C where ISO_Code__c IN : setCountryCode OR State_Code__c IN : setStateCode]){
            
            //Dealing with Ub Office            
            mapCountryUbOffice.put(c.ISO_Code__c,c.uB_Office__c);
                    
            if(c.ISO_Code__c!=null){                    
                String state=(c.State_Code__c!=null?c.State_Code__c:''); //State Code
                String state2=(c.State__c!=null?c.State__c:''); //full State
                String s=(mapCtyWithStates.get(c.ISO_Code__c)!=null?mapCountryState.get(c.ISO_Code__c+'#'+state):mapCountryState.get(c.ISO_Code__c));
                           
                //System.debug('>>>country and state code: '+c.ISO_Code__c + ', '+state + ', ' + state2);
                //System.debug('>>>s: '+s);
                
                if(s==null) {
                    String s2=(mapCtyWithStates.get(c.ISO_Code__c)!=null?mapCountryState.get(c.ISO_Code__c+'#'+state2):mapCountryState.get(c.ISO_Code__c));            
                    
                    if(s2==null){                     
                        continue;
                    }
                }
                
                lstAliasCountry.add(new String[]{c.OwnerId,c.ISO_Code__c+'#'+state});//replaced Account_Manager__c with OwnerId of Country object, Country Code#State Code 
                lstAliasCountry2.add(new String[]{c.OwnerId,c.ISO_Code__c+'#'+state2});//replaced Account_Manager__c with OwnerId of Country object, Country Code#State full
                setAccManager.add(c.OwnerId);//replaced Account_Manager__c with OwnerId of Country object                             
                
            }
        
        }   
                   
        
        Map<String,String> mapAlias=new Map<String,String>();
        for(User u : [select id,Alias from User where Id IN :setAccManager]){ //replaced Alias with OwnerId of Country object                
        
            for(String[] s:lstAliasCountry){        
                if(u.Id == s.get(0)) { 
                    mapUser.put(s.get(1),u); //for country code#state code
                }    
            }
            for(String[] s:lstAliasCountry2){        
                if(u.Id == s.get(0)) {
                    mapUser2.put(s.get(1),u); //for country code#full state
                }    
            }
        }       
        
    
        for(Account acc : accounts){
            System.debug('>>>Account obj'+acc);     
            String state=(acc.ShippingState!=null?acc.ShippingState:''); 
            
            if(state=='') state=(acc.ShippingCity!=null?acc.ShippingCity:''); //see city instead of state      
            
            User us=(mapCtyWithStates.get(acc.ShippingCountry)!=null?mapUser.get(acc.ShippingCountry+'#'+state):mapUser.get(acc.ShippingCountry+'#'));
            //System.debug('>>> USER obj step 1'+us);     
            
            if(us==null){
                us=(mapCtyWithStates.get(acc.ShippingCountry)!=null?mapUser2.get(acc.ShippingCountry+'#'+state):mapUser2.get(acc.ShippingCountry+'#'));        
            }
    
            if(us!=null){
                acc.OwnerId=us.Id;//user
                System.debug('>>>USER obj final step'+us);         
            }
            
            //dealing with Ub office
            String ubOff=mapCountryUbOffice.get(acc.ShippingCountry);
            System.debug('>>> ubOff ' + ubOff);
            
            if(ubOff!=null){
                acc.uB_Office__c=ubOff; 
            }
            
                    
        }
    
    
    }//end method
    
    
    
    }
/*
** 3- Replaced Account_Manager__c with OwnerId of Country object Ticket # IN_SF_MTC-1364 
*/

public class UpdateLead {
    
    
    static Map<String,String> mapCtyWithStates=new Map<String,String>();
    
    static {
        mapCtyWithStates.put('US','US');
        mapCtyWithStates.put('CA','CA');
        mapCtyWithStates.put('CN','CN');
    }

//create on trigger on Lead, before update, which set properly the owner of the Lead
//owner is choosen based on the country : country code/state code or full state  
public static void changeOwnerOnLead(List<Lead> leads){
    
    Set<String> setCountryCode=new Set<String>();//set ISO_Code
    Set<String> setStateCode=new Set<String>();
    Set<String> setAccManager=new Set<String>();//set Alias
    
    Map<String,User> mapUser=new Map<String,User>();
    Map<String,User> mapUser2=new Map<String,User>();//
    
    List<String[]> lstAliasCountry=new List<String[]>();//
    List<String[]> lstAliasCountry2=new List<String[]>();//
    
    Map<String,String> mapCountryState=new Map<String,String>();    
    
    Map<String,String> mapCountryUbOffice=new Map<String,String>();//key is Country or ISO code and value is UB office   
        
    for(Lead lead : leads){
        
        if(lead.Country!=null){
            setCountryCode.add(lead.Country); //set ISO_Code          
        }       
        
        //new version (20-08-09)
        if(lead.State!=null)
            setStateCode.add(lead.State);//State Code 
        /////////////////////////////////////////////       
        
        //old version
        //if(lead.City!=null)
        //    setStateCode.add(lead.City);//State Code    
    }
        
    for(Lead lead : leads){        
        
        //old version
        //for US CA and CN
        /*if(mapCtyWithStates.get(lead.Country)!=null){ //mapCtyWithStates{ US CA and CN}                              
            String state=(lead.City!=null?lead.City:'');//state=city
            mapCountryState.put(lead.Country+'#'+state,lead.Country+'#'+state);//mapCountryState{Contry#City,Country#City}
        }
        else{
            mapCountryState.put(lead.Country,lead.Country);////mapCountryState{Contry,Country}
        }*/
        
        //new version (20-08-09)
        //for US CA and CN
        if(mapCtyWithStates.get(lead.Country)!=null){                               
            String state=(lead.State!=null?lead.State:'');            
            
            if(state!='')
                mapCountryState.put(lead.Country+'#'+state,lead.Country+'#'+state);
            else{
                String city=(lead.City!=null?lead.City:'');
                mapCountryState.put(lead.Country+'#'+city,lead.Country+'#'+city);
            }
        }
        else{
            mapCountryState.put(lead.Country,lead.Country);
        }
        ///////////////////////////////////////////////////////////////////////////
    
    }
   
    for(Country__c c : [select uB_Office__c,OwnerId,ISO_Code__c,State_Code__c,State__c from Country__C where ISO_Code__c IN : setCountryCode OR State_Code__c IN : setStateCode]){
        //if ISO_Code__c=null???????????????
        
        //Dealing with Ub Office            
        mapCountryUbOffice.put(c.ISO_Code__c,c.uB_Office__c);
              
        if(c.ISO_Code__c!=null){//countryCode                
            String state=(c.State_Code__c!=null?c.State_Code__c:''); //
            String state2=(c.State__c!=null?c.State__c:''); //full State, Alasca
            String s=(mapCtyWithStates.get(c.ISO_Code__c)!=null?mapCountryState.get(c.ISO_Code__c+'#'+state):mapCountryState.get(c.ISO_Code__c));
                       
            //System.debug('>>>country and state code: '+c.ISO_Code__c + ', '+state + ', ' + state2);
            //System.debug('>>>s: '+s);
            
            if(s==null) {
                String s2=(mapCtyWithStates.get(c.ISO_Code__c)!=null?mapCountryState.get(c.ISO_Code__c+'#'+state2):mapCountryState.get(c.ISO_Code__c));            
                
                if(s2==null)            
                    continue;
            }
            
            lstAliasCountry.add(new String[]{c.OwnerId,c.ISO_Code__c+'#'+state});//replaced Account_Manager__c with OwnerId of Country object, Country Code#State Code
            lstAliasCountry2.add(new String[]{c.OwnerId,c.ISO_Code__c+'#'+state2});//replaced Account_Manager__c with OwnerId of Country object, Country Code#State full
            setAccManager.add(c.OwnerId);//replaced Account_Manager__c with OwnerId of Country object    
        }
    
    }   
    
       
    Map<String,String> mapAlias=new Map<String,String>();
    for(User u : [select id,Alias from User where Id IN :setAccManager]){   //replaced Alias with OwnerId of Country object             
    
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
       
    for(Lead lead : Leads){
        
        //old version
        //String state=(lead.City!=null?lead.City:'');  
        
        //new version (20-08-09)
        String state=(lead.State!=null?lead.State:''); 
        if(state=='') state=(lead.City!=null?lead.City:''); //see city instead of state      
        ///////////////////////////////////////////////////////////////////////////////
        
        User us=(mapCtyWithStates.get(lead.Country)!=null?mapUser.get(lead.Country+'#'+state):mapUser.get(lead.Country+'#'));
        
        if(us==null){
            us=(mapCtyWithStates.get(lead.Country)!=null?mapUser2.get(lead.Country+'#'+state):mapUser2.get(lead.Country+'#'));        
        }
        

        if(us!=null){
            lead.OwnerId=us.Id;//user
               
        }
        
         //dealing with Ub office
        String ubOff=mapCountryUbOffice.get(lead.Country);
                
        if(ubOff!=null){
            lead.uB_Office__c=ubOff;    
        }
        
                
    }


}//end method

//------------------------------------------------------------------

}
public class AssitNowEnableCtrl {
	 @AuraEnabled
     public static Boolean assitNowEnableToken(String recordId){
       String ContactId;
       
       if(!string.isEmpty(recordId)){ 
        ContactId=recordId;
        Contact conc= new Contact();
        conc=[Select id,MGA__c,MGA_Token__c,MGA_Requested_Date__c from Contact Where id=:ContactId];           
         //System.debug('aaaaaaaaaa'+conc);
        if (String.isEmpty(conc.MGA_Token__c)){
            
           return true;
        }else if(conc.MGA__c == true && !String.isEmpty(conc.MGA_Token__c)){
          return false;  
        }                              
       }
       return false;
     }
     
    @AuraEnabled
     public static String assitNowEnableTokenConform(String recordId){
        String ContactId=recordId;
        Contact conc= new Contact();
        conc=[Select id,MGA__c,MGA_Token__c,MGA_Requested_Date__c from Contact Where id=:ContactId];
         // generate MGA Token
         // Make sure the URL http://token-live1.services.u-blox.com is added in
         // Your name | Administration Setup | Security Control | Remote Site Settings
         if(!Test.isRunningTest()){ 
             HttpRequest req = new HttpRequest();req.setEndpoint('http://token-live1.services.u-blox.com/GetToken.ashx?key=84cba94b-24fd-48db-a370-d5b81805db52');
             req.setMethod('GET');Http h = new Http(); HttpResponse res = h.send(req);conc.MGA_Token__c = res.getBody();
         }    
         conc.MGA__c = True;
         upsert conc;    
         
       return conc.id;
         
     }
    
    @AuraEnabled
     public static String assitNowEnableTokenReSend(String recordId){
        String ContactId=recordId;
        Contact conc= new Contact();
        conc=[Select id,MGA__c,MGA_Token__c,MGA_Requested_Date__c,AssistNow_Token_Resend__c from Contact Where id=:ContactId];
        conc.AssistNow_Token_Resend__c = True;
        upsert conc;                                 
       return conc.id;
     }
    
}
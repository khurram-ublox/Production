public class AssistNowEnableCtrl {
     @AuraEnabled
     public static Boolean checkToken(String recordId){
         if(!string.isEmpty(recordId)){ 
             Contact c=[Select id,MGA__c,MGA_Token__c,MGA_Requested_Date__c from Contact Where id=:recordId];           
             //System.debug('aaaaaaaaaa'+conc);
             if (String.isEmpty(c.MGA_Token__c)){
                 return true;
             }else if(c.MGA__c == true && !String.isEmpty(c.MGA_Token__c)){
                 return false;  
             }                              
         }
         return false;
     }
     
    @AuraEnabled
     public static String enableToken(String recordId){
        Contact c = [Select id,MGA__c,MGA_Token__c,MGA_Requested_Date__c from Contact Where id=:recordId];
         // generate MGA Token
         // Make sure the URL http://token-live1.services.u-blox.com is added in
         // Your name | Administration Setup | Security Control | Remote Site Settings

         
         String url = 'https://token-live1.services.u-blox.com/GetToken.ashx?key=test-key';
         if(!Test.isRunningTest()){ 
             //String url = 'https://token-live1.services.u-blox.com/GetToken.ashx?key=28549d2b-be1a-4137-894d-e1d0ee93c1b6';
             url = 'https://token-live1.services.u-blox.com/GetToken.ashx?key=84cba94b-24fd-48db-a370-d5b81805db52';
         }
         HttpRequest req = new HttpRequest();
         req.setEndpoint(url);
         req.setMethod('GET');
         Http h = new Http();
         if(!Test.isRunningTest()){
         	HttpResponse res = h.send(req);
            c.MGA_Token__c = res.getBody();
         }

         c.MGA__c = True;
         update c;    
         
         return c.id;
         
     }
    
    @AuraEnabled
     public static String resendToken(String recordId) {
        Contact c = [Select id,MGA__c,MGA_Token__c,MGA_Requested_Date__c,AssistNow_Token_Resend__c from Contact Where id=:recordId];
        c.AssistNow_Token_Resend__c = True;
        update c;                                 
        return c.id;
     }
    
}
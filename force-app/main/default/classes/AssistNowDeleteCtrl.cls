public class AssistNowDeleteCtrl {
    @AuraEnabled
    public static Boolean checkToken(String recordId){
        String ContactId;
        if(!string.isEmpty(recordId)){ 
            ContactId=recordId;
            Contact conc= new Contact();
            conc=[Select id,MGA__c,MGA_Token__c,MGA_Requested_Date__c from Contact Where id=:ContactId];           
            if (conc.MGA__c == true && conc.MGA_Token__c != ''){
                return true;
            }                              
        }
        return false;
    }
    
    @AuraEnabled
     public static String deleteToken(String recordId){
         Contact c=[Select id,MGA__c,MGA_Token__c,MGA_Requested_Date__c from Contact Where id=:recordId];    
         c.MGA__c = false;
         c.MGA_Token__c = null;
         c.AssistNow_Token_To_Delete__c = c.MGA_Token__c;
         update c;                                 
         return c.id;
     }
    
}
global without sharing class SpamEmailCtrl {
    
    public List<String> toAddresses = new List<String>();
    
    public SpamEmailCtrl(ApexPages.StandardController controller) {
    }
    @RemoteAction
    global static Boolean spamCaseId(String CaseId){ 
        if(CaseId==null) return false;
        Case caseObj = [Select Id,Status, suppliedEmail from Case where Id=:CaseId];
      
        if(!String.isEmpty(caseObj.suppliedEmail) )
        sendEmail(caseObj.suppliedEmail);
        caseObj.Status = 'Closed';
        if(!Test.isRunningTest()){ 
            update caseObj;
        }
        return true;
    }
    public static void sendEmail(String suppliedEmail){
        
        Map<String, Macro_From_Address__mdt> mcs = Macro_From_Address__mdt.getAll();
        
        Map<String, Spam_Email__mdt> spamEmalToAddress = Spam_Email__mdt.getAll();
        if(spamEmalToAddress == NULL){
           return; 
        }
        String toAddress = spamEmalToAddress.get('Spam_Email_Address').Spam_Email__c;
        List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();
        List<String> toAddresses = new List<String>();
        toAddresses.add(toAddress);
        
        for(Macro_From_Address__mdt FromAddressObj:  mcs.values()){
            Messaging.SingleEmailMessage messageObj = new Messaging.SingleEmailMessage();
            messageObj = SendEmail.setMessagingEmail(suppliedEmail,toAddresses, FromAddressObj.From_Address__c);

            messageList.add(messageObj);
        }
        Messaging.SendEmailResult[] r =Messaging.sendEmail(messageList);    
    }
}
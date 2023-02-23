public class EmailMessageClosedCases {
    //don't split the case if message came from domain like bosch.com

    @InvocableMethod
    public static list<EmailMessage> replyToClosedCase(list<EmailMessage> messages){
        list<EmailMessage> emailMessageIdsFromSkipDomain = new list<EmailMessage>();
        
              
        if(!domainstoskip__c.getAll().isEmpty()){            

            for(EmailMessage eMessage : messages){                
                Boolean fromSkipDomain = false;                                 
                for(string domain : domainstoskip__c.getAll().keySet()){                    
                    fromSkipDomain = eMessage.FromAddress.endsWithIgnoreCase(domain);
                    if(fromSkipDomain){
                        emailMessageIdsFromSkipDomain.add(eMessage);
                    }                        
                }                                                        
            } 
        }
        if(!emailMessageIdsFromSkipDomain.isEmpty()){
            return emailMessageIdsFromSkipDomain;
        }else return null;
    }
}
public class ServiceCloud_MacroHandler {
    private string caseId;
    private string macroName;
    private string toAddress;
    private string ccAddress;
    private string BccAddress;
    private string fromAddress;
    private boolean doUpdate = true;    
    private static map<string, string> senderNameMap = new map<string, string>();
     
    public ServiceCloud_MacroHandler() {
        for(Macro_From_Address__mdt macro : [Select Label, From_Address__c from Macro_From_Address__mdt]){            
            senderNameMap.put(macro.From_Address__c, macro.Label);
        }
    }

    public void setCaseRecordId(string recordId){
        caseId = recordId;
    }

    public void setMacroUniqueName(string mName){
        macroName = mName;
    }

    public void setToEmailAddress(string To){
        toAddress = To;
    }

    public void setCCEmailAddress(string CC){
        ccAddress = CC;
    }

    public void setBCcEmailAddress(string BCc){
        BccAddress = BCc;
    }

    public void setFromEmailAddress(string fromId){
        fromAddress = fromId;
    }
    
    public void setDoUpdateCase(boolean flag){
        doUpdate = flag;
    }

    public void executeActions(){
        sendMacroEmail();
        if(doUpdate){
            updateCase();
        }else updateCaseLater(caseId);            
    }
            
    private void sendMacroEmail(){
        string[] toRecipients = convertToAddressAsList();
        string[] ccRecipients = convertCCAddressAsList();
        string[] BccRecipients = convertBCcAddressAsList();

        if(toRecipients == null && ccRecipients == null && BccRecipients == null){
            throw new AuraHandledException('Specify a recipient in the To, CC, or BCC address fields.');                
        }
        list<string> emailAddresses = new list<string>();
        emailAddresses.addAll(toRecipients);
        if(ccRecipients != null)
            emailAddresses.addAll(ccRecipients);
        if(BccRecipients != null)
            emailAddresses.addAll(BccRecipients);
        
        Id contactId = getCaseContactId(emailAddresses);        
        EmailTemplate template = getEmailTemplate();
        Id OrgWidefromAddressId = getOrgWideFromAddress();        
        string htmBody = SendEmail.sendEmailWithTemplate(contactId,
                                        caseId,
                                        template.Id,
                                        OrgWidefromAddressId,
                                        toRecipients,
                                        ccRecipients,
                                        BccRecipients,
                                        fromAddress,
                                        senderNameMap.get(fromAddress)
                                    );
        createNewOutboundEmailMessage(template, htmBody);
    }
    
    @future
    private static void updateCaseLater(string caseId){
        try{
            list<Case> crecord = [SELECT Id, Status,PIF_Sent__c FROM Case where Id =: caseId];
            Case caseRecord = crecord[0];
            caseRecord.PIF_Sent__c = true;
            caseRecord.Status = 'Waiting For Response';           
            database.update(caseRecord,false);
        }catch(DMLException ex){
            throw new ApexException(ex.getmessage());
        }        
    }

    private void updateCase(){
        try{
            list<Case> crecord = [SELECT Id, Status,PIF_Sent__c FROM Case where Id =: caseId];
            Case caseRecord = crecord[0];
            if(macroName != 'Case_Email_Guide_customer_to_self_service'){
                caseRecord.status = 'Closed';
                if(macroName == 'Case_Send_Email_for_more_info'){
                    caseRecord.PIF_Sent__c = true;
                }
            }
            database.update(caseRecord,false);
        }catch(DMLException ex){
            throw new AuraHandledException(ex.getmessage());
        }        
    }

    private void createNewOutboundEmailMessage(EmailTemplate template, string htmlbody){
        try{
            EmailMessage eMessage = new EmailMessage(            
                Incoming = false,    
                status = '3',
                relatedToId = caseId,
                ParentId = caseId,
                fromAddress = fromAddress,
                fromName = senderNameMap.get(fromAddress),
                subject = template.Subject,
                EmailTemplateId = template.Id,
                htmlBody = htmlbody,
                TextBody = template.Body,
                toAddress = toAddress,
                CcAddress = ccAddress,
                BccAddress = BccAddress
            );
            database.insert(eMessage, false);
        }catch(DMLException ex){
            throw new AuraHandledException(ex.getmessage());
        }        
    }

    private string[] convertToAddressAsList(){
        if(toAddress != 'null' && toAddress != null && toAddress.contains(',') && !string.isBlank(toAddress)){
            return toAddress.split(',');
        }else if(toAddress != 'null' && toAddress != null && !string.isBlank(toAddress)){
            return new string[]{toAddress};
        }
        return null;
    }

    private string[] convertCCAddressAsList(){
        if(ccAddress != 'null' && ccAddress != null && ccAddress.contains(',') && !string.isBlank(ccAddress)){
            return ccAddress.split(',');
        }else if(ccAddress != 'null' && ccAddress != null && !string.isBlank(ccAddress)){
            return new string[]{ccAddress};
        }
        return null;
    }

    private string[] convertBCcAddressAsList(){
        if(BccAddress != 'null' && BccAddress != null && BccAddress.contains(',') && !string.isBlank(BccAddress)){
           return BccAddress.split(',');
        }else if(BccAddress != 'null' && BccAddress != null && !string.isBlank(BccAddress)){
            return new string[]{BccAddress};
        }
        return null;
    }
       
    private EmailTemplate getEmailTemplate(){
        list<EmailTemplate> emailTemps = [SELECT Id, 
                                            Name, 
                                            DeveloperName, 
                                            Subject, 
                                            HtmlValue, 
                                            Body 
                                            FROM EmailTemplate 
                                            WHERE DeveloperName =: macroName limit 1];

        if(emailTemps.size() > 0)
            return emailTemps[0];
        return null;
    }

    private Id getOrgWideFromAddress(){
        list<OrgWideEmailAddress> orgWideAddress = [SELECT Id FROM OrgWideEmailAddress WHERE Address =: fromAddress LIMIT 1];
        if(orgWideAddress.isEmpty()){
            return null;
            //throw new AuraHandledException('This From address is not registered as Org Wide Email Address');
        }else return orgWideAddress[0].Id;
    }

    private Id getCaseContactId(list<string> toAddresses){
        list<Case> caseContact = [SELECT ContactId FROM Case WHERE Id =: caseId LIMIT 1];        
        if(caseContact.isEmpty() ||  caseContact[0].ContactId == null){
            list<Contact> conts = [SELECT Id FROM Contact WHERE Email IN:toAddresses LIMIT 1];            
            if(conts.isEmpty()){                
                return [Select Id from Contact WHERE Email != NULL limit 1].Id;
            }else return conts[0].Id;
        }else return caseContact[0].ContactId;
    }
}
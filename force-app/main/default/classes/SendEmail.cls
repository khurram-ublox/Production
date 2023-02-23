public class SendEmail {

    /* Khurram Shahzad 
     *
     *  Send Single Email Message to User, Contact or Lead by using Salesforce Email Templates. 
     *  This requires following parameters.
     *  
     *  @ToRecipients : Email Address of Recipients
     *  
     *  @ccRecipients : Eamil Address of CC Recipients.
     *
     *  @TargetObjectID : The ID of the contact, lead, or user to which the email will be sent.
   *            The ID you specify sets the context and ensures that merge fields in the template contain the correct data.
     *  
     *  @EmailTemplateID : Must be a Email Template Id to which you want to use for email message.
     *       
     */   
    
  public static string sendEmailWithTemplate(ID whoIdRecipient, ID TargetObjectId, ID EmailTemplateID, ID fromAddressId, string[] toRecipients, string[] ccRecipients, string[] bccAddresses, string replyToAddress, string senderName){
        Messaging.Singleemailmessage myMail = new Messaging.Singleemailmessage();
        
        MyMail.setWhatId(TargetObjectId);
        MyMail.setToAddresses(toRecipients);
        MyMail.setOrgWideEmailAddressId(fromAddressId);
        MyMail.setTargetObjectId(whoIdRecipient);
      //MyMail.setTargetObjectId(TargetObjectId);
        MyMail.setTemplateId(EmailTemplateID);
        myMail.setSaveAsActivity(false);
        myMail.setReplyTo(replyToAddress);
        if(fromAddressId == null || string.isBlank(fromAddressId))
            myMail.setSenderDisplayName(senderName);              
        Savepoint sp = Database.setSavepoint();
        Messaging.sendEmail(new Messaging.Singleemailmessage[] {myMail});
        Database.rollback(sp);
        string emailThread = ThreadId(TargetObjectId);
        Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
        emailToSend.setToAddresses(toRecipients);
        emailToSend.setHTMLBody(myMail.getHTMLBody()+emailThread);
        emailToSend.setSubject(myMail.getSubject()+emailThread);
        emailToSend.setReplyTo(myMail.getReplyTo());
        if(fromAddressId == null || string.isBlank(fromAddressId))
            emailToSend.setSenderDisplayName(myMail.getSenderDisplayName());
        emailToSend.setOrgWideEmailAddressId(myMail.getOrgWideEmailAddressId());
        if(ccRecipients != null && !ccRecipients.isEmpty())
            emailToSend.setCcAddresses(ccRecipients);
        if(bccAddresses != null && !bccAddresses.isEmpty())
            emailToSend.setBccAddresses(bccAddresses);
        if(!test.isRunningTest())
            Messaging.sendEmail(new Messaging.Singleemailmessage[] {emailToSend});
        
        return myMail.getHTMLbody();
    }
    //[ ref:_00D9E9RsZ._5009EK4aem:ref ]
    
    public static String ThreadId(String caseid){
        string Case_ThreadID = '[ ref:_' + UserInfo.getOrganizationId().left(5);
        Case_ThreadID = Case_ThreadID + UserInfo.getOrganizationId().mid(11,4) + '._';
        Case_ThreadID = Case_ThreadID + caseid.left(5) + caseId.mid(10,5) + ':ref ]';

        return Case_ThreadID;
    }
    
    public static boolean toAdmin(String subject, String body) {
        Boolean r = false;
        
        User[] admin = [Select Email from User where Username like 'salesforce@u-blox.com%' and IsActive = true and Name = 'u-blox' LIMIT 1];
        if(!admin.isEmpty()) {        
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { admin[0].Email };
                message.optOutPolicy = 'FILTER';
            message.subject = subject;
            message.plainTextBody = body;
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) {
                System.debug('The email was sent successfully.');
                r = true;
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
        }
        return r;
    }
    
    public static boolean toEmail(String recipient, String subject, String body) {
        Boolean r = false;
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { recipient };
            message.optOutPolicy = 'FILTER';
        message.subject = subject;
        message.plainTextBody = body;
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'do-not-reply@u-blox.com'];
        if ( owea.size() > 0 ) {
            message.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
            r = true;
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        
        return r;
    }

    /*********************************************************************************
    * @description Sends the Emails to forzen user's managers for asking the successors
    * @param 1 map of User Ids and User name
    * @param 2 Id of org wide email , from the email sent
    * @param 3 user ids and manager ids
    * @return boolean, returns true when email sent successfull otherwise false.
  * @history created.
    **********************************************************************************/
    Public static boolean toEmailManager(Map<Id,EmailTOFrozenUserManagers.emailManagerWrapper> UserIdwrapperclassObj, Id fromEmail) {
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        Boolean isEmailSent = false;
        Messaging.SendEmailResult[] results;
        for(Id  userId : UserIdwrapperclassObj.keySet()){
            EmailTOFrozenUserManagers.emailManagerWrapper obj;
            obj=UserIdwrapperclassObj.get(userId);
            String subject;
            String body;
            String URL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + userId ;
            subject = 'Frozen User Alert: ' +  obj.userName;
            body =  'Dear '+obj.managerName+',\n\nYou received this message because you are the manager of the frozen user ' + obj.userName + ' in Salesforce.\n' ;
            body += 'In order to finish the deactivation process, please let us know who is the successor / the person taking over the ' +obj.userName+'\'s responsibilities in Salesforce.\n\n';
            body += 'Frozen User Link : ' +URL+'\n\n';
            body += 'Thank you and best regards,\nu-blox SF Team';
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            //Manager Ids
            message.toAddresses = new String[] { obj.managerIds };
                message.setSubject(subject);
                message.setPlainTextBody(body);
            //message.set
            message.setOrgWideEmailAddressId(fromEmail);
            allMails.add(message);
        }
        if( allMails != NULL){
            results = Messaging.sendEmail(allMails);
        }
        if(results.size() > 0){
            if (results[0].success) {
                System.debug('The email was sent successfully.');
                isEmailSent = true;
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
        }
        return isEmailSent;
    }
    
      public static Messaging.Singleemailmessage setMessagingEmail(String Subject, List<String> toAddresses,String fromAddress){
        
         Messaging.Singleemailmessage myMail = new Messaging.Singleemailmessage();
        myMail.setPlainTextBody('');
        myMail.setToAddresses(toAddresses);
       // myMail.setOrgWideEmailAddressId(orgWideAddressId);
        myMail.setReplyTo(fromAddress);
        myMail.setSubject(Subject);
        return myMail;
        
    }
    
}
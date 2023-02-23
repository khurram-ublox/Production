/*
** Class:  SendOppReminderController
** Created by Wasim on 07/20/2015
** Description: Controller for the Opp_reminder custom Visual Force page. 
*/
public with sharing class SendOppReminderController {

    public String templateLang {get; set;}
    public List<OpportunityContactRole> OppConRoles {get; set;}
    public List<Opp_Product__c> OppProducts {get; set;}
    public EmailMessage emailMsg {get; private set;}
    public Boolean tada {get; private set;}

    private Opportunity thisOpp {get; set;}
    private List<OrgWideEmailAddress> sender = null;    
    private Boolean isPrimaryContact = false;
    private String primaryContact = null;
    

    private static final String SUPPORT_EMAIL_ADDRESS = UserInfo.getUserEmail();
    private static final String DEFAULT_SUPPORT_EMAIL_ADDRESS = 'info@u-blox.com';
    private static final String SUPPORT_NAME = UserInfo.getUserName();

    public SendOppReminderController(ApexPages.StandardController controller) {
        thisOpp = (Opportunity)controller.getRecord();
        emailMsg = new EmailMessage();
        sender = [select Id, Address from OrgWideEmailAddress where Address =: SUPPORT_EMAIL_ADDRESS];
        if(sender.isEmpty()){
            sender = [select Id, Address from OrgWideEmailAddress where Address =: DEFAULT_SUPPORT_EMAIL_ADDRESS];
        }
        System.debug('Sender: '+sender);
        System.debug('UserInfo.getUserEmail(): '+UserInfo.getUserEmail());


        OppConRoles = 
            [
                SELECT 
                    Id, Contact.Name,
                    Contact.Email,
                    Role, isPrimary
                FROM   
                    OpportunityContactRole
                WHERE  
                    OpportunityId =:((Opportunity)controller.getRecord()).Id

            ];

        /* OppProducts = 
            [
                SELECT 
                    Id,
                    Name, Status__c,
                    Opportunity__c
                FROM
                    Opp_Product__c
                WHERE
                    Opportunity__c =:((Opportunity)controller.getRecord()).Id 
                AND 
                    Status__c IN ('Won', 'Evaluation')

            ];   */

            System.debug('OCR: '+OppConRoles);

            for(OpportunityContactRole OCR : OppConRoles){
                if(OCR.isPrimary){
                    isPrimaryContact = true;
                    primaryContact = OCR.Contact.Email;
                    System.debug('isPrimary: '+OCR.isPrimary);
                    System.debug('Email: '+OCR.Contact.Email);
                    break;
                }
                else if(OCR.Contact.Email == null || OCR.Contact.Email == ''){
                    isPrimaryContact = false;
                    primaryContact = 'placeholder@email.field';
                }
            }
            System.debug('contactRoles: '+ OppConRoles);
        
    }

    public PageReference send() {
        try {

            System.debug('selected value of lang: '+ templateLang);
            System.debug('isPrimaryContact: '+isPrimaryContact);
            System.debug('emailMsg.ToAddress: '+emailMsg.ToAddress);

            //Error handling start

            if(emailMsg.ToAddress.contains(';')){
                List<String>invalidEmails = new List<String>();
                List<String>validEmails   = new List<String>();
                validEmails = emailMsg.ToAddress.split(';');
                
                for(Integer i=0; i<validEmails.size(); i++){
                    if(!validateEmail(validEmails[i].trim())){

                        invalidEmails.add(validEmails[i]);

                    }

                }
                validEmails.clear();

                if(invalidEmails.size()>0){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' Correct these email addresses'+invalidEmails));   

                 return null;
                }

                
            }else if(!validateEmail(emailMsg.ToAddress.trim()) || emailMsg.ToAddress == null || emailMsg.ToAddress == '' ){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' Please enter valid email address.'));

                 return null;

            }

            //Error handling ends

 
           
            Messaging.SingleEmailMessage singleEmailMsg = new Messaging.SingleEmailMessage();
           
            if (emailMsg.ToAddress != null && emailMsg.ToAddress != '') {
                singleEmailMsg.setToAddresses(emailMsg.ToAddress.split(';'));
            }

            if (emailMsg.BccAddress != null && emailMsg.BccAddress != '') {
                singleEmailMsg.setBccAddresses(emailMsg.BccAddress.split(';'));
            }

            if (emailMsg.CcAddress != null && emailMsg.CcAddress != '') {
                singleEmailMsg.setCcAddresses(emailMsg.CcAddress.split(';'));
            }

            
            singleEmailMsg.setOrgWideEmailAddressId(sender[0].Id); 
            singleEmailMsg.setSubject(emailMsg.Subject);
            //singleEmailMsg.setPlainTextBody(emailMsg.TextBody);
            singleEmailMsg.setHtmlBody(emailMsg.HtmlBody);

                       
            List<Messaging.SendEmailResult> results =  Messaging.sendEmail(
                new List<Messaging.SingleEmailMessage> {singleEmailMsg});

            if (results[0].success) {
                insert emailMsg;               
                onSuccessDoExtraActions(emailMsg.Id);
                
                PageReference pgRef = new PageReference('/' + thisOpp.Id);
                pgRef.setRedirect(true);
                return pgRef;
            } else {

                String errorMsg = 'Error sending Email Message. Details = ' + results.get(0).getErrors()[0].getMessage();
                System.debug('==========> ' + errorMsg);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
                return null;
            }
        }
        catch (Exception e) {

            String errorMsg = 'Exception thrown trying to send Email Message. Details = ' + e;
            System.debug('==========> ' + errorMsg);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
            return null;
        }

        return null;
    }

    public void onSuccessDoExtraActions(Id emailId){
        if(emailId!=null){
            List<Task> ah = [Select Id, OwnerId From Task Where WhatId =: thisOpp.Id And OwnerId =: UserInfo.getUserId() Order By CreatedDate Desc Limit 1];
            ah[0].Type = 'E-Mail';
           /* System.debug('Opp Id: '+thisOpp.Id);
            System.debug('UserInfo.getUserId(): '+UserInfo.getUserId());
            System.debug('ActivityHistory: '+ah);*/

            update ah;
        }

    }


    public Boolean validateEmail(String email){
    
    Boolean res = true;
    String emailRegex  = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
    List<String> emails = new List<String>();
   
    emails = email.split(';');
    
    Pattern MyPattern = Pattern.compile(emailRegex);
    Matcher MyMatcher = MyPattern.matcher(email);

    if (!MyMatcher.matches()) 
        res = false;
    return res; 
    }
    

    public String setLanguage(){
        System.debug('Selected Lang: '+templateLang);
        return templateLang;
    }


    public void fetchOppProds(){
         OppProducts = 
            [
                SELECT 
                    Id,
                    Name, Status__c,
                    Opportunity__c, Product__r.Name
                FROM
                    Opp_Product__c
                WHERE
                    Opportunity__c =:((Opportunity)thisOpp).Id 
                AND 
                    Status__c IN ('Won', 'Evaluation')

            ];  

            tada = OppProducts.isEmpty()?true:false;

    }


    public PageReference cancel() {

        PageReference pgRef = new PageReference('/' + thisOpp.Id);
        pgRef.setRedirect(true);
        return pgRef;
    }

    public PageReference refresh() {

        PageReference pgRef = ApexPages.currentPage();
        pgRef.setRedirect(true);
        return pgRef;
    }


    /*public PageReference getTranslatedEmail(){

        EmailTemplate emailTemplate = null;
        templateLang = templateLang==null?'_English':setLanguage();


        if(templateLang != null || templateLang!= ''){
            String keyword = 'Opp_Reminder_to_customer_HTML'+templateLang;
            System.debug('keyword:'+keyword);
            emailTemplate = [select Body, HtmlValue, Subject, DeveloperName, BrandTemplateId 
            from EmailTemplate where DeveloperName=: keyword limit 1];
        }

        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(EmailTemplateId, UserId, OpportunityId);
        email.setTargetObjectId(UserId);
        email.setSubject(email.getSubject());
        email.sethtmlBody(email.gethtmlBody());
        email.saveAsActivity = false;



    }*/


    public PageReference populateTemplate() {

        EmailTemplate emailTemplate = null;
        templateLang = templateLang==null?'_English':setLanguage();


        if(templateLang != null || templateLang!= ''){
            String keyword = 'Opp_Reminder_to_customer_HTML'+templateLang;
            System.debug('keyword:'+keyword);
            emailTemplate = [select Id, Body, HtmlValue, Subject, DeveloperName, BrandTemplateId 
            from EmailTemplate where DeveloperName=: keyword limit 1];
        }
        
        System.debug('primaryContact before: '+primaryContact);
       
        Messaging.SingleEmailMessage auxEmailMsg = new Messaging.SingleEmailMessage();
        auxEmailMsg.setTemplateId(emailTemplate.Id);
        auxEmailMsg.setSaveAsActivity(false);
        String[] toAddresses = new String[]{}; 
        toAddresses.add(( primaryContact != null)?primaryContact:'placeholder@email.field');
        System.debug('toAddresses:' + toAddresses);
        System.debug('primaryContact after: '+primaryContact);
        auxEmailMsg.setToAddresses(toAddresses);
        auxEmailMsg.setReplyTo(SUPPORT_EMAIL_ADDRESS); 
        auxEmailMsg.setWhatId(thisOpp.Id);

        Savepoint sp = Database.setSavepoint();

        Account auxAcct = new Account(Name='aux account');
        insert auxAcct;
        
        Contact auxContact        = new Contact(AccountId=auxAcct.Id);
        auxContact.FirstName      = 'First';
        auxContact.LastName       = 'Last';
        auxContact.Email          = 'nobody@nowhere.com';
        insert auxContact;

        auxEmailMsg.setTargetObjectId(auxContact.Id);    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {auxEmailMsg});

        Database.rollback(sp);
        
        /*Task t = new Task();
        t.OwnerId  = UserInfo.getUserId();
        t.WhatId   = thisOpp.Id;
        t.Status   = 'Completed';
        t.Type     = 'E-Mail';
        insert t;*/
        

        //emailMsg.BccAddress  = UserInfo.getUserEmail();
        emailMsg.Subject     = auxEmailMsg.getSubject();
        emailMsg.HtmlBody    = auxEmailMsg.getHTMLBody();
        //emailMsg.TextBody    = auxEmailMsg.getPlainTextBody();
        emailMsg.ToAddress   = auxEmailMsg.getToAddresses().get(0)=='placeholder@email.field'?'':auxEmailMsg.getToAddresses().get(0);
        //emailMsg.FromAddress = UserInfo.getUserEmail(); 
        emailMsg.CcAddress   = '';
        //emailMsg.ParentId    = null; //If you want to use case, otherwise no need.
        emailMsg.RelatedToId = thisOpp.Id;
        emailMsg.Status      = '3';
        
        return null;
    }
}
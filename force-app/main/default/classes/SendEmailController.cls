/*
    Name         : SendEmailController 
    Author       : PARX
    Date         : 14th Sept 2017
    Description  : This class update the Case status and New Mail. 
*/

public class SendEmailController {
   
    Private Case caseRec;
    public String caseId {get; set;}
    public List<SelectOption> fromOptionList {get; set;}
    public String toEmail {get; set;}
    public String cC {get; set;}
    public String bCc {get; set;}
    public String subject {get; set;}
    public String mailBody {get; set;}
    //public ActivityHistory mailBody {get; set;}
    public String selectedFrom {get; set;}
    public String userIdToEmailMap{get;set;}
    
    public SendEmailController(ApexPages.StandardController stdController) { 
        String toOrFrom = '';
        String sentOrSub = '';
        caseRec = (Case)stdController.getRecord();
        caseId = caseRec.Id;
        fromOptionList = new List<SelectOption>();
        cC = '';
        //bCc = '';
        toEmail = '';
        subject = '';
        mailBody = '';
        selectedFrom = '';
        
        bCc = UserInfo.getUserEmail();
        map<String,String> userMap = new map<String,String>();
        for(User usr : [Select Id, Name, Email from User where IsActive = true AND UserType = 'Standard']){
            userMap.put(usr.Id, usr.Email);
        }
        userIdToEmailMap = JSON.serialize(userMap);
      
        List<Case> caseActHisList = [SELECT (SELECT Description,Subject,CreatedDate from ActivityHistories ORDER BY ActivityDate DESC NULLS LAST, 
                                    LastModifiedDate DESC LIMIT 1) FROM Case where id = :caseId];
        Boolean flage = false;
        List<ActivityHistory> actHisList = caseActHisList[0].ActivityHistories;
        if(caseActHisList.size() > 0) {
        
            if(actHisList.size() > 0) {
                flage = true;
                String tempSubject;
                if(actHisList[0].Subject != null && actHisList[0].Subject != ''){
                    if(actHisList[0].Subject.contains('Email: ')){
                        subject = actHisList[0].Subject.substring(6);
                        tempSubject = subject;
                    }else{
                        subject = actHisList[0].Subject;
                        tempSubject = subject;
                    }
                }
                if(actHisList[0].Subject != '' && actHisList[0].Subject != null && actHisList[0].Description != '' && actHisList[0].Description != null){
                
                    sentOrSub = '<br/>' + 'Sent: ' + actHisList[0].CreatedDate + '<br/>' + 'Subject: ' + tempSubject  + '<br/>';
                    String mailBody1 = actHisList[0].Description;
                    mailBody1 = mailBody1.replace('\n','<br/>');
                    mailBody =  mailBody1.substring(mailBody1.indexOf('Body:')+5,mailBody1.length()); 
                }
                System.debug('## mailBody : ' + mailBody);
                if(mailBody.contains('ref:_') == false) {
                    String ref = generateRandomString(23);
                    mailBody += '<br/><br/><br/>' + 'ref:_' + ref + ':ref';
                }
            }
            else {
                if(mailBody.contains('ref:_') == false) {
                    String ref = generateRandomString(23);
                    mailBody += '<br/><br/><br/>' + 'ref:_' + ref + ':ref';
                }
            }
        }
        
        for(Users_Email__c usrEmail : [Select Id,User_And_Email__c from Users_Email__c]) {
            fromOptionList.add(new SelectOption(usrEmail.Id, usrEmail.User_And_Email__c));
        }
        
        String emailAdd = '';
        // Get Web Email field value for set in To text field
        List<Case> emailCaseLst = [SELECT SuppliedEmail,RecordType.Name,Temp_From__c,Temp_To__c FROM Case WHERE Id =:caseId];
        if(emailCaseLst.size() > 0) {
            
            if(emailCaseLst[0].RecordType.Name == 'Email Case') {
                if(emailCaseLst[0].SuppliedEmail != null && emailCaseLst[0].SuppliedEmail != ''){
                    //toEmail = emailCaseLst[0].SuppliedEmail;
                    
                    if(emailCaseLst[0].Temp_To__c != null && emailCaseLst[0].Temp_To__c != ''){
                        toEmail = emailCaseLst[0].Temp_To__c;    
                    }
                }else{
                    if(emailCaseLst[0].Temp_To__c != null && emailCaseLst[0].Temp_To__c != ''){
                        toEmail = emailCaseLst[0].Temp_To__c;
                    }
                }
                
                System.debug('## toEmail ' + toEmail);
                // Getting user name and email from custom setting
                List<Users_Email__c> selectedUserLst = [Select Id, User_And_Email__c,Email_Address__c from Users_Email__c where id =:emailCaseLst[0].Temp_From__c];
                
                System.debug('## slist : ' + selectedUserLst);
                if(selectedUserLst.size() > 0) {
                    emailAdd = selectedUserLst[0].User_And_Email__c + '[' + selectedUserLst[0].Email_Address__c + ']';
                }else{
                    emailAdd = emailCaseLst[0].Temp_From__c;
                }
                if(flage == true)
                    toOrFrom = '<br/><br/><br/>--------------- Original Message ---------------<br/>' + 'From: ' + emailAdd + '<br/>'+'To: ' + emailCaseLst[0].Temp_To__c + sentOrSub + '<br/>';
            }
        }
        
        mailBody = toOrFrom + mailBody;
        
        // calling javascript method 
        System.debug('## call parent call..');
        String s = '<script> callParent("sdfsd","sdfs","sdf"); </script>';
        System.debug('## return ..'+ s);
    }
    
    private static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz._';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
   
    public PageReference updateCaseStatus() {
        
        List<Case> caseRecordLst = [Select Id, status from Case where Id =:caseId];
        System.debug('## : ' + caseRecordLst);
     
        if(caseRecordLst.size() > 0) {
            caseRecordLst[0].status = 'Closed';
            update caseRecordLst;
        }
        
        return null;
    }
    
    public PageReference sendEmail() {
       
        sendMailForSpecificAddresses(toEmail, bCc, cC);
        List<Case> caseRec1 = [SELECT Temp_From__c,Temp_To__c FROM Case WHERE Id =:caseId];
        if(caseRec1.size() > 0) {
        
            caseRec1[0].Temp_From__c = selectedFrom;
            caseRec1[0].Temp_To__c = toEmail;
            update caseRec1;
        }
        return null;
    }
    
    private void sendMailForSpecificAddresses(String toAddress, String toBcc, String toCc) {
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        // Sets the paramaters of the email
    
        if(toAddress != null && toAddress != ''){
            
            List<String> lstString = toAddress.contains(',') ? toAddress.split(',') : new List<String>{toAddress};
            email.setToAddresses(lstString);
            
            if(toBcc != null && toBcc != '') {
                lstString = toBcc.contains(',') ? toBcc.split(',') : new List<String>{toBcc};
                email.setBccAddresses(lstString);
            }
            if(toCc != null && toCc != '') {
                lstString = toCc.contains(',') ? toCc.split(',') : new List<String>{toCc};
                email.setCcAddresses(lstString);
            }
            
            // email.setSubject(subject);
            mailBody = mailBody.unescapeHtml3(); //mailBody.replace('<br/>','');
            mailBody = mailBody.unescapeHtml4(); // mailBody.replace('<br />','');
            mailBody = mailBody.replace('<br />','');
            System.debug('## mailBody ' + mailBody );
          
            //  email.setPlainTextBody(mailBody); 
            Contact con = new Contact();
            con.LastName = 'test cone';
            con.email = lstString[0];
            con.Temp_Subject__c = subject;
            con.Temp_Body__c = mailBody;
            
            insert con;
            
            email.setSaveAsActivity(true);
            email.setWhatId(caseId);
            
            
            List<EmailTemplate> listTemp = [Select Id,Name from EmailTemplate where Name = 'Case Template'];
            if(listTemp.size() > 0){
                email.setTemplateID(listTemp[0].Id);
            }
            
            // email.setHtmlBody(mailBody);
            email.setTargetObjectId(con.Id); 
            
            System.debug('## selected : ' + selectedFrom);
        
            List<Users_Email__c> selectedUserLst = [Select Id,Email_Address__c from Users_Email__c where id =:selectedFrom];
            //   System.debug('## selectedUserLst.Email_Address__c : ' + selectedUserLst[0].Email_Address__c);
            if(selectedUserLst.size() > 0) {
                List<OrgWideEmailAddress> orgWideEmailAddressIdLst = [select Id,Address from OrgWideEmailAddress where Address =:selectedUserLst[0].Email_Address__c];
        
                //System.debug('## orgWideEmailAddressId.Id : ' + orgWideEmailAddressIdLst[0].Id);
                if(orgWideEmailAddressIdLst.size() > 0) {
                    email.setOrgWideEmailAddressId(orgWideEmailAddressIdLst[0].Id);
                }
            
                // Sends the email
                Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
                System.debug('## result ' + result);
            } 
            delete con;
        }
    }
}
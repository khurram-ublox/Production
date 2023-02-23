@isTest
private class TestSendOppReminderController{
    
static testMethod void oppReminderEmail() {


        
      
        Account a = new Account();
        a.Name = 'Test Account'; 
        a.BillingCity = 'Hartland'; 
        a.BillingState = 'WI'; 
        a.BillingCountry = 'US'; 
        a.BillingPostalCode = '55009'; 
        a.BillingStreet = '1234 First St.';
        insert a;
        
        
        Contact c = new Contact();
        c.FirstName = 'Unit'; 
        c.LastName = 'Test'; 
        c.Email = 'non@non.com'; 
        c.AccountId = a.Id;
        insert c;

              
       
        Opportunity o = new Opportunity();
        o.AccountId = a.Id; 
        o.Name = 'Test Opp'; 
        o.CurrencyIsoCode = 'EUR'; 
        o.Annual_Quantity__c = 10; 
        o.StageName = '8 Production'; 
        o.Application_Type__c = 'Mobile phone'; 
        o.Market__c = 'Industrial'; 
        o.CloseDate = System.today();
        insert o;


        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = c.Id;
        ocr.OpportunityId = o.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        insert ocr;

        List<OrgWideEmailAddress> owea = [Select DisplayName, Address From OrgWideEmailAddress Where DisplayName='none' limit 1];
        if(owea.isEmpty()){
            owea = [Select DisplayName, Address From OrgWideEmailAddress limit 1];
        }
        /*owea.DisplayName = 'info';
        owea.address = 'info@info.com';
        insert owea;*/


        List<OpportunityContactRole> OppConRoles = [Select ContactId, OpportunityId, IsPrimary, Role From OpportunityContactRole Where Role='Decision Maker'];
        List<Opp_Product__c> OppProds = new List<Opp_Product__c>(); 
        System.assertEquals(1, OppConRoles.size());

      
      
        String templateLang = '';
        Boolean emailValidity = false;

        
        // Go to our page
        PageReference pageRef = Page.Opp_reminder;
        
        // Create the controller
        SendOppReminderController controller = new SendOppReminderController(new ApexPages.StandardController(o));
   
        
        // call the template
        pageRef = controller.populateTemplate(); 


        //validate email
        emailValidity = controller.validateEmail('non@non.com');


        //fetch OppProds
        controller.fetchOppProds();

        //set language
        templateLang = controller.setLanguage();

        // send the email
        pageRef = controller.send();

               
        // cancel it
        pageRef = controller.cancel();

        //refresh it
        pageRef = controller.refresh();

    }

    
}
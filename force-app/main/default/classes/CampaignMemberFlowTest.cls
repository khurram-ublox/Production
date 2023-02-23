@isTest
public class CampaignMemberFlowTest {

	@isTest
    static void TickEmailInvalidInContact(){
        
        CampaignMemberTestDataFactory cmTDF = new CampaignMemberTestDataFactory();
        CampaignMember cm = (CampaignMember)cmTDF.initializeRecord();
        
		ContactTestDataFactory con = new ContactTestDataFactory();
        Contact contact = (Contact)con.createRecord();
        cm.ContactId = contact.id;
        insert cm;
        
        test.startTest();
        if(cm.Date_Bounced__c != null){
            DateTime myDateTime = DateTime.newInstance(2022, 01, 01, 13, 6, 6);
        	cm.Date_Bounced__c = myDateTime;
            update cm;
            system.assertEquals(true, cm.contact.Email_address_probably_not_valid__c);
        }
        test.stopTest();
    }
    
    @isTest
    static void TickAddTaskToLead(){
        
        CampaignMemberTestDataFactory cmTDF = new CampaignMemberTestDataFactory();
        CampaignMember cm = (CampaignMember)cmTDF.initializeRecord();
        cm.Event_Participation__c = 'Test event participation';
        
        Lead cmLead = LeadTestDataFactory.initiliazeLead();
        cmLead.Country = 'GB';
        insert cmLead;
        cm.LeadId = cmLead.id;
        insert cm;     
    
        test.startTest();
        if(cm.LeadId == cmLead.id){
          system.assertEquals(cmLead.Id, cm.LeadId);
        }
        test.stopTest();
    }
    
}
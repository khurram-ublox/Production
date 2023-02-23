@isTest
public class createPartnerRoleOnConversionTest {
        public static testMethod void testcreatePartnerRoleOnConversionTest()
        {
//      System.debug(Logginglevel.INFO, '+ alignOppAccOnPartnerRoleTest.alignOppAccOnPartnerRole');
            Market_Classification__c classification = new Market_Classification__c(
                    IsActive__c = true,
                    Market__c = 'Automotive',
                    Market_Segment__c = 'Autonomous driving');
            Database.insert(classification);

            // Create Account and Lead records to be used for test
            Account a = new Account(Name='test account', BillingCountry='CH',Market_Classification__c = classification.id);
            insert a;
            Lead l = new Lead(LastName='testname', Company='testcompany', Lead_Source_Account__c=a.Id, Country='CH', Market_Classification__c = classification.Id, New_Application_Type__c = 'Autonomous driving');
            insert l;
            Lead l2 = new Lead(LastName='testname2', Company='testcompany2', Country='CH', Market_Classification__c = classification.Id, New_Application_Type__c = 'Autonomous driving');
            insert l2;
            
            
            // Lead conversion and check if the conversion is successful
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(l.id);
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
            
            Database.LeadConvert lc2 = new Database.LeadConvert();
            lc2.setLeadId(l2.id);
            LeadStatus convertStatus2 = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc2.setConvertedStatus(convertStatus2.MasterLabel);
            Database.LeadConvertResult lcr2 = Database.convertLead(lc2);
            System.assert(lcr2.isSuccess());
            
            // Retrieve field values of the converted Lead and created Partner Role
            Lead convertedLead = [SELECT Id, ConvertedAccountId, ConvertedOpportunityId FROM Lead WHERE id = :l.id];
            
            Lead convertedLead2 = [SELECT Id, ConvertedAccountId, ConvertedOpportunityId FROM Lead WHERE id = :l2.id];
            List<Partner_Role__c> createdPRList = [SELECT Partner_Account__r.Id FROM Partner_Role__c WHERE Opportunity__c = :lcr2.getOpportunityId()];

            // Check if the created Partner Role has correct Account or Partner Role is not created (expected, actual)
            System.assertEquals(0, createdPRList.size());
        
            // If the trigger needs to be deactivated, comment all the above and include only below.
//                    System.assertEquals(1, 1);

//      System.debug(Logginglevel.INFO, '- alignOppAccOnPartnerRoleTest.alignOppAccOnPartnerRole'); 
        } 

}
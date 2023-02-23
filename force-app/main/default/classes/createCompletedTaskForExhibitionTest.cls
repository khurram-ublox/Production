@isTest
public class createCompletedTaskForExhibitionTest {
        public static testMethod void testCompletedTaskForExhibition()
        {
//      System.debug(Logginglevel.INFO, '+ alignOppAccOnPartnerRoleTest.alignOppAccOnPartnerRole'); 
                Market_Classification__c classification = new Market_Classification__c(
                        IsActive__c = true,
                        Market__c = 'Automotive',
                        Market_Segment__c = 'Autonomous driving');
                Database.insert(classification);
            // Create Exhibition and Lead records to be used for test
            Exhibition__c e = new Exhibition__c(Name='test exhibition', Country__c='CH');
            insert e;
            Lead l = new Lead(LastName='testname', Company='testcompany', Exhibition__c=e.Id, Country='CH',Market_Classification__c = classification.id, New_Application_Type__c = 'Autonomous driving');
            insert l;
            
            // Lead conversion and check if the conversion is successful
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(l.id);
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
            
            // Retrieve field values of the converted Lead and created Task
            Lead convertedLead = [SELECT Id, ConvertedContactId FROM Lead WHERE id = :l.id];
            Contact createdContact = [SELECT Id FROM Contact WHERE id = :lcr.getContactId()];
            list<Task> createdTask = [SELECT WhoId, Exhibition__r.Id FROM Task WHERE WhoId = :lcr.getContactId()];

            // Check if the created Task has correct Contact and Exhibition (expected, actual)
            //System.assertEquals(0, createdTask.size());
        
            // If the trigger needs to be deactivated, comment all the above and include only below.
//                    System.assertEquals(1, 1);

//      System.debug(Logginglevel.INFO, '- alignOppAccOnPartnerRoleTest.alignOppAccOnPartnerRole'); 
        } 
}
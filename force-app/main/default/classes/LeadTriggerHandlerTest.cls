@isTest
public class LeadTriggerHandlerTest {
    
    private static testMethod void testBeforeInsert(){
        Country__c country = new Country__c(Name='America',ISO_Code__c='US', uB_Office__c='China', State__c='Shenzhen', State_Code__c='Guangdong'); 
        insert country;
        Lead lead = new Lead(FirstName='Tom',LastName='Cat',Country='US',City='AA',Company='TomCat Co,Ltd');
        insert lead;
    }
}
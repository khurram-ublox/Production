/**
 * Created by wsha on 4/10/2018.
 * No needed. To be deleted!
 */

@IsTest
private class Test_AutopilotStreamAssociation {
	// 
    static testMethod void general() {
        System.assertEquals(true, true);
    }

    // static testMethod void testGetStreamEmails() {
    //     List<Autopilot_Stream__c> listAps = new List<Autopilot_Stream__c>();
    //     List<String>streamEmails = new List<String>();
    //     for(Integer i=0; i<2000; i++){
    //         Autopilot_Stream__c aps = new Autopilot_Stream__c();
    //         aps.actor_email__c = 'Mebb'+i+'@internet.com';
    //         listAps.add(aps);
    //     }

    //     insert listAps;

    //     for(Autopilot_Stream__c s : listAps){
    //         streamEmails.add(s.actor_email__c);
    //     }

    //     Test.startTest();
    //     Map<Id, Autopilot_Stream__c> sMap = new Map<Id, Autopilot_Stream__c>([SELECT Id, actor_email__c FROM Autopilot_Stream__c WHERE actor_email__c!=NULL AND mark_as_read__c = false AND actor_email__c =: streamEmails LIMIT 5000]);
    //     Test.stopTest();

    //     System.assertEquals(listAps.size(), sMap.size());

    // }

//     static testMethod void testGetContactEmails(){

//         List<Autopilot_Stream__c> listAps = new List<Autopilot_Stream__c>();
//         List<String>streamEmails = new List<String>();
//         for(Integer i=0; i<2000; i++){
//             Autopilot_Stream__c aps = new Autopilot_Stream__c();
//             aps.actor_email__c = 'Mebb'+i+'@internet.com';
//             listAps.add(aps);
//         }

//         insert listAps;

//         for(Autopilot_Stream__c s : listAps){
//             streamEmails.add(s.actor_email__c);
//         }


//         List<Contact> listCon = new List<Contact>();
//         List<String>conEmails = new List<String>();
//         for(Integer i=0; i<2000; i++) {
//             Contact c = new Contact();
//             c.FirstName = 'Mebb'+i;
//             c.LastName = 'Keflezghi';
//             c.Email = 'Mebb'+i+'@internet.com';
//             listCon.add(c);
//         }
//         insert listCon;

//         for(Contact c : listCon){
//             conEmails.add(c.Email);
//         }

//         Test.startTest();
//         Map<Id, Contact> cMap = new Map<Id, Contact>([SELECT Id, Email FROM Contact WHERE Email =: streamEmails]);
//         Test.stopTest();

//         System.assertEquals(listCon.size(), cMap.size());

//     }

//     static testMethod void testGetLeadEmails(){

//         List<Autopilot_Stream__c> listAps = new List<Autopilot_Stream__c>();
//         List<String>streamEmails = new List<String>();
//         for(Integer i=0; i<2000; i++){
//             Autopilot_Stream__c aps = new Autopilot_Stream__c();
//             aps.actor_email__c = 'Mebb'+i+'@internet.com';
//             listAps.add(aps);
//         }

//         insert listAps;

//         for(Autopilot_Stream__c s : listAps){
//             streamEmails.add(s.actor_email__c);
//         }


//         List<Lead> listLead = new List<Lead>();
//         List<String>leadEmails = new List<String>();
//         for(Integer i=0; i<2000; i++) {
//             Lead l = new Lead();
//             l.FirstName = 'Mebb'+i;
//             l.LastName = 'Keflezghi';
//             l.Country = 'GB';
//             l.Company = 'Test Company';
//             l.Email = 'Mebb'+i+'@internet.com';
//             listLead.add(l);
//         }
//         insert listLead;

//         for(Lead l : listLead){
//             leadEmails.add(l.Email);
//         }

//         Test.startTest();
//         Map<Id, Lead> lMap = new Map<Id, Lead>([SELECT Id, Email FROM Lead WHERE Email =: streamEmails]);
//         Test.stopTest();

//         System.assertEquals(listLead.size(), lMap.size());

//     }

//     static testMethod void testGetStreamAssociation(){

//         //Map<Id, Autopilot_Stream__c> mapOfConEmailsInStream = new Map<Id, Autopilot_Stream__c>([SELECT Id, actor_email__c FROM Autopilot_Stream__c WHERE actor_email__c =: conEmails]);
//         Map<Id, SObject> collectionOfLeadAndCon = new Map<Id, SObject>();
//         Map<Id, Autopilot_Stream__c> filteredStreamAssociationMap = new Map<Id, Autopilot_Stream__c>();

//         List<Autopilot_Stream__c> listAps = new List<Autopilot_Stream__c>();
//         List<String>streamEmails = new List<String>();
//         List<String> actions = new List<String>{'email.sent', 'email.opened', 'email.clicked', 'email.deferred'};
//         for(Integer i=0; i<400; i++){
//             Autopilot_Stream__c aps = new Autopilot_Stream__c();
//             aps.actor_email__c = 'Mebb'+i+'@internet.com';
//             aps.journey_id__c = 'abcdefghijkl12345';
//             aps.activity_id__c = 'ijklmnsudh12345o';
//             aps.object_id__c = 'asdfbydj928462';
//             aps.action__c = actions.get((Integer)Math.random());
//             aps.ingest_time__c = String.valueOf(Datetime.now());
//             aps.timestamp__c = String.valueOf(Datetime.now());
//             listAps.add(aps);
//         }

//         insert listAps;

//         for(Autopilot_Stream__c s : listAps){
//             streamEmails.add(s.actor_email__c);
//         }


//         List<Contact> listCon = new List<Contact>();
//         List<String>conEmails = new List<String>();
//         for(Integer i=0; i<200; i++) {
//             Contact c = new Contact();
//             c.FirstName = 'Mebb'+i;
//             c.LastName = 'Keflezghi';
//             c.Email = 'Mebb'+i+'@internet.com';
//             listCon.add(c);
//         }
//         insert listCon;

//         for(Contact c : listCon){
//             conEmails.add(c.Email);
//         }

//         List<Lead> listLead = new List<Lead>();
//         List<String>leadEmails = new List<String>();
//         for(Integer i=0; i<200; i++) {
//             Lead l = new Lead();
//             l.FirstName = 'Mebb'+i;
//             l.LastName = 'Keflezghi';
//             l.Country = 'GB';
//             l.Company = 'Test Company';
//             l.Email = 'Mebb'+i+'@internet.com';
//             listLead.add(l);
//         }
//         insert listLead;

//         for(Lead l : listLead){
//             leadEmails.add(l.Email);
//         }
// /*
//         AutopilotStreamAssociation association = new AutopilotStreamAssociation();
//         List<Autopilot_Email_Result__c> listER = new List<Autopilot_Email_Result__c>();
//         listER = association.getStreamData();

//         Database.SaveResult[] srList = Database.insert(listER, false);
//         for(Database.SaveResult sr : srList){
//             if(sr.isSuccess()){
//                 System.debug('Yayy!');
//             }else{
//                 for (Database.Error err : sr.getErrors()){
//                     System.debug(err.getStatusCode()+'-'+'-'+err.getFields());
//                     System.assert(err.getFields().isEmpty());
//                 }
//             }
//         }*/


//         Test.startTest();
//         Set<Id> sIds = new Set<Id>();
//         AutopilotStreamAssociation association = new AutopilotStreamAssociation();
//         filteredStreamAssociationMap = association.getStreamAssociation();
//         Map<Id, Autopilot_Stream__c> getMapOfLeadEmailsFromStream = new Map<Id, Autopilot_Stream__c>();
//         getMapOfLeadEmailsFromStream = association.getMapOfLeadEmailsFromStream();
//         sIds = association.getStreamIds();

//         List<Autopilot_Email_Result__c> listER = new List<Autopilot_Email_Result__c>();
//         listER = association.getStreamData();

//         Database.SaveResult[] results = Database.insert(listER, false);


//         /*Database.SaveResult[] srList = Database.insert(listER, false);
//         for(Database.SaveResult sr : srList){
//             if(sr.isSuccess()){
//                 System.debug('Hurrah!');
//             }else{
//                 for (Database.Error err : sr.getErrors()){
//                     System.debug(err.getStatusCode()+'-'+'-'+err.getFields());
//                 }
//             }
//         }*/

//         Test.stopTest();

//         //System.assertEquals(400, [Select Count() From Autopilot_Email_Result__c]);
//         System.assert(sIds.size()!=NULL);
//         System.assertEquals(listER.size(), listAps.size());
//         System.assert(getMapOfLeadEmailsFromStream.size()>0);
//         System.assert(!filteredStreamAssociationMap.isEmpty());

//     }



}
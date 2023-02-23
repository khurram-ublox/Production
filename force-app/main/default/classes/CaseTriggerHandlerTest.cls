@isTest
public class CaseTriggerHandlerTest {
    private static testMethod void testAfterupdate(){
        Account acc = new Account(Name = 'testclass accname');
        insert acc;
        
        Contact con= new Contact();
        con.LastName = 'testclass conname';
        con.AccountId = acc.id;
        insert con;
        
        Contact con2= new Contact();
        con2.LastName = 'testclass conname2';
        con2.AccountId = acc.id;
        insert con2;
        
        Task addtask = new Task();
        //LastName
        addtask.Subject = 'testclass subject';
        insert addtask;        
        
        Case addcase = new Case();
        Id caseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Legal Case').getRecordTypeId();
        addcase.Subject = 'testclass subj';
        addcase.AccountId = acc.id;
        addcase.contactId = con.id;
        addcase.RecordTypeId = caseRecType;
        insert addcase;
        
        addcase.contactId = con2.id;
		test.startTest();
        update addcase;
        test.stopTest();
        
        
    }
}
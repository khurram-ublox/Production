@isTest
public class ContactObjectHandlerTest {
	@isTest static void updateSubscriptionFieldTest() {
        Test.startTest();
        ContactTestDataFactory factory = new ContactTestDataFactory();
        Contact c = (Contact)factory.createRecord();
        Id contactId = ContactObjectHandler.updateSubscriptionField(c.id);
        System.assertEquals(contactId, c.id);
        Test.stopTest();
    }
}
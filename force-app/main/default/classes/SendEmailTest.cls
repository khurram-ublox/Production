@isTest
public class SendEmailTest {
    
	@isTest static void test(){
        Boolean emailToAdmin = SendEmail.toAdmin('subject','text');
        System.assertEquals(emailToAdmin, true, 'Test did not pass.');
        
        Boolean emailToEmail = SendEmail.toEmail('sami.azam@u-blox.com','subject','text');
        System.assertEquals(emailToEmail, true, 'Test did not pass.');
    }   
}
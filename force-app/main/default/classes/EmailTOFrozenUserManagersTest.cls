@istest 
public class EmailTOFrozenUserManagersTest {
    @istest
    public static void  EmailTOFrozenUserManagersTest1() {
        
        Test.StartTest();
        EmailTOFrozenUserManagers sh1 = new EmailTOFrozenUserManagers();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
        
    }
}
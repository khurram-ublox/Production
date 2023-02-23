@IsTest
private class AssistNowDeleteCtrlTest{
    public static TestMethod void test(){           
      Contact c=new Contact();
      c.LastName='sumit singh';
      insert c;
      AssistNowDeleteCtrl.checkToken(c.id);
      Id cId = AssistNowDeleteCtrl.deleteToken(c.id);
      System.assertEquals(c.Id, cId);  
    }
}
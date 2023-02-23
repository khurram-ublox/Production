@IsTest
private class UpdateOpportunitiesVFCtrlTest {     
    public static TestMethod void test(){
     Product2 product= new Product2();
     product.Name='test'; 
     product.Type_No__c='aaa';
     insert product;
     ApexPages.StandardController stdController= new ApexPages.StandardController(product);   
     UpdateOpportunitiesVFCtrl con= new UpdateOpportunitiesVFCtrl(stdController);             
     }
}
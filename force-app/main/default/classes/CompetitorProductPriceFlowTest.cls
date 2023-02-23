/*
Test class for flow.
Obj: "Competitor_Product_Price__c"
Flow: "Competitor Product Price: After Create / Update"
*/

@isTest
public class CompetitorProductPriceFlowTest {

	@isTest
    static void TestHasOpportunity(){
        
        CompetitorProductPriceTestDataFactory cppTDF = new CompetitorProductPriceTestDataFactory();
        Competitor_Product_Price__c cpp = (Competitor_Product_Price__c)cppTDF.createRecord();

        AccountTestDataFactory accCpp = new AccountTestDataFactory();
        Account acc = (Account)accCpp.createRecord();
        
        test.startTest();
        if(cpp.Opp_Product__c != null){
            system.assertEquals(cpp.Account__c, acc.id);
        }
        test.stopTest();
        
    }
    
    @isTest
    static void TestPriceInfoDateTODAY(){
   		CompetitorProductPriceTestDataFactory cppTDF = new CompetitorProductPriceTestDataFactory();
        Competitor_Product_Price__c cpp = (Competitor_Product_Price__c)cppTDF.createRecord();
		        
		test.startTest();
        if(cpp.Price_Information_Date__c == null){
            System.assertEquals(Date.today(), cpp.Price_Information_Date__c);
        }
        test.stopTest();
        
    }



}
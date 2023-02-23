@IsTest
public class SPRFlowTest {
/*
Flow Name: SPR: Before Insert/Update
*/    
    
    @isTest
	static void TestClearApprovalMSPRegionalHead(){
        
		SPRTestDataFactory inst = new SPRTestDataFactory();
        UserTestDataFactory testuser = new UserTestDataFactory();
        User u_atan = (User)testuser.createRecord();
        
        test.startTest();
        
        System.runAs(u_atan) {
        	sObject sprrecord = inst.createRecord();
			Special_Price_Request__c spr = [SELECT Price_Level__c, 
                                            Status__c, 
                                            Approved_By_Team_Leader__c, 
                                            Approved_By_Team_Manager__c, 
                                            Approved_By_Regional_Head__c 
                                            FROM Special_Price_Request__c Where Id=:sprrecord.id];             
            spr.Price_Level__c= 'PPP (Project Price Plan)';
			spr.Status__c = 'Approved';
            spr.Approved_By_Team_Leader__c = false;
            spr.Approved_By_Team_Manager__c = false;
            spr.Approved_By_Regional_Head__c = true;
            update spr;   
    }
        test.stopTest();
    }
    @isTest
    static void TestFillPricesValidUntilPrevious(){

		SPRTestDataFactory inst = new SPRTestDataFactory();
		sObject sprrecord = inst.createRecord();
        test.startTest();
        if(sprrecord.id !=null ){
			Special_Price_Request__c spr = [SELECT Prices_Valid_Until__c, 
                                            Prices_Valid_Until_Previous__c
                                            FROM Special_Price_Request__c Where Id=:sprrecord.id];
			spr.Prices_Valid_Until_Previous__c = spr.Prices_Valid_Until__c;
            update spr;   
        }
        test.stopTest();
        
    }
	@isTest
	static void TestApproveMSPasCM(){
   		SPRTestDataFactory inst = new SPRTestDataFactory();

        Special_Price_Request__c sprrecord = (Special_Price_Request__c)inst.initializeRecord();        
        sprrecord.Price_Level__c = 'MSP (Minimum Sales Price)';
        insert sprrecord;
                 
        UserTestDataFactory testuser = new UserTestDataFactory();
		User u_tnak = (User)testuser.initializeRecord();
        //User u_tnak = inst.initializeuser();
        u_tnak.Alias = 'tnak';
        u_tnak.Username = 'u_tnak@testorg.com';
        insert u_tnak;
        
        test.startTest();
        System.runAs(u_tnak) {
            Special_Price_Request__c spr = [SELECT Price_Level__c, 
                                            Approved_By_Team_Manager__c,
                                            Date_Approved_By_Team_Manager__c,
                                            Status__c
                                            FROM Special_Price_Request__c Where Id=:sprrecord.id];
            
            
            if(spr.Price_Level__c == 'MSP (Minimum Sales Price)'){
				spr.Approved_By_Team_Manager__c = true;
                spr.Date_Approved_By_Team_Manager__c = spr.Date_Approved_By_Team_Manager__c;
                spr.Status__c = 'Approved';
                update spr;
            }
        }
        test.stopTest();
    }
    @isTest
    static void TestApproveMSPasRegionalHead(){
        SPRTestDataFactory inst = new SPRTestDataFactory();
        
		UserTestDataFactory testuser = new UserTestDataFactory();
        User u_atan = (User)testuser.createRecord();
        //User u_atan = inst.createUser();
        
        Special_Price_Request__c sprrecord = (Special_Price_Request__c)inst.initializeRecord();        
        sprrecord.Price_Level__c = 'MSP (Minimum Sales Price)';
        insert sprrecord;
        
        test.startTest();
       	System.runAs(u_atan) {
        Special_Price_Request__c spr = [SELECT Price_Level__c, 
                                            Date_Approved_By_Regional_Head__c,
                                        	Date_Approved_By_Team_Manager__c,
                                        	Approved_By_Regional_Head__c,
                                            Status__c
                                            FROM Special_Price_Request__c Where Id=:sprrecord.id];
            
      	if(spr.Price_Level__c == 'MSP (Minimum Sales Price)'){
			spr.Approved_By_Regional_Head__c = true;
            spr.Date_Approved_By_Regional_Head__c = spr.Date_Approved_By_Team_Manager__c;
            spr.Status__c = 'Approved';
            update spr;
            }
        }
        test.stopTest();
        
    }
    
    
/*
Flow Name: SPR: After insert/update
*/
    
    @isTest
    static void TestAddEmailPSAll(){
    	SPRTestDataFactory inst = new SPRTestDataFactory();
		Special_Price_Request__c spr = (Special_Price_Request__c)inst.initializeRecord();
		insert spr;
		//spr.CreatedDate = '2020/12/12';   // Not writeable field 
		// Total_Quantity__c is sum of Total Quantity P1+P2+P3+P4+P5
        //spr.Total_Quantity_P1__c = 0;
        //spr.Total_Quantity_P2__c = 0;
        //spr.Total_Quantity_P3__c = 0;
        //spr.Total_Quantity_P4__c = 0;
        //spr.Total_Quantity_P5__c = 0;
		
        test.startTest();
        	if(spr.Price_Level__c == 'PPP (Project Price Plan)' && spr.Total_Quantity__c == 0 && spr.CreatedDate != spr.LastModifiedDate){
            	spr.Email_PS_CEL__c = 'stefano.moioli@u-blox.com';
                spr.Email_PS_POS__c = 'Peter.Fairhurst@u-blox.com';
                spr.Email_PS_SHO__c = 'hakan.svegerud@u-blox.com';
                update spr;
        	}
        test.stopTest();
    }
    @isTest
    static void TestAddEmailPSCELdecision(){
        SPRTestDataFactory inst = new SPRTestDataFactory();
		Special_Price_Request__c spr = (Special_Price_Request__c)inst.initializeRecord();
		insert spr;
        
        test.startTest();
        if(spr.Price_Level__c == 'PPP (Project Price Plan)' && spr.Total_Quantity__c>0){
            spr.Email_PS_CEL__c = 'stefano.moioli@u-blox.com';          
        }
        test.stopTest();
    }
    @isTest
    static void TestAddEmailPSPOS(){
        SPRTestDataFactory inst = new SPRTestDataFactory();
		Special_Price_Request__c spr = (Special_Price_Request__c)inst.initializeRecord();
		insert spr;
        
        test.startTest();
        if(spr.Price_Level__c == 'PPP (Project Price Plan)' && spr.Total_Quantity_POS__c > 0 ){
        	spr.Email_PS_POS__c = 'Peter.Fairhurst@u-blox.com';
        }
        test.stopTest();
    }
    @isTest
    static void TestAddEmailPSSHO(){
        SPRTestDataFactory inst = new SPRTestDataFactory();
		Special_Price_Request__c spr = (Special_Price_Request__c)inst.initializeRecord();
		insert spr;
        
        test.startTest();
        if(spr.Price_Level__c == 'PPP (Project Price Plan)' && spr.Total_Quantity_SHO__c > 0 ){
            spr.Email_PS_SHO__c = 'hakan.svegerud@u-blox.com';
        }
        test.stopTest();
    }
    @isTest
    static void TestRemoveEmailPSCEL(){
        SPRTestDataFactory inst = new SPRTestDataFactory();
		Special_Price_Request__c spr = (Special_Price_Request__c)inst.initializeRecord();
		insert spr;
        
        Test.startTest();
        if(spr.Price_Level__c == 'PPP (Project Price Plan)' && spr.Total_Quantity_CEL__c == 0 &&  spr.Total_Quantity__c > 0){
            spr.Email_PS_CEL__c = '';
        }
        test.stopTest();
    }
    @isTest
    static void TestRemoveEmailPSPOS(){
        SPRTestDataFactory inst = new SPRTestDataFactory();
		Special_Price_Request__c spr = (Special_Price_Request__c)inst.initializeRecord();
		insert spr;
        
        Test.startTest();
        if(spr.Price_Level__c == 'PPP (Project Price Plan)' && spr.Total_Quantity_POS__c == 0 &&  spr.Total_Quantity__c > 0){
            spr.Email_PS_POS__c = '';
        }
        test.stopTest();
    }
    @isTest
    static void TestRemoveEmailPSSHO(){
        SPRTestDataFactory inst = new SPRTestDataFactory();
		Special_Price_Request__c spr = (Special_Price_Request__c)inst.initializeRecord();
		insert spr;
     
        Test.startTest();
        if(spr.Price_Level__c == 'PPP (Project Price Plan)' &&  spr.Total_Quantity_SHO__c == 0 && spr.Total_Quantity__c > 0){
            spr.Email_PS_SHO__c = '';
        }
        test.stopTest();
    }
    
}
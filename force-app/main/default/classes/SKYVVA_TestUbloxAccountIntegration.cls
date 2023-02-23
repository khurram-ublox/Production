public class SKYVVA_TestUbloxAccountIntegration {
    
    /*#1040, 08-May-2014, No need bzc City, State ZipCode are comming separated fields*/
    
    static Set<String> setName=new Set<String>{'Tiger','Alcohol Countermeasure Sustems Corp','TATTILE SRL','Linkabit-NY'};        
    static List<Account> listAcc;
    
    static List<Map<String,String>> lstMapAcc=new List<Map<String,String>>();
    
    static {

        Map<String,String> mapStringAcc;
    
       mapStringAcc= new Map<String,String>();
                           mapStringAcc.put('CustomerNumber','ACC1');
                           mapStringAcc.put('RegionalOfficeCode','1');
                           mapStringAcc.put('CompanyName','Tiger');
                           mapStringAcc.put('NameExtension1','addr1');
                           //mapStringAcc.put('NameExtension2','');
                           mapStringAcc.put('Address','addr');
                           mapStringAcc.put('AddressExtension','addr ext');
                           mapStringAcc.put('CountryCode','US');
                           mapStringAcc.put('ZipCode','AC1');
                           mapStringAcc.put('City','Armed Forces Americas');
                           mapStringAcc.put('MainNumber','1111');
                           mapStringAcc.put('Fax','111');
                           mapStringAcc.put('CurrencyIso','USD');
                           mapStringAcc.put('PaymentTerms','30 Tage');
                           mapStringAcc.put('InsuranceNumber','123');
                           mapStringAcc.put('InsuranceCurrency','USD');
                           mapStringAcc.put('CreditLineInsurance','123');
                           mapStringAcc.put('CreditLineUblox','50');
                           mapStringAcc.put('CreditLineEffectiveDate','12-12-2008');
                           mapStringAcc.put('CreditLineProlongation','12-12-2009');                                                      
                           mapStringAcc.put('CreditLineEndDate','12-12-2010'); 
                           mapStringAcc.put('InsuranceRemarks','Remark1');
                           lstMapAcc.add(mapStringAcc);
                           
       mapStringAcc= new Map<String,String>();
                           mapStringAcc.put('CustomerNumber','ACC2');
                           mapStringAcc.put('RegionalOfficeCode','2');
                           mapStringAcc.put('CompanyName','Alcohol Countermeasure Sustems Corp');
                           //mapStringAcc.put('NameExtension1','');
                           mapStringAcc.put('NameExtension2','addr2');
                           mapStringAcc.put('Address','addr');
                           mapStringAcc.put('AddressExtension','addr ext');
                           mapStringAcc.put('CountryCode','CA');
                           //mapStringAcc.put('ZipCode','');
                           //??mapStringAcc.put('City','Toronto,  Ontario  M9W 6J2');
                           //8-May-2014
                           mapStringAcc.put('City','Toronto');
                           mapStringAcc.put('State','Ontario');
                           mapStringAcc.put('ZipCode','M9W 6J2');
                           
                           mapStringAcc.put('MainNumber','2222');
                           mapStringAcc.put('Fax','222');
                           mapStringAcc.put('CurrencyIso','USD');
                           mapStringAcc.put('PaymentTerms','Vorauskasse');
                           mapStringAcc.put('InsuranceNumber','123');
                           mapStringAcc.put('InsuranceCurrency','USD');
                           mapStringAcc.put('CreditLineInsurance','0');
                           mapStringAcc.put('CreditLineUblox','0');
                           mapStringAcc.put('CreditLineEffectiveDate','12-12-2008');
                           mapStringAcc.put('CreditLineProlongation','12-12-2009');                                                      
                           mapStringAcc.put('CreditLineEndDate','12-12-2010'); 
                           mapStringAcc.put('InsuranceRemarks','Remark2');                                                     
                           lstMapAcc.add(mapStringAcc);

       mapStringAcc= new Map<String,String>();
                           mapStringAcc.put('CustomerNumber','ACC3');
                           mapStringAcc.put('RegionalOfficeCode','3');
                           mapStringAcc.put('CompanyName','TATTILE SRL');
                           mapStringAcc.put('NameExtension1','addr1');
                           mapStringAcc.put('NameExtension2','addr2');
                           mapStringAcc.put('Address','addr');
                           //mapStringAcc.put('AddressExtension','');
                           mapStringAcc.put('CountryCode','US');
                           mapStringAcc.put('ZipCode','AC3');
                           mapStringAcc.put('City','California');
                           mapStringAcc.put('MainNumber','3333');
                           mapStringAcc.put('Fax','333');
                           mapStringAcc.put('CurrencyIso','USD');
                           mapStringAcc.put('PaymentTerms','Vorauskasse');
                           mapStringAcc.put('InsuranceNumber','123');
                           mapStringAcc.put('InsuranceCurrency','EUR');
                           mapStringAcc.put('CreditLineInsurance','0');
                           mapStringAcc.put('CreditLineUblox','0');
                           mapStringAcc.put('CreditLineEffectiveDate','12-12-2008');
                           mapStringAcc.put('CreditLineProlongation','12-12-2009');                                                      
                           mapStringAcc.put('CreditLineEndDate','12-12-2010'); 
                           mapStringAcc.put('InsuranceRemarks','Remark3');                                                       
                           lstMapAcc.add(mapStringAcc);

       mapStringAcc= new Map<String,String>();
                           mapStringAcc.put('CustomerNumber','ACC4');
                           mapStringAcc.put('RegionalOfficeCode','4');
                           mapStringAcc.put('CompanyName','Linkabit-NY');
                           mapStringAcc.put('NameExtension1','addr1');
                           mapStringAcc.put('NameExtension2','addr2');
                           //mapStringAcc.put('Address','');
                           mapStringAcc.put('AddressExtension','addr ext');
                           mapStringAcc.put('CountryCode','CA');
                           mapStringAcc.put('ZipCode','AC4');
                           mapStringAcc.put('City','Yukon');
                           mapStringAcc.put('MainNumber','4444');
                           mapStringAcc.put('Fax','444');
                           mapStringAcc.put('CurrencyIso','EUR');
                           mapStringAcc.put('PaymentTerms','30 Tage ACC4');
                           mapStringAcc.put('InsuranceNumber','123');
                           mapStringAcc.put('InsuranceCurrency','EUR');
                           mapStringAcc.put('CreditLineInsurance','0');
                           mapStringAcc.put('CreditLineUblox','0');
                           mapStringAcc.put('CreditLineEffectiveDate','12-12-2008');
                           mapStringAcc.put('CreditLineProlongation','12-12-2009');                                                      
                           mapStringAcc.put('CreditLineEndDate','12-12-2010'); 
                           mapStringAcc.put('InsuranceRemarks','Remark4');                                                    
                           lstMapAcc.add(mapStringAcc);
    }
    
    
/*1 Test 1: correctness of imported data

1.all account data in sandbox deleted (mass delete)
2.52 XML files copied into \\whale\fmserver\ISA directory
3.Account data compared with data in XML files
4.Processing of city names in US and Canada
5.Assignment of owners tested
*/
public static testMethod void test1(){
    
    System.debug('Test 1 started');

    delete [select Id,Name from Account where Name IN : setName];
    listAcc=listAccount();    
    System.debug('============ before test1 listAcc: ' + listAcc); //expected: 0       
    
    task(lstMapAcc);

    listAcc=listAccount();
    if(listAcc!=null)
        System.debug('============ after test1 listAcc: ' + listAcc.size() + ': ' + listAcc); //expected: 4    
    
    System.debug('Test 1 completed');
   
}//end test1


/*2 Test 2: Connect new Abacus Accounts to existing Salesforce accounts

1.all account data in sandbox deleted (mass delete)
2.Upload SF data of Accounts that are part of the test accounts:
- 19 Accounts out of the 22 already exist in Salesforce
3.Remove the customer number on all records in Salesforce
4.52 XML files copied into \\whale\fmserver\ISA directory
5.Check account information after processing of data


* Rule in order to match a new Abacus account with an existing Salesforce account: 
       - Account Name needs to be identical (capital and small letters can be different, eg THALES can be matched with Thales)
       - ZIP code needs to be identical
       - Salesforce Account does not contain a customer number yet 
*/

public static testMethod void test2(){
    
    System.debug('Test 2 started');
    
    delete [select Id,Name from Account where Name IN : setName];
    listAcc=listAccount();    
    System.debug('============ before test2 listAcc: ' + listAcc); //expected: 0
    
    List<Account> listAccount=new List<Account>();
    listAccount.add(new Account(Name='Alcohol Countermeasure Sustems Corp',ShippingCountry='CA',ShippingState='ON',BillingPostalCode='M9W 6J2'));    
    listAccount.add(new Account(Name='Alcohol Countermeasure Sustems Corp',ShippingCountry='CA',ShippingState='NS',BillingPostalCode='V5J 5G4'));    
    listAccount.add(new Account(Name='Tiger',ShippingCountry='US',ShippingState='AK',BillingPostalCode='AC1'));   
    insert listAccount;    
    System.debug('============ existing accounts in sf: ' + listAccount); //exptected: 3

    //doMap and Upsert2
    task(lstMapAcc);      
    
    
    listAcc=listAccount();    
    
    if(listAcc!=null)
        System.debug('============ after test2 listAcc: ' + listAcc.size() + ': ' + listAcc);   //expected: 5     
   
       /*Account[] lAccounts=[Select a.Owner.Alias,a.ShippingStreet, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Phone, a.Name, 
        a.Insurance_Remarks__c, a.Insurance_Number__c, a.Insurance_Currency__c, a.Fax, a.Customer_No__c, a.CurrencyIsoCode, 
        a.Credit_Line_u_blox__c, a.Credit_Line_Prolongation__c, a.Credit_Line_Insurance__c, a.Credit_Line_End_Date__c, 
        a.Credit_Line_Effective_Date__c, a.Abacus_Region_Code__c, a.Abacus_Payterms__c From Account a where a.Name='Alcohol Countermeasure Sustems Corp' or a.Name='Tiger'];
    
        System.debug('========= listAccount 1: '  + listAccount.get(0));
        System.debug('========= listAccount 2: '  + listAccount.get(1));        
        System.debug('========= lAccounts: '  + lAccounts);*/
        
    System.debug('Test 2 completed');
    
        
}//end test2

/*3 Test 2: Update of connected Salesforce accounts

1.all account data in sandbox deleted (mass delete)
2.Upload SF data of Accounts that are part of the test accounts:
- 19 Accounts out of the 22 already exist in Salesforce
3.52 XML files copied into \\whale\fmserver\ISA directory
4.Check account information after processing of data
*/
public static testMethod void test3(){

    System.debug('Test 3 started');
    
    //Connect new Abacus Accounts to existing Salesforce accounts if any
    test2();
    listAcc=listAccount();  
    
    if(listAcc!=null)
        System.debug('============ existing sf account: ' + listAcc.size() + ': ' + listAcc); //expected: 5 
    
    //integrate again (update),doMap and Upset2
    task(lstMapAcc);
    
    listAcc=listAccount();        
    if(listAcc!=null)
        System.debug('============ after test3 listAcc: ' + listAcc.size() + ': ' + listAcc); //expected: still 5 
    
    
    System.debug('Test 3 completed');

}//end test3




/*Test 4: Connect new Abacus Accounts to existing Salesforce accounts
    IN case: at SF, more than one Account with same Name and Billing Zip Code (some no Customer No and other with Customer No)
    Update the one with Customer No
*/

public static testMethod void test4(){
    
    System.debug('Test 4 started'); 
    
    delete [select Id,Name from Account where Name IN : setName];
    listAcc=listAccount();

    System.debug('============ before test4 listAcc: ' + listAcc); //expected: 0
    
    List<Account> listAccount=new List<Account>();
    listAccount.add(new Account(Name='Alcohol Countermeasure Sustems Corp',ShippingCountry='CA',ShippingState='ON',BillingPostalCode='M9W 6J2'));
    listAccount.add(new Account(Name='Alcohol Countermeasure Sustems Corp',ShippingCountry='CA',ShippingState='ON',BillingPostalCode='M9W 6J2',Customer_No__c='ACC2'));
    listAccount.add(new Account(Name='Alcohol Countermeasure Sustems Corp',ShippingCountry='CA',ShippingState='NS',BillingPostalCode='V5J 5G4'));    
    listAccount.add(new Account(Name='Tiger',ShippingCountry='US',ShippingState='AK',BillingPostalCode='AC1'));   
    insert listAccount;    
    System.debug('============ existing accounts in sf: ' + listAccount); //expected: 4

    
    //doMap and Upsert2
    task(lstMapAcc);    
    
    listAcc=listAccount();    

    if(listAcc!=null)
        System.debug('============ after test4 listAcc: ' + listAcc.size() + ': ' + listAcc);  //expected: 6
    
    
    /*Account[] lAccounts=[Select a.Owner.Alias,a.ShippingStreet, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Phone, a.Name, 
    a.Insurance_Remarks__c, a.Insurance_Number__c, a.Insurance_Currency__c, a.Fax, a.Customer_No__c, a.CurrencyIsoCode, 
    a.Credit_Line_u_blox__c, a.Credit_Line_Prolongation__c, a.Credit_Line_Insurance__c, a.Credit_Line_End_Date__c, 
    a.Credit_Line_Effective_Date__c, a.Abacus_Region_Code__c, a.Abacus_Payterms__c From Account a where a.Name='Alcohol Countermeasure Sustems Corp' or a.Name='Tiger'];

    System.debug('========= listAccount 1 with no Cus No: '  + listAccount.get(0));
    System.debug('========= listAccount 2 with Cus No: '  + listAccount.get(1));
    System.debug('========= listAccount 3: '  + listAccount.get(2));        
    System.debug('========= lAccounts: '  + lAccounts);*/
    
    System.debug('Test 4 completed');
    
    
    
}//end test4


    //public static testMethod void testOther(){
        
    //  TestIService.testIService();        
    //  TestIService.testExpressionEvaluator();
        
    //}


    //retrieve account in setName
    static List<Account> listAccount(){
        
        List<Account> lstAcc=[Select a.Owner.Alias,a.ShippingStreet, a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity, a.Phone, a.Name, 
        a.Insurance_Remarks__c, a.Insurance_Number__c, a.Insurance_Currency__c, a.Fax, a.Customer_No__c, 
        a.Credit_Line_u_blox__c, a.Credit_Line_Prolongation__c, a.Credit_Line_Insurance__c, a.Credit_Line_End_Date__c, 
        a.Credit_Line_Effective_Date__c, a.Abacus_Region_Code__c, a.Abacus_Payterms__c From Account a where a.Name IN :setName];
    
        return lstAcc;
    }


    //do doMap and upsert2 (Import Data Simulation)
    public static void task(List<Map<String,String>> mRecords){
        delete[Select id From skyvvasolutions__Adapter__c Where Name='Test Xml Adapter1'];
        delete[Select id From skyvvasolutions__Integration__c Where Name='Test UBlox Integration'];
        
        skyvvasolutions__Adapter__c  adp=new skyvvasolutions__Adapter__c(Name='Test Xml Adapter1');
        insert adp;
        skyvvasolutions__Integration__c integration=new skyvvasolutions__Integration__c(Name='Test UBlox Integration');
        insert integration;
           
        skyvvasolutions__Interfaces__c intf=new skyvvasolutions__Interfaces__c(skyvvasolutions__Name__c='Account',skyvvasolutions__Integration__c=integration.Id,skyvvasolutions__Source_Name__c='Account');
        insert intf;
        
        //Mappings
        List<skyvvasolutions__IMapping__c> lMapping=new List<skyvvasolutions__IMapping__c>();                 
        
        lMapping.add( new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='Customer_No__c',skyvvasolutions__Target_Type__c='text',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='CustomerNumber',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=true));
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='Abacus_Region_Code__c',skyvvasolutions__Target_Type__c='double',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='RegionalOfficeCode',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='Name',skyvvasolutions__Target_Type__c='text',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='CompanyName',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));          
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='ShippingCountry',skyvvasolutions__Target_Type__c='text',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='CountryCode',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='ShippingPostalCode',skyvvasolutions__Target_Type__c='text',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='ZipCode',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));           
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='ShippingCity',skyvvasolutions__Target_Type__c='text',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='City',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='Phone',skyvvasolutions__Target_Type__c='phone',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='MainNumber',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));    
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='Fax',skyvvasolutions__Target_Type__c='phone',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='Fax',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));  
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='CurrencyIsoCode',skyvvasolutions__Target_Type__c='picklist',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='CurrencyIso',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));      
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='Abacus_Payterms__c',skyvvasolutions__Target_Type__c='text',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='PaymentTerms',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));          
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='Insurance_Number__c',skyvvasolutions__Target_Type__c='text',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='InsuranceNumber',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));   
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='Insurance_Currency__c',skyvvasolutions__Target_Type__c='text',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='InsuranceCurrency',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='Credit_Line_Insurance__c',skyvvasolutions__Target_Type__c='double',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='CreditLineInsurance',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));   
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='Credit_Line_u_blox__c',skyvvasolutions__Target_Type__c='double',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='CreditLineUblox',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));      
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='Credit_Line_Effective_Date__c',skyvvasolutions__Target_Type__c='date',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='CreditLineEffectiveDate',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));  
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='Credit_Line_Prolongation__c',skyvvasolutions__Target_Type__c='date',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='CreditLineProlongation',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));        
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='Credit_Line_End_Date__c',skyvvasolutions__Target_Type__c='date',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='CreditLineEndDate',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));    
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='Insurance_Remarks__c',skyvvasolutions__Target_Type__c='text',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='InsuranceRemarks',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false)); 
        
        //8-May-2014
        lMapping.add(new skyvvasolutions__IMapping__c(skyvvasolutions__Type__c='Flat',skyvvasolutions__Target__c='ShippingState',skyvvasolutions__Target_Type__c='text',
             skyvvasolutions__Target_Object__c='Account',skyvvasolutions__Source__c='State',skyvvasolutions__Source_Type__c='text',skyvvasolutions__Interface__c=intf.Id,skyvvasolutions__EXT_ID__c=false));
        
                 
        insert lMapping;  
        
        List<skyvvasolutions__IMapping__c> limapping =  [Select i.skyvvasolutions__Type__c,skyvvasolutions__Target_Object__c, skyvvasolutions__EXT_ID__c,i.skyvvasolutions__Target__c, i.skyvvasolutions__Source__c,skyvvasolutions__Source_Type__c,skyvvasolutions__Target_Type__c,i.skyvvasolutions__Interface__c, i.Id From skyvvasolutions__IMapping__c i where i.skyvvasolutions__Interface__c=:intf.Id];
        System.debug('========= limapping ' + limapping);
        
        List<skyvvasolutions__IMessage__c> lstM=new List<skyvvasolutions__IMessage__c>();          
        for(Integer ii=0;ii<4;ii++){
            lstM.add(new skyvvasolutions__IMessage__c(Name='IM#'+System.Now()+ii,skyvvasolutions__Status__c='Failed',
                skyvvasolutions__Type__c='Inbound',skyvvasolutions__Integration__c=integration.Id,skyvvasolutions__Interface__c=intf.Id));
        }   
        
        insert lstM;
                    
        skyvvasolutions.IServicesUtil.IMessageResult  iMR=new skyvvasolutions.IServicesUtil.IMessageResult(lstM,mRecords);                     
        iMR.addMappingError(0,'ART_LEI_NR');
        iMR.addMappingError(0,'Failed');
        
        SKYVVA_UBloxAccountIntegration ubloxAccount=new SKYVVA_UBloxAccountIntegration();
        ubloxAccount.init(intf.Id);         
        System.debug('------------init()----');
        
        ubloxAccount.doMap(iMR);
        System.debug('------------doMap()----');
        
        ubloxAccount.upsert2();
        System.debug('------------upsert2()----');  
    
        
        //Other cases
        SKYVVA_UBloxAccountIntegration ubloxAccount2=new SKYVVA_UBloxAccountIntegration();
        
        skyvvasolutions.IServicesUtil.IMessageResult  iMR2=new skyvvasolutions.IServicesUtil.IMessageResult(lstM,null);     
        List<Map<String,String>> lstMapAcc2=new List<Map<String,String>>();
        lstMapAcc2.add(null);
        
        skyvvasolutions.IServicesUtil.IMessageResult  iMR3=new skyvvasolutions.IServicesUtil.IMessageResult(lstM,lstMapAcc2);   
        
        ubloxAccount2.getMapExisitingAccounts(iMR2);            
        ubloxAccount2.doMap(null);
        ubloxAccount2.doMap(iMR2);
        ubloxAccount2.doMap(iMR3);              
        
    }

    
    
}
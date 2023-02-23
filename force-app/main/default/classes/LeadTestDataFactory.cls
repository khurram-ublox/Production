@isTest
public class LeadTestDataFactory extends TestDataFactory {
    
    public Account addAccount(){
        
        Account acc = new Account();
        acc.Name='Test Acc';   
        insert acc;
        return acc;
    }
    public static Opportunity addOpportunity(){
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'Opportunity - M11 Scout';
        oppObj.StageName='6 Prototypes';
        oppObj.CloseDate= system.today();
        insert oppObj;
        return oppObj;        
    }
    
    public static Lead initiliazeLead(){
        Lead LeadObj = new Lead();
        LeadObj.LastName = 'test Lead';
        LeadObj.Company= 'test company';
        LeadObj.Country = 'GB';
        return LeadObj;        
    }
    
    
    public override sObject initializeRecord(){
        Contact c = new Contact();
        c.LastName = 'Test Contact1';
        return c;
    }
    public static Account initializeAccount(String Name ){
        // Insert
        Account accObj = new Account();
        accObj.Name='test';
        return accObj;
    }
    
    public static void createCustomSettings(){
        Flow_Notification_Settings__c	 setting = new Flow_Notification_Settings__c	();
        setting.Lead__c =true;
        insert setting;
    }
    
    @isTest
    public static void LeadScenariosTesting() {
        
        createCustomSettings();
        List<Lead> leadList = new List<Lead>();
        //Opportunity oppObj = addOpportunity();
        //Account tempAccount = TestUtils.createAccount();
        
        //Lead / online shop: send email alert (APAC)
        Lead leadObj = initiliazeLead();
        leadObj.LeadSource = 'u-shop order';
        leadObj.uB_Office__c = 'China';


//Lead / PCN subscription: send email alert (Americas)
        Lead leadObj2 = initiliazeLead();
        leadObj2.LeadSource = 'PCN subscription';
        leadObj2.uB_Office__c = 'Americas';
        leadObj2.Lead_Source_Webform__c='PCN Subscription Form';



//Lead: inform about web2lead action, PCN (APAC)
        Lead leadObjAPAC = initiliazeLead();
        leadObjAPAC.LeadSource = 'PCN subscription';
        leadObjAPAC.uB_Office__c = 'EMEA';
        leadObjAPAC.Lead_Source_Webform__c='PCN Subscription Form';
        
        
        //Lead: inform about web2lead action, PCN (APAC)
        Lead leadObjAmericas = initiliazeLead();
        leadObjAmericas.LeadSource = 'Web';
        leadObjAmericas.uB_Office__c = 'Americas';
        leadObjAmericas.Lead_Source_Webform__c='Service Registration Form';



 //Lead: inform about web2lead action, PCN (APAC)
        Lead leadObjAus = initiliazeLead();
        leadObjAus.LeadSource = 'Web';
        leadObjAus.uB_Office__c = 'Australia';


 //Lead / project form: send email alert (China)
        Lead leadObjChina = initiliazeLead();
        leadObjChina.LeadSource = 'Web';
        leadObjChina.uB_Office__c = 'China';
        
        
         //Lead / project form: send email alert (EMEA)
        Lead leadObjEMEA = initiliazeLead();
        leadObjEMEA.uB_Office__c = 'Corporate';
        leadObjEMEA.LeadSource = 'Project Form - Customer';
        leadObjEMEA.Lead_Source_Webform__c = 'Event registration (aloom)';
        
        
        
          //project form: send email alert (India)
        Lead leadObjIndia = initiliazeLead();
        leadObjIndia.uB_Office__c = 'India';
        leadObjIndia.LeadSource = 'Project Form - Customer';
        
        
        
       
        
          // Lead / project form: send email alert (Japan) 
        Lead leadObjJapan = initiliazeLead();
        leadObjJapan.uB_Office__c = 'Japan';
        leadObjJapan.LeadSource = 'Project Form - Customer';
        
        
        
        // Lead / project form: send email alert (Korea)
        Lead leadObjKorea = initiliazeLead();
        leadObjKorea.uB_Office__c = 'Korea';
        leadObjKorea.LeadSource = 'Project Form - Customer';
        
        
        
        
         // Lead / project form: send email alert (RoA)
        Lead leadObjRoA = initiliazeLead();
        leadObjRoA.uB_Office__c = 'Rest of APAC';
        leadObjRoA.LeadSource = 'Project Form - Customer';
        
        //starts from here
        //
        
         //Lead / project form: send email alert (Taiwan)
        Lead leadObjTaiwan = initiliazeLead();
        leadObjTaiwan.uB_Office__c = 'Taiwan';
        leadObjTaiwan.LeadSource = 'Project Form - Customer';
        
        
       /*
        
        //Lead: Auto response for webforms (AssistNow Temporary) 
        Lead leadObjAssistNow = initiliazeLead();
        leadObjAssistNow.LeadSource = 'Webform';
        leadObjAssistNow.Lead_Source_Webform__c = 'AssistNow Temporary';
        //leadObjAssistNow.AssistNow_Temporary_Token__c=true;
        */
        
        //Lead: Auto response for webforms (for new website with Drupal, AssistNow)
        Lead leadObjWebform = initiliazeLead();
        leadObjWebform.LeadSource = 'Webform';
        leadObjWebform.Lead_Source_Webform__c = 'Service Registration Form';
        
        
        
        
        //Lead: Auto response for webforms (for new website with Drupal, generic)
        Lead leadObjWebformDrupal = initiliazeLead();
        
        leadObjWebformDrupal.LeadSource = 'Project Form - Distributor';
        leadObjWebformDrupal.Lead_Source_Webform__c = 'Project Form - Distributor';
        
        //Lead: Notify gsol about new leads
        Lead leadObjgsol = initiliazeLead();
        leadObjgsol.Products_Of_Interest__c = 'IoT-Security-as-a-Service';
        leadObjgsol.LeadSource = 'Project Form - Customer';
        
        
        //Lead: send email alert to info@u-blox.com (EMEA) 
        
        Lead leadObjInfoEMEA = initiliazeLead();
        leadObjInfoEMEA.uB_Office__c = 'Corporate';
        leadObjInfoEMEA.LeadSource = 'Project Form - Customer';
        
        
        
        //Lead: Set Company and Record Types 
        
         Lead leadObjRecordType = initiliazeLead();
        
        leadObjRecordType.LeadSource = 'Webform';
        leadObjRecordType.Lead_Source_Webform__c = 'News Subscription';
        
        
        
        //Lead: ub Office as EMEACondition
        
         Lead leadObjEMEACondition = initiliazeLead();
        
        leadObjEMEACondition.uB_Office__c = 'EMEA';
        leadObjEMEACondition.Lead_Source_Webform__c = 'NB-IoT Project Form';

        
        
        
        
        
       // insert leadObj;

        
        
        
        
       
        leadList.add(leadObj);
        leadList.add(leadObj2);
        leadList.add(leadObjAPAC);
        
        leadList.add(leadObjAmericas);
        leadList.add(leadObjAus);
        leadList.add(leadObjChina);

        leadList.add(leadObjEMEA);
        
        leadList.add(leadObjIndia);
        
        leadList.add(leadObjJapan);
        leadList.add(leadObjKorea);
        
        
        
        
        leadList.add(leadObjTaiwan);
      
        leadList.add(leadObjWebform);
      leadList.add(leadObjWebformDrupal);  
        
        leadList.add(leadObjgsol);
        
        
        leadList.add(leadObjInfoEMEA);
        
        leadList.add(leadObjRecordType);
        
        
        leadList.add(leadObjEMEACondition);
        //leadList.add();
        //leadList.add();
        //leadList.add();
        //leadList.add();
        //leadList.add();
         //leadList.add(leadObjRecordType);
        
        insert leadList;
        system.debug('accList--->>>'+leadList);
    
    }
    
    public override sObject createRecord() {
        
        Account accObj = TestUtils.createAccount();
        Product2 prodObj= createProduct ('Test Prod', 'Test Prod 001');
        insert prodObj;
        
        return prodObj;
    }
    
    public static Product2 createProduct (String Name, String Type)
    {
        return new Product2(
            Name=Name,
            Type_No__C=Type,
            Packaging_Size__c=1,
            Family='Other',
            Positioning_Engine__c='Not applicable',
            CurrencyIsoCode='USD',
            COGS_1__c=20,
            COGS_Pct__c=0);
    }
    
    public override List<sObject> createBulkRecords() {
        
        for (Integer i = 0; i < numberofRecords; i++) {
            recordsList.add((Billings__c)initializeRecord());
        }
        Insert recordsList;
        return recordsList;
    }
    
}
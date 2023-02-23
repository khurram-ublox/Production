Public Class TestUtils
{
    public static Account createAccount()
    {
        Account acc = new Account();
        acc.name = 'Test Account';
        insert acc;
        return acc;
    }
    
    public static Account createAccountWithOwner(ID ownerId)
    {
        Account acc = new Account();
        acc.name = 'Test Account';
        acc.OwnerId = ownerId;
        insert acc;
        return acc;
    }

    public static Account createAccountWithGAM()
    {
        Account acc = new Account();
        acc.name = 'Test Account';
        
        User u= createUserWithProfile('Jhon','System Administrator');
        acc.Global_Account_Manager__c = u.Id;
        insert acc;
        return acc;
    }
    //create Abacus Account
    public static Account createAbacusAccount()
    {
        Account acc = new Account();
        acc.name = 'Test Account';
        acc.Customer_No__c = '123Test';
        acc.uB_Office__c = 'Americas';
        User u= createUserWithProfile('Jhon','System Administrator');
        acc.Global_Account_Manager__c = u.Id;
        insert acc;
        return acc;
    }
    //create Non-Abacus Account
    public static Account createNonAbacusAccount()
    {
        Account acc = new Account();
        acc.name = 'Test Account';
        //acc.Customer_No__c = '123Test';
        User u= createUserWithProfile('Jhon','System Administrator');
        acc.uB_Office__c = 'Americas';
        acc.Global_Account_Manager__c = u.Id;
        insert acc;
        return acc;
    }
    
    //create account with country
    public static Account createAccountWithCountry()
    {
        Account acc = new Account();
        acc.name = 'Test Account';
        acc.ShippingCountry='US';
        acc.ShippingState='AR';
        User u= createUserWithProfile('Jhon','System Administrator');
        acc.Global_Account_Manager__c = u.Id;
        insert acc;
        return acc;
    }
    
    public static Contract createContractWithAccount(ID accid)
    {
        Contract cont = new Contract();
        cont.accountId = accid;
        insert cont;
        return cont;
    }
    
    public static Contract createContractWithAccount(Id accId, String status)
    {
        Contract cont = new Contract();
        cont.accountId = accid;
        cont.Status = status;
        insert cont;
        return cont;
    }
    
    public static Contract createContractWithOwner(ID accid,ID ownerId)
    {
        Contract cont = new Contract();
        cont.ownerId = ownerId;
        cont.accountId = accid;
        insert cont;
        return cont;
    }
    
    public static Process_Settings__c createProcessSettingRecord()
    {
        String profileId = userinfo.getProfileId();
            
        Process_Settings__c pSetting = Process_Settings__c.getInstance();
        pSetting.Restricted_Profiles_For_Contract__c = 'Partner Base Quotation;';
        pSetting.Account_Allowed_Profiles_To_Merge__c = profileId;
        pSetting.Account_Allowed_Profiles_To_Delete__c = profileId;
        
        upsert pSetting;
        return pSetting;
    }
    public static User createUserWithProfile(String lName,String profileName)
    {
        User u = null;
        
        List<Profile> profList = [select id,Name from Profile where Name =: profileName];
        
        if(profList.size()>0)
        {
            u = new User(Alias = 'testabc', Email='testabc_'+DateTime.now().getTime()+'@u-blox-test.com', 
            EmailEncodingKey='UTF-8', LastName=lName, LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profList[0].id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testabc_'+DateTime.now().getTime()+'@u-blox-test.com');
            
            insert u; 
        }    
        
        return u;
    }

    public static Case createCaseForAccount(Id accountId)
    {
        Case cse = new Case();
        cse.Status = 'New';
        cse.AccountId = accountId;
        insert cse;
        return cse;
    }
    
    public static Opportunity createOpportunityForAccount(Id accountId)
    {
        Opportunity opp = new Opportunity(Name='TestOpp', StageName='3 Calling on',CloseDate=Date.today(),Description='test description',AccountId=accountId);
        insert opp;
        return opp;
    }
    
    public static Process_Settings__c createAccCustomSetting()
    {
        Process_Settings__c psetting = new Process_Settings__c();
        psetting.Name = 'Test Setting';
        pSetting.Account_Allowed_Profiles_To_Merge__c='00e20000000ki5l';
        psetting.Account_Allowed_Profiles_To_Delete__c ='00e20000000ki5l';
        insert psetting;
        return psetting;
    }
    
    public static Country__c createCountry()
    {
        Country__c countryObj = new country__c();        
        countryObj.ISO_Code__c='US';
        countryObj.State__c='001';
        insert countryObj;
        return countryObj;
    }
    
        public static product2 createProduct(String name, String productCode, String family, String typeNo)
    {
        product2 prodObj = new product2();        
        prodObj.Name = name;
        prodObj.ProductCode = productCode;
        prodObj.Family = family;
        prodObj.Type_No__c = typeNo;
        
        insert prodObj;
        return prodObj;
    }
    
    public static Contribution_Share__c createCS(String acId, String ecAccId, String poAccId, String prodId, String oppId,String prodField, String prodValue)
    {
        Contribution_Share__c CSObj = new Contribution_Share__c();        
        CSObj.Account__c = acId;
        CSObj.End_Customer__c = ecAccId;
        CSObj.Project_Owner_Account__c = poAccId;
        CSObj.Product__c = prodId;
        if(!String.isBlank(prodField)  && !String.isBlank(prodValue) ){
            CSObj.Product_Filter_Field__c = prodField;
            CSObj.Product_Filter_Value__c = prodValue;
            
        }
        CSObj.Status__c = 'Activated';
        CSObj.Opportunity__c = oppId;
        CSObj.CurrencyIsoCode ='USD' ;
        
        insert CSObj;
        return CSObj;
    }

public static Billings__c createOrder(String acId, String ecAccId, String poAccId, String prodId)
    {
        Billings__c o = new Billings__c();
        o.Account__c = acId;
        o.End_Customer_Account__c = acId;
        o.Project_Owner_Account__c = acId;
        o.Product__c = prodId;
        o.Delivery_Date__c = Date.today().addMonths(+1);
        o.Qty_Ordered__c = 100;
        o.Total_Value_CHF__c = 1000;
        o.Update_CS__c = true;
        insert o;
        return o;
    }
    
    
    
    
        
      
}
@isTest
public with sharing class UpdateAccountTest {
    public UpdateAccountTest() {

    }

    public static testMethod void beforInsertAccount(){
    
        System.debug('>>>Start Test');
        
        //fixed INACTIVE ACCOUNT OWNER USER,
        List<Profile> profList = [select id,Name from Profile where Name ='System Administrator'];
        string profId = profList[0].id; 
        User u=[select id,alias from user where profileId = : profId AND isActive=true limit 1];
        List<Country__c> lc=[select uB_Office__c,OwnerId,ISO_Code__c,State_Code__c,State__c from Country__C where ISO_Code__c IN :new Set<String>{'US','DM','CN','CA','CD'}];
        for(Country__c c : lc){
            c.OwnerId=u.Id;
        }
        update lc;    
        
        List<Account> listAccount=new List<Account>();
        listAccount.add(new Account(Name='Jerry',ShippingCountry='US',ShippingState='AK'));
        listAccount.add(new Account(Name='Tom',ShippingCountry='US',ShippingState='AK'));
        listAccount.add(new Account(Name='Tom 2',ShippingCountry='US',ShippingState='CA'));
        listAccount.add(new Account(Name='Tom 3',ShippingCountry='US'));
        listAccount.add(new Account(Name='Account 1',ShippingCountry='DM'));
        listAccount.add(new Account(Name='Tom 4',ShippingCountry='US',ShippingState='AR'));
        listAccount.add(new Account(Name='Tom 5',ShippingCountry='CN',ShippingCity='JS'));
        listAccount.add(new Account(Name='Tom 6',ShippingCountry='CA',ShippingCity='YT'));
        listAccount.add(new Account(Name='Tom 7',ShippingCountry='CD'));
        
        insert listAccount;
        System.debug('>>> Insert List of Account');
        Account acc;
    
        Account acc1=[Select a.uB_Office__c, a.ShippingCountry, a.ShippingCity, a.Owner.Alias From Account a where a.Name='Jerry' limit 1];
        System.debug('>>>AccountManager:'+acc1.Owner.Alias);//RS
        System.debug('>>>UbOffice:'+acc1.uB_Office__c);//Americas
    
        Account acc2=[Select a.uB_Office__c, a.ShippingCountry, a.ShippingCity, a.Owner.Alias From Account a where a.Name='Tom' limit 1];
        System.debug('>>>AccountManager:'+acc2.Owner.Alias);//RS
        System.debug('>>>UbOffice:'+acc2.uB_Office__c);//Americas
        
        Account acc22=[Select a.uB_Office__c, a.ShippingCountry, a.ShippingCity, a.Owner.Alias From Account a where a.Name='Tom 2' limit 1];
        System.debug('>>>AccountManager:'+acc22.Owner.Alias);//MM
        System.debug('>>>UbOffice:'+acc22.uB_Office__c);//Americas
        
        Account acc23=[Select a.uB_Office__c,a.ShippingCountry, a.ShippingCity, a.Owner.Alias From Account a where a.Name='Tom 3' limit 1];
        System.debug('>>>AccountManager:'+acc23.Owner.Alias);//BS
        System.debug('>>>UbOffice:'+acc23.uB_Office__c);//Americas
        
        Account acc24=[Select a.uB_Office__c,a.ShippingCountry, a.ShippingCity, a.Owner.Alias From Account a where a.Name='Tom 4' limit 1];
        System.debug('>>>AccountManager:'+acc24.Owner.Alias);//AS //ascha
        System.debug('>>>UbOffice:'+acc24.uB_Office__c);//Americas
        
        Account acc25=[Select a.uB_Office__c,a.ShippingCountry, a.ShippingCity, a.Owner.Alias From Account a where a.Name='Tom 5' limit 1];
        System.debug('>>>AccountManager:'+acc25.Owner.Alias);//BW
        System.debug('>>>UbOffice:'+acc25.uB_Office__c);//China
    
        Account acc26=[Select a.uB_Office__c,a.ShippingCountry, a.ShippingCity, a.Owner.Alias From Account a where a.Name='Tom 6' limit 1];
        System.debug('>>>AccountManager:'+acc26.Owner.Alias);//BS
        System.debug('>>>UbOffice:'+acc26.uB_Office__c);//Americas
        
        Account acc27=[Select a.uB_Office__c,a.ShippingCountry, a.ShippingCity, a.Owner.Alias From Account a where a.Name='Tom 7' limit 1];
        System.debug('>>>AccountManager:'+acc27.Owner.Alias);//HR
        System.debug('>>>UbOffice:'+acc27.uB_Office__c);//EMEA
    
        Account acc3=[Select a.uB_Office__c,a.ShippingCountry, a.ShippingCity, a.Owner.Alias From Account a where a.Name='Account 1' limit 1];
        System.debug('>>>AccountManager:'+acc3.Owner.Alias);//NP
        System.debug('>>>UbOffice:'+acc3.uB_Office__c);//Americas
        
        
        
        
    }
}
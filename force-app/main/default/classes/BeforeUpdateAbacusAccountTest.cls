@isTest
public with sharing class BeforeUpdateAbacusAccountTest {
    public BeforeUpdateAbacusAccountTest() {

    }

    public static testMethod void testBeforeUpdateAbacusAccount(){
        
        //fixed INACTIVE ACCOUNT OWNER USER,
        List<Profile> profList = [select id,Name from Profile where Name ='System Administrator'];
        string profId = profList[0].id;  
    
        User u=[select id,alias from user where profileId = : profId AND isActive=true limit 1];
        List<Country__c> lc=[select uB_Office__c,OwnerId,ISO_Code__c,State_Code__c,State__c from Country__C where ISO_Code__c IN :new Set<String>{'US','DM','CN','CA'}];
        for(Country__c c : lc){
            c.OwnerId = u.Id;
        }
        update lc;
    
        BeforeUpdateAbacusAccount.profileName='xxxxx';
        
        List<Account> listAccount=new List<Account>();
        listAccount.add(new Account(Name='Jerry'));
        listAccount.add(new Account(Name='Tom',ShippingCountry='US',ShippingState='AA',Customer_No__c='123456'));
        listAccount.add(new Account(Name='Tom 2',ShippingCountry='US',ShippingState='CA',Customer_No__c='654321'));
        listAccount.add(new Account(Name='Tom 3',ShippingCountry='US',ShippingState='WI'));
        listAccount.add(new Account(Name='Account 1',ShippingCountry='DM'));
        listAccount.add(new Account(Name='Tom 4',ShippingCountry='US',ShippingState='AK'));
        listAccount.add(new Account(Name='Tom 5',ShippingCountry='CN',ShippingCity='JS'));
        listAccount.add(new Account(Name='Tom 6',ShippingCountry='CA',ShippingCity='YT'));
        
        insert listAccount;
        
        

            listAccount.get(0).Name='Account 11'; //not linked to abacus
            update listAccount.get(0);                      
            
            //linked to abacus
            try{
                listAccount.get(1).Name='Name1';
                update listAccount.get(1);
            }catch(Exception e){
                //System.assert(e.getMessage().contains('Account linked to Abacus, this field is not modifiable')); 
            }
            
            try{
                listAccount.get(1).Customer_No__c='123456';
                update listAccount.get(1);
            }catch(Exception e){
                //System.assert(e.getMessage().contains('Account linked to Abacus, this field is not modifiable')); 
            }
                        
            try{
                listAccount.get(1).Phone='123';
                update listAccount.get(1);
            }catch(Exception e){
                //System.assert(e.getMessage().contains('Account linked to Abacus, this field is not modifiable')); 
            }
            
            try{
                listAccount.get(1).Fax='1231234';
                update listAccount.get(1);
            }catch(Exception e){
                //System.assert(e.getMessage().contains('Account linked to Abacus, this field is not modifiable'));
            }
            
                        
            listAccount.get(2).Name='Tomx';
            listAccount.get(2).Customer_No__c='00001';
            listAccount.get(2).Phone='555';
            listAccount.get(2).Fax='666';
            
            update listAccount.get(2);
            Account  acc= [select Name,Customer_No__c,Phone,Fax From Account where Name='Tomx'];


            System.assertEquals('Tomx',acc.Name);
            System.assertEquals('00001',acc.Customer_No__c);
            System.assertEquals('555',acc.Phone);
            System.assertEquals('666',acc.Fax);

               
    }
}
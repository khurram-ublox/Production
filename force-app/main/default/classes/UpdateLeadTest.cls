@isTest
public with sharing class UpdateLeadTest {
    public UpdateLeadTest() {

    }

    static testMethod void changeOwnerOnLeadBeforInsert(){
    
        System.debug('>>>Start Test');
        //fixed INACTIVE ACCOUNT OWNER USER,
        User u=[select id,alias from user where isActive=true limit 1];
        List<Country__c> lc=[select uB_Office__c,OwnerId,ISO_Code__c,State_Code__c,State__c from Country__C where ISO_Code__c IN :new Set<String>{'SM','US','CN','CA'}];
        for(Country__c c : lc){
            c.OwnerId = u.Id;
        }
        update lc;
    //Finland
        List<Lead> listLead=new List<Lead>();
        listLead.add(new Lead(FirstName='Jerry',LastName='Mouse',Country='SM',City='San Marino',Company='JerryMouse Co,Ltd'));
        listLead.add(new Lead(FirstName='Tom',LastName='Cat',Country='US',City='AA',Company='TomCat Co,Ltd'));
        listLead.add(new Lead(FirstName='Micky',LastName='Mouse',Country='CN',City='Gansu',Company='MickyMouse Co,Ltd'));
        
        insert listLead;
        System.debug('>>> inserted List of Lead');
        Lead lead;
    
        lead=[Select uB_Office__c,a.Country, a.City, a.Owner.Alias From Lead a where a.FirstName='Jerry' limit 1];
        System.debug('>>>AccountManager expected JMD :'+lead.Owner.Alias);//JMD
        //System.assertEquals('JMD',lead.Owner.Alias);
        //System.assertEquals('EMEA',lead.uB_Office__c);
    
        lead=[Select uB_Office__c,a.Country, a.City, a.Owner.Alias From Lead a where a.FirstName='Tom' limit 1];
        System.debug('>>>AccountManager expected RS :'+lead.Owner.Alias);//RS
        //System.assertEquals('RS',lead.Owner.Alias);
        //System.assertEquals('Americas',lead.uB_Office__c);
        
        lead=[Select uB_Office__c,a.Country, a.City, a.Owner.Alias From Lead a where a.FirstName='Micky' limit 1];
        System.debug('>>>AccountManager expected WL :'+lead.Owner.Alias);//WL
        //System.assertEquals('WL',lead.Owner.Alias);
        //System.assertEquals('China',lead.uB_Office__c);
        
        
        //Modified: 20-08-09
        List<Lead> listLead2=new List<Lead>();
        listLead2.add(new Lead(FirstName='Jerry2',LastName='Mouse2',Country='US',State='WI',Company='Company')); //RS; Americas
        listLead2.add(new Lead(FirstName='Tom2',LastName='Cat2',Country='US',State='AA',Company='Company'));            //RS; Americas  
        //listLead2.add(new Lead(FirstName='Tom2 2',LastName='Cat2 2',Country='US',State='CA',Company='Company'));      //MM; Americas
        listLead2.add(new Lead(FirstName='Tom 5',LastName='Cat 5', Country='CN',City='JS',Company='Company')); //BW; China
        listLead2.add(new Lead(FirstName='Tom 6',LastName='Cat 6',Country='CA',City='YT',Company='Company'));        //BS; Americas
        insert listLead2;
        
        Set<Id> ids = new Set<Id>();
        for(Lead l : listLead2) ids.add(l.Id);
        
        Map<String, String> mapOwnerExpected = new Map<String, String>();
        Map<String, String> mapUbOfficeExpected = new Map<String, String>();
        
        mapOwnerExpected.put('Jerry2','RS');
        mapOwnerExpected.put('Tom2','RS');
        //mapOwnerExpected.put('Tom2 2','MM');
        mapOwnerExpected.put('Tom 5','BW');
        mapOwnerExpected.put('Tom 6','BS');
        
        mapUbOfficeExpected.put('Jerry2','Americas');
        mapUbOfficeExpected.put('Tom2','Americas');
        //mapUbOfficeExpected.put('Tom2 2','Americas');
        mapUbOfficeExpected.put('Tom 5','China');
        mapUbOfficeExpected.put('Tom 6','Americas');
        
            
        List<Lead> result = [Select a.FirstName, a.LastName, a.uB_Office__c, a.Country, a.City, a.Owner.Alias From Lead a where id in : ids 
                order by a.FirstName];
        for(Lead l : result){
            System.debug('>>>Lead FirstName:'+l.FirstName);
            System.debug('>>>Actual AccountManager:'+l.Owner.Alias + '; Expected AccountManager: ' + mapOwnerExpected.get(l.FirstName));
            System.debug('>>>Actual UbOffice:'+l.uB_Office__c + '; Expected UbOffice: ' + mapUbOfficeExpected.get(l.FirstName));
        }    
        
        
    }
}
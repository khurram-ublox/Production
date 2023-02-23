public class updateOpportunityOwner{ 
    /*
2016.04.07 khir: Added Description of new Opportunity creation for update of updateStatusOnOppProduct.apxt
2018.12.07 khir: Username and Email changed
*/
    
    public static testMethod void testOpportunityOwner()
    {
        // Create new Account
        Account testAccount = new Account(name= 'Test Company Name', ShippingCity = 'Zurich', ShippingPostalCode = '8000', ShippingStreet = 'Hauptstrasse 1');
        insert testAccount;
        
        // Create a new User 
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='owner@u-blox.test', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='owner@u-blox.test');
        insert u;
        
        // Reassign Account to the new User
        testAccount.OwnerId = u.Id;
        update testAccount;
        
        // Create a new Opportunity
        List<Opportunity> o = new List<Opportunity>();
        // 2016.04.07 khir: Added Description of new Opportunity creation for update of updateStatusOnOppProduct.apxt
        o.add(new Opportunity(Name = 'Opp1', AccountId = testAccount.Id, StageName = 'new', CloseDate = System.today(), Description='test description'));
        insert o;
        
        // Create a new Quotation
        List<Opportunity> q = new List<Opportunity>();
        // 2016.04.07 khir: Added Description of new Opportunity creation for update of updateStatusOnOppProduct.apxt
        q.add(new Opportunity(Name = 'Opp2', AccountId = testAccount.Id, Quotation_Account__c = testAccount.Id, StageName = 'new', CloseDate = System.today(), Description='test description', Referred_Opportunity__c = o[0].Id, RecordTypeId = '01220000000CqRdAAK'));
        insert q;
        
        // Verify that the inserted Contact has the same Owner as the related Account                    
        Opportunity[] insertedOpportunity = [SELECT OwnerId FROM Opportunity WHERE Id = :o[0].Id OR Id = :q[0].Id];
        // not a proper test, but the apex should be fine as it was developed by ldra :)
        System.assertEquals(testAccount.OwnerId, insertedOpportunity[0].OwnerId);                                                
        
    } 
    
    
    public static void execute(List<Opportunity> os) {
        // the script supports Opportunities and Quotations
        
        Map<integer,id> mapO = new Map<integer,id>();
        Map<integer,id> mapA = new Map<integer,id>();
        Id nOwnerId;
        
        for(integer i=0;i<os.size();i++) {	
            // get map (mapO) of Referred_Opportunity__c
            if(os[i].Referred_Opportunity__c != Null) {
                mapO.put(i,os[i].Referred_Opportunity__c);
            }
            // get map (mapA) of AccountId, if mapO found then key from mapA will be removed
            // it's because there are opportunities that has non existing Referred_Opportunity__c
            if(os[i].AccountId != Null) {
                mapA.put(i,os[i].AccountId);
            }
        }
        
        if(mapO.size()>0) {
            map<id,Opportunity> mapOsel=new map<id,Opportunity>([select id, OwnerId  from Opportunity  where id in :mapO.values()]);
            
            if(mapOsel.size()>0) {
                
                for (integer ii : mapO.keySet()){
                    nOwnerId = null;
                    // if opportunity owner exists, change owner and remove key from mapA array
                    if(mapOsel.containsKey( mapO.get(ii) )) {
                        nOwnerId = mapOsel.get( mapO.get(ii) ).OwnerId;
                        //System.debug('o: '+ii+', id:'+os[ii].Id+', name:'+os[ii].Name+', o Owner'+os[ii].OwnerId+', n Owner'+nOwnerId);
                        if(os[ii].OwnerId != nOwnerId) os[ii].OwnerId = nOwnerId;
                        mapA.remove(ii);
                    }				
                }
            }
        }
        
        if(mapA.size()>0) {
            map<id,Account> mapAsel=new map<id,Account>([select id, OwnerId  from Account  where id in :mapA.values()]);
            
            if(mapAsel.size()>0) {
                for (integer ii : mapA.keySet()){
                    nOwnerId = null;
                    if(mapAsel.containsKey( mapA.get(ii) )) {
                        nOwnerId = mapAsel.get( mapA.get(ii) ).OwnerId;
                        //System.debug('a: '+ii+', id:'+os[ii].Id+', name:'+os[ii].Name+', o Owner'+os[ii].OwnerId+', n Owner'+nOwnerId);
                        if(os[ii].OwnerId != nOwnerId) os[ii].OwnerId = nOwnerId;
                    }					
                }
            }
        }
        
        //System.debug('Number of entries from accounts: ' + mapA.size());
        
    }
    
}
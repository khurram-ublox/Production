public class NewQuotationAccCtrl {
	@AuraEnabled
     public static String newQuotationMethod(String recordId){
         String QuotationId;
         String OpportunityId;
         String AccountId=recordId;         
         if(!string.isEmpty(recordId)){           
            String OpportunityName;
            String QuotationCurrency;
            String QuotationOwnerId;                       
            List<Account> accObjLst=new List<Account>();
             if(!string.isEmpty(AccountId)) {accObjLst = [SELECT Id, Name, OppCloseDate__c, Abacus_Payterms__c, CurrencyIsoCode, OwnerId FROM Account WHERE Id =:AccountId];}
            Date OppCloseDate;
            String PayTerms;
            if(!accObjLst.isEmpty()){
                OppCloseDate = accObjLst[0].OppCloseDate__c;
                PayTerms = accObjLst[0].Abacus_Payterms__c;
            } 
           
            if (OpportunityId==null)
            {
                //System.debug('aaaa'+OpportunityId);
             if(!accObjLst.isEmpty()){ 
                  //System.debug('aaaa');
                 OpportunityName = accObjLst[0].Name;
                 QuotationCurrency = accObjLst[0].CurrencyIsoCode;
                 QuotationOwnerId = accObjLst[0].OwnerId;
                
              }   
            }else
            {
            list<Opportunity> oppObjLst=[SELECT Name, CurrencyIsoCode, OwnerId FROM Opportunity WHERE Id =:OpportunityId];                       
             if(!oppObjLst.isEmpty()){ OpportunityName = oppObjLst[0].Name;  QuotationCurrency = oppObjLst[0].CurrencyIsoCode; QuotationOwnerId = oppObjLst[0].OwnerId;                                                  
             }   
            }                         
            Opportunity oppObj=new Opportunity();
            oppObj.Name = OpportunityName;
            oppObj.OwnerId = QuotationOwnerId;
            oppObj.CurrencyIsoCode = QuotationCurrency;
             if(AccountId !=null && AccountId !=''){ 
                oppObj.Quotation_Account__c = AccountId;
                oppObj.Referred_Opportunity_Account__c = AccountId; /* ADDED 04.08.2015 by :khir: */
                oppObj.AccountId = AccountId; /* ADDED 22.04.2009 */      
             }            
            oppObj.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Quotation').getRecordTypeId();/*Record ID für Quotation*/
            oppObj.StageName ='3 Calling On';
            oppObj.CloseDate = OppCloseDate;
            oppObj.Payment__c = PayTerms;
            oppObj.Referred_Opportunity__c = OpportunityId;
            insert oppObj;            
            QuotationId = oppObj.id;                     
            
           String RefreshId=QuotationId;
           String RoleOPP='Contact Quotation';
           String RoleACC='Contact Commercial';          
           list<OpportunityContactRole> OppConRoleLst= [SELECT ContactId, IsPrimary FROM OpportunityContactRole WHERE Role =:RoleOPP AND OpportunityId =:OpportunityId];
           list<AccountContactRole> accConRoleLst=new list<AccountContactRole>();
            if(OppConRoleLst.size()==0){
               accConRoleLst=[SELECT ContactId, IsPrimary FROM AccountContactRole WHERE Role =:RoleACC AND AccountId = :AccountId];
            }            
           list<OpportunityContactRole> delOppConcRoleLst=[SELECT Id FROM OpportunityContactRole WHERE OpportunityId =:RefreshId];            
            /* alert (deleterecords[0])*/
           if(delOppConcRoleLst.size()<7){
              delete delOppConcRoleLst;
            } 
             
           if(OppConRoleLst.size()!=0){ 
               list<OpportunityContactRole> oppContRoleObjlst= new list<OpportunityContactRole>(); 
               for(OpportunityContactRole oppContRole: OppConRoleLst){            
                    OpportunityContactRole oppContRoleObj= new OpportunityContactRole();  oppContRoleObj.ContactId = oppContRole.ContactId; oppContRoleObj.IsPrimary = oppContRole.IsPrimary; oppContRoleObj.OpportunityId = RefreshId;  oppContRoleObj.Role = RoleOPP; oppContRoleObjlst.add(oppContRoleObj);                                                                          	            
                }
               insert oppContRoleObjlst;
           }else{
               list<OpportunityContactRole> oppContRoleObjlst= new list<OpportunityContactRole>(); 
               for(AccountContactRole accConRole: accConRoleLst){            
                    OpportunityContactRole oppContRoleObj= new OpportunityContactRole();  oppContRoleObj.ContactId = accConRole.ContactId; oppContRoleObj.IsPrimary = accConRole.IsPrimary; oppContRoleObj.OpportunityId = RefreshId;  oppContRoleObj.Role = RoleOPP; oppContRoleObjlst.add(oppContRoleObj);                                                                          	            
                }
               insert oppContRoleObjlst;
           } 
         }
         return QuotationId;
     }
}
public class RefreshContactRolesCtrl {
     @AuraEnabled
     public static String refreshContactRoles(String recordId){
       String QuotationId;       
       if(!string.isEmpty(recordId)){ 
        String AccountId;
        String OpportunityId;
        QuotationId=recordId;
        list<Opportunity> oppObjLst=new list<Opportunity>();
	     oppObjLst=[Select id,Quotation_Account__c,Referred_Opportunity__c from Opportunity Where id=:QuotationId];	
        if(!oppObjLst.isEmpty()){
            AccountId=oppObjLst[0].Quotation_Account__c;
            OpportunityId =oppObjLst[0].Referred_Opportunity__c;
        }   
        String RefreshId=QuotationId;
        String RoleOPP='Contact Quotation';
        String RoleACC='Contact Commercial';

        list<OpportunityContactRole>  oppConRoleLst=[SELECT ContactId, IsPrimary FROM OpportunityContactRole WHERE Role = :RoleOPP AND OpportunityId =:OpportunityId];                          
        list<AccountContactRole> accConcRoleLst=new list<AccountContactRole>();
         if (oppConRoleLst.size() == 0){
             
               accConcRoleLst=[SELECT ContactId, IsPrimary FROM AccountContactRole WHERE Role = :RoleACC AND AccountId = :AccountId];               
         }
         list<OpportunityContactRole> deloppConRoleLst=new list<OpportunityContactRole>();  
         deloppConRoleLst=[SELECT Id FROM OpportunityContactRole WHERE OpportunityId = :RefreshId];                      
        if (deloppConRoleLst.size() < 7){
               delete deloppConRoleLst;
         }

         if(OppConRoleLst.size()!=0){ 
               list<OpportunityContactRole>  tempoppConRoleLst =new list<OpportunityContactRole>();
               for(OpportunityContactRole oppContRole: OppConRoleLst){            
                    OpportunityContactRole oppContRoleObj= new OpportunityContactRole();  oppContRoleObj.ContactId = oppContRole.ContactId; oppContRoleObj.IsPrimary = oppContRole.IsPrimary; oppContRoleObj.OpportunityId = RefreshId;  oppContRoleObj.Role = RoleOPP; tempoppConRoleLst.add(oppContRoleObj);                                                                          	            
                } 
                insert tempoppConRoleLst;
           }else{
               list<OpportunityContactRole>  tempoppConRoleLst =new list<OpportunityContactRole>();
               for(AccountContactRole accConRole: accConcRoleLst){            
                    OpportunityContactRole oppContRoleObj= new OpportunityContactRole();  oppContRoleObj.ContactId = accConRole.ContactId; oppContRoleObj.IsPrimary = accConRole.IsPrimary; oppContRoleObj.OpportunityId = RefreshId;  oppContRoleObj.Role = RoleOPP;  tempoppConRoleLst.add(oppContRoleObj);                                                                          	            
                }
               insert tempoppConRoleLst;
           }
                                      
       }
       return QuotationId;
     }
     
   
}
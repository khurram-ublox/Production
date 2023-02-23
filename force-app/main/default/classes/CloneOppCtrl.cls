public class CloneOppCtrl {     
    @AuraEnabled
     public static String cloneOppMethod(String recordId){
        //ID AccountId;
       String ClonedOppId;
       if(!string.isEmpty(recordId)){  
        ID OpportunityId=(Id)recordId;
        List<Opportunity> oppObjLst=[SELECT Id, Name,AccountId,Opportunity_Account__c, OwnerId, CurrencyIsoCode, RecordTypeId, Annual_Quantity__c, New_Application_Type__c, New_Market__c, CloseDate, Description, Area_opportunity_owner__c, Area_design_house__c, Area_manufacturing__c, Area_Design_Win__c, Remark_Contribution__c,Team_members__c FROM Opportunity WHERE Id = :OpportunityId];
        String QuotationCurrency = oppObjLst[0].CurrencyIsoCode;
         // Creates cloned opportuntiy
        Opportunity oppObj= new Opportunity();        
        oppObj.AccountId = oppObjLst[0].Opportunity_Account__c;
        oppObj.Opportunity_Account__c = oppObjLst[0].Opportunity_Account__c;
        oppObj.Name = oppObjLst[0].Name + ' - New generation';
        oppObj.OwnerId = oppObjLst[0].OwnerId;
        oppObj.CurrencyIsoCode = oppObjLst[0].CurrencyIsoCode; 
        oppObj.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity').getRecordTypeId();    /*Record ID für Opportunity*/
        oppObj.Annual_Quantity__c = oppObjLst[0].Annual_Quantity__c;
        oppObj.New_Application_Type__c = oppObjLst[0].New_Application_Type__c;
        oppObj.New_Market__c = oppObjLst[0].New_Market__c;
        oppObj.StageName ='3 Calling On';
        oppObj.CloseDate = oppObjLst[0].CloseDate;    
        oppObj.Description = oppObjLst[0].Description;    
        oppObj.Area_opportunity_owner__c = oppObjLst[0].Area_opportunity_owner__c;
        oppObj.Area_design_house__c = oppObjLst[0].Area_design_house__c;
        oppObj.Area_manufacturing__c = oppObjLst[0].Area_manufacturing__c;
        oppObj.Area_Design_Win__c = oppObjLst[0].Area_Design_Win__c;
        oppObj.Remark_Contribution__c = oppObjLst[0].Remark_Contribution__c;
        oppObj.Team_members__c = oppObjLst[0].Team_members__c;
        insert oppObj;
        ClonedOppId=oppObj.id;        
        //queries all opp products related to the original opportunity
        List<Opp_Product__c> oppProObjLst = [SELECT Id, Product__c, Annual_Quantity__c, Unit_Price__c, Use_Restriction__c, IPR_Coverage__c FROM Opp_Product__c WHERE Opportunity__c =: OpportunityId];
        //Loop through the opp products in the records set
        list<Opp_Product__c> oppProlsts=new  list<Opp_Product__c>();
        for(Opp_Product__c OppPro:oppProObjLst){
            Opp_Product__c tempOppPro =new Opp_Product__c();  tempOppPro.Opportunity__c = ClonedOppId;   tempOppPro.Product__c = OppPro.Product__c;  tempOppPro.Annual_Quantity__c = OppPro.Annual_Quantity__c; tempOppPro.Unit_Price__c = OppPro.Unit_Price__c; tempOppPro.Use_Restriction__c = OppPro.Use_Restriction__c; tempOppPro.IPR_Coverage__c = OppPro.IPR_Coverage__c; 
            oppProlsts.add(tempOppPro);                                                                                            
          }  
           if(!oppProlsts.isEmpty()){
               insert oppProlsts;
           }
         //queries all contact roles from the original opportunity
         list<OpportunityContactRole> oppConcRoleLst=[SELECT Id, ContactId, IsPrimary, Role FROM OpportunityContactRole WHERE OpportunityId =:OpportunityId];              
        //loop through the contact roles in the records set
         list<OpportunityContactRole> oconrolelst=new list<OpportunityContactRole>();
          for(OpportunityContactRole oppConcRole: oppConcRoleLst){
           //creates the same contact roles for the cloned opportunity   
           OpportunityContactRole tempOppConRole =new OpportunityContactRole();       
            tempOppConRole.ContactId = oppConcRole.ContactId;
            tempOppConRole.IsPrimary = oppConcRole.IsPrimary;
            tempOppConRole.Role = oppConcRole.Role;
            tempOppConRole.OpportunityId = ClonedOppId;    
            oconrolelst.add(tempOppConRole);  
            //insert tempOppConRole;
          }  
           if(!oconrolelst.isEmpty()){
               insert oconrolelst;
           }
        //queries the partner roles from the original opportunity
       list<Partner_Role__c> parRoleLst=[SELECT Id, Opportunity_Account__c, Partner_Account__c, Partner_Role__c FROM Partner_Role__c WHERE Opportunity__c = :OpportunityId];              
        //loop through the partner roles in the records set
       list<Partner_Role__c> parlst=new list<Partner_Role__c>();
       for(Partner_Role__c parRoleObj:parRoleLst){
        //creates the same partner roles for the cloned opportunity      
        Partner_Role__c tempParRoleObj=new Partner_Role__c();   
        tempParRoleObj.Opportunity__c = ClonedOppId;
        tempParRoleObj.Opportunity_Account__c = parRoleObj.Opportunity_Account__c;
        tempParRoleObj.Partner_Account__c = parRoleObj.Partner_Account__c;
        tempParRoleObj.Partner_Role__c = parRoleObj.Partner_Role__c;
        parlst.add(tempParRoleObj);                  
        } 
        if(!parlst.isEmpty()){
               insert parlst;
           }   
      } 
       return ClonedOppId;    
    }    
    //window.parent.location.href="/"+ ClonedOppId + "/e?retURL=%2F" + ClonedOppId;*/  
   
    
}
/*
* Apex Controller for New Partner Role button in Opportunity object in Lightning
* Author: ldra
* Date: 07/10/2019
* */


public class NewPartnerRoleCtrl {
    @AuraEnabled
    public static Opportunity getRecord(String recordId){
        Opportunity o =[SELECT Id, Opportunity_Account__c, CurrencyIsoCode FROM Opportunity WHERE Id = :recordId];   
        return o;
    }
    public Opportunity currentRecord {get;set;}//Current Opporutnity
    public Partner_Role__c partnerRole {get;set;}// Initialzing partner role
    
    public NewPartnerRoleCtrl(apexPages.StandardController sc)
    {
        //Fetch current record's information
        Id currentRecordId = sc.getRecord().Id;
        
        currentRecord = [SELECT Id, Opportunity_Account__c, Name,OppAutoNumber__c ,CurrencyIsoCode, AccountId FROM Opportunity
                         WHERE Id =:currentRecordId];

        
        //Initialize the parther role from current Opportunity
        partnerRole = new Partner_Role__c(
            CurrencyIsoCode          = currentRecord.CurrencyIsoCode,
            Opportunity_Account__c = currentRecord.Opportunity_Account__c,
            Opportunity__c = currentRecord.Id
        );
    }
    //Return to opportunity
    public pageReference doCancel()
    {
        pageReference pageRef = new pageReference('/' + currentRecord.Id);
        pageRef.SetRedirect(true);
        return pageRef;
    }
    //Save and return
    public pageReference doSave()
    {
        Id partnerObjId;
		partnerObjId = save(partnerRole);
       
            pageReference pageRef = new pageReference('/' + (partnerObjId != null ? partnerObjId : currentRecord.Id));
            pageRef.SetRedirect(true);
            return pageRef;
    }
    
    @AuraEnabled
    public static Id save(Partner_Role__c pr) {
        
        Id oppID = pr.Opportunity__c;
        String LastOppID;
        String VariableID;
        String UserID= UserInfo.getUserId();
        list<Variable__c> varLst= [SELECT Id, Name, LastOppID__c, LastPartnerRoleID__c FROM Variable__c WHERE Name =:UserID];            
        if (!varLst.isEmpty())
        {
            LastOppID = varLst[0].LastOppID__c;
            VariableID = varLst[0].Id;
            String LastPartnerRoleID = varLst[0].LastPartnerRoleID__c;
            
            if (LastPartnerRoleID!= null)
            {
                list<Partner_Role__c> proleLst=[SELECT Id, IsDeleted, Partner_Account__c FROM Partner_Role__c WHERE Id = :LastPartnerRoleID];
                
                if (!proleLst.isEmpty())
                {

                    if (proleLst[0].Partner_Account__c == null)
                    {            
                        Partner_Role__c PAR=new Partner_Role__c();
                        PAR.id=LastPartnerRoleID;
                        delete PAR;
                        
                    }
                }
            }
        }
        else
        {
            Variable__c VAR=new Variable__c();              
            VAR.Name = UserID;
            insert VAR;
            VariableID = VAR.id;
        }
        
        // insert partner role
        insert pr;
        
        Variable__c VAR=new Variable__c();      
        VAR.Id = VariableID;
        VAR.LastPartnerRoleID__c = pr.id;
        VAR.LastOppID__c = OppID;
        update VAR;
        
        return pr.Id;
    }
}
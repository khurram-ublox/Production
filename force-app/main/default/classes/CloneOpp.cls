//Created: 20.12.2021 - Umar Arshad - In order to convert clone Opp Javascript button on Opportunity to LWC
public with sharing class CloneOpp {

    public String opportunityId{get; set;}

    public CloneOpp(ApexPages.StandardController stdSetController) {
        opportunityId = (String)stdSetController.getRecord().Id;
    }

@AuraEnabled
public static String cloneOpportunity(String recordId){
String oppId;
String newOppId;
string AccountId;
List<Opp_Product__c> oppProductList = new List<Opp_Product__c>();
List<OpportunityContactRole> oppContactRoleList = new List<OpportunityContactRole>();
List<Partner_Role__c> partnerRoleList = new List<Partner_Role__c>();

if(!string.isEmpty(recordId)){

    oppId = recordId;
    List<Opportunity> oldOpp = [SELECT Id, Name, OwnerId,AccountId, CurrencyIsoCode, RecordTypeId, Annual_Quantity__c, New_Application_Type__c, New_Market__c, CloseDate, Description, Area_opportunity_owner__c, Area_design_house__c, Area_manufacturing__c, Area_Design_Win__c, Remark_Contribution__c,Team_members__c FROM Opportunity WHERE Id =:oppId ];
    AccountId = oldOpp[0].AccountId;
    //var records = result.getArray("records");
    
    //alert (records[0])
    
    //var QuotationCurrency = records[0].CurrencyIsoCode;
    
    // Creates cloned opportuntiy
    Opportunity OPP = new Opportunity();
    OPP.AccountId = AccountId;
    OPP.Opportunity_Account__c = AccountId;
    OPP.Name = oldOpp[0].Name + ' - New generation';
    OPP.OwnerId = oldOpp[0].OwnerId;
    OPP.CurrencyIsoCode = oldOpp[0].CurrencyIsoCode;
    OPP.RecordTypeId = '01220000000CqRn'; /*Record ID für Opportunity*/
    OPP.Annual_Quantity__c = oldOpp[0].Annual_Quantity__c;
    OPP.New_Application_Type__c = oldOpp[0].New_Application_Type__c;
    OPP.New_Market__c = oldOpp[0].New_Market__c;
    OPP.StageName = '3 Calling On';
    OPP.CloseDate = oldOpp[0].CloseDate;
    
    OPP.Description = oldOpp[0].Description;
    
    OPP.Area_opportunity_owner__c = oldOpp[0].Area_opportunity_owner__c;
    OPP.Area_design_house__c = oldOpp[0].Area_design_house__c;
    OPP.Area_manufacturing__c = oldOpp[0].Area_manufacturing__c;
    OPP.Area_Design_Win__c = oldOpp[0].Area_Design_Win__c;
    OPP.Remark_Contribution__c = oldOpp[0].Remark_Contribution__c;
    OPP.Team_members__c = oldOpp[0].Team_members__c;
    
    //var result = sforce.connection.create([OPP]);
    insert OPP;
    //alert (result[0])
    
    newOppId = OPP.id;
    
    // alert (ClonedOppId)
    
    
    //queries all opp products related to the original opportunity
    List<Opp_Product__c> oppProduct = [SELECT Id, Product__c, Annual_Quantity__c, Unit_Price__c, Use_Restriction__c, IPR_Coverage__c FROM Opp_Product__c WHERE Opportunity__c =: oppId];
    //var records = result.getArray("records");
    
    //alert (records[0])
    
    //Loop through the opp products in the records set
    If(oppProduct!= null){
    for(integer i=0;i<oppProduct.size();i++){
        
        
        
        //create an opp product item in the cloned opportuntiy for this opp product
        Opp_Product__c OPR = new Opp_Product__c();
        OPR.Opportunity__c = newOppId;
        OPR.Product__c = oppProduct[i].Product__c;
        OPR.Annual_Quantity__c = oppProduct[i].Annual_Quantity__c;
        OPR.Unit_Price__c = oppProduct[i].Unit_Price__c;
        OPR.Use_Restriction__c = oppProduct[i].Use_Restriction__c;
        OPR.IPR_Coverage__c = oppProduct[i].IPR_Coverage__c;
        
        oppProductList.add(OPR);
        
        //alert (result[0])
        
    }
}

    if(oppProductList != null)
    insert oppProductList;
}
    
    //queries all contact roles from the original opportunity
List<OpportunityContactRole> oppContactRole = [SELECT Id, ContactId, IsPrimary, Role FROM OpportunityContactRole WHERE OpportunityId =: oppId];
//var records = result.getArray("records");

/* alert (records[0]) */

//loop through the contact roles in the records set
if(oppContactRole!= null){

    for(integer i=0;i<oppContactRole.size();i++){
        
        //creates the same contact roles for the cloned opportunity
        OpportunityContactRole ROL = new OpportunityContactRole();
        ROL.ContactId = oppContactRole[i].ContactId;
        ROL.IsPrimary = oppContactRole[i].IsPrimary;
        ROL.Role = oppContactRole[i].Role;
        ROL.OpportunityId = newOppId;
        
        oppContactRoleList.add(ROL);
        
        /* alert (result[0]) */
        
    }

    if(oppContactRoleList!= null){
    insert oppContactRoleList;
    }
}
//queries the partner roles from the original opportunity
List<Partner_Role__c> partnerRole = [SELECT Id, Opportunity_Account__c, Partner_Account__c, Partner_Role__c FROM Partner_Role__c WHERE Opportunity__c =: oppId];

if(partnerRole!= null){
for(integer i=0;i<partnerRole.size();i++){

//creates the same partner roles for the cloned opportunity
Partner_Role__c PAR = new Partner_Role__c();
PAR.Opportunity__c = newOppId;
PAR.Opportunity_Account__c = partnerRole[i].Opportunity_Account__c;
PAR.Partner_Account__c = partnerRole[i].Partner_Account__c;
PAR.Partner_Role__c = partnerRole[i].Partner_Role__c;

partnerRoleList.add(PAR);

}
if(partnerRoleList != null){
    
    insert partnerRoleList;
}

//window.parent.location.href="/"+ ClonedOppId + "/e?retURL=%2F" + ClonedOppId;
}
return newOppId;
}

public pageReference classicCloneOpp()
    {
        String oppId =ApexPages.currentPage().getParameters().get('id');
        string cloneOppId = cloneOpportunity(opportunityId);
        pageReference pageRef = new pageReference('/' + cloneOppId);
        pageRef.SetRedirect(true);
        return pageRef;
    }
}
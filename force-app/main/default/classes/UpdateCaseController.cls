/*
    Name         : UpdateCaseController
    Author       : AnavClouds (Hari Vaishnav)
    Date         : 03rd Nov 2017
    Description  : This class update the Case status and New Mail. 
*/
public class UpdateCaseController{
    
    public String caseId {get;set;}
    
    public UpdateCaseController(ApexPages.StandardController stdController){
        Case caseRec = (Case)stdController.getRecord();
        caseId = caseRec.Id;
    }
    
    // This method udpate the case status and New Email field.
    public PageReference updateCaseStatus() {
        
        List<Case> caseRecordLst = [Select Id, status from Case where Id =:caseId];
       
        if(caseRecordLst.size() > 0) {
            caseRecordLst[0].status = 'Closed';
            update caseRecordLst;
        }
        return null;
    }
}
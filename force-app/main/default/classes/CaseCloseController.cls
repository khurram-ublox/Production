/*
        Name        : CaseCloseController
        Author      : AnavClouds (Hari Vaishnav)
        Date        : 24th Nov 2017
        Description : This class is used for close the case for lightning component.
*/
public class CaseCloseController {
    
    @AuraEnabled
    public static Case getCase(String caseId){
        List<Case> caseLst = [Select Id, status from Case where Id =:caseId];
        System.debug('## case List '+ caseLst);
        
        if(caseLst.size() > 0 && caseLst != null){
            Case cse = caseLst[0];
            System.debug('## case rec' + cse);
            return cse;
        }
        return null;
    }
    
    @AuraEnabled 
    public static void updateCaseStatus(String caseId){
        
        List<Case> caseRecordLst = [Select Id, status from Case where Id =:caseId];
       
        if(caseRecordLst.size() > 0) {
            caseRecordLst[0].status = 'Closed';
            update caseRecordLst;
        }
    }
}
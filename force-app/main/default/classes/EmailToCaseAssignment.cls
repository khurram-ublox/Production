public class EmailToCaseAssignment {
    
    @InvocableMethod
    public static void AssignCaseToFAEOfSuppliedEmail(list<Id> caseIds){       
        map<string, Id> FAEEmailToIdMap = new map<string, Id>();
        list<Case> assignCasesToFAE = new list<Case>();
        string emailAdress;
        
        for(Case_Assignment_Settings__mdt setting : [Select FAE_Email__c, 
                                                        FAE_User_Id__c 
                                                        from Case_Assignment_Settings__mdt]){
            FAEEmailToIdMap.put(setting.FAE_Email__c, setting.FAE_User_Id__c);                                                    
        }
        
        for(Case c : [Select Id, OwnerId, SuppliedEmail,Contact.Email from Case where Id IN:caseIds]){            
            emailAdress = c.SuppliedEmail == null ? c.Contact.Email : c.SuppliedEmail;
            
            if(FAEEmailToIdMap.get(emailAdress) != null){
                assignCasesToFAE.add(new Case(
                    Id = c.Id,
                    OwnerId = FAEEmailToIdMap.get(emailAdress)                    
                ));
            }
        }
        
        if(assignCasesToFAE.size() > 0){
            database.update(assignCasesToFAE, false);
        }        
    }
}
public class CustomLookupLwcController {
    // Method to fetch lookup search result   
     @AuraEnabled(cacheable=true)
     public static list<sObject> fetchLookupData(string searchKey, string sObjectApiName, string whereClause) {  
         
        String sanitizedSearchString = String.escapeSingleQuotes(searchKey);
        String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjectApiName);

         List<sObject> returnList = new List <sObject>();
         string whereStatement = '';
 
         string sWildCardText = '%' + sanitizedSearchString + '%';
         if(String.isNotBlank(whereClause))
         {
            whereStatement = 'AND ' + whereClause;
         }
         string sQuery = 'Select Id,Name From ' + sanitizedSObjectAPIName + ' Where Name Like : sWildCardText '+ whereStatement +' order by createdDate DESC LIMIT 5';
         for (sObject obj: database.query(sQuery)) {
             returnList.add(obj);
         }
         return returnList;
     }
     
     // Method to fetch lookup default value 
     @AuraEnabled
     public static sObject fetchDefaultRecord(string recordId , string sObjectApiName) {
         string sRecId = recordId;    
         string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Id = : sRecId LIMIT 1';
         for (sObject obj: database.query(sQuery)) {
             return obj;
         }
         return null;
     }
     
 }
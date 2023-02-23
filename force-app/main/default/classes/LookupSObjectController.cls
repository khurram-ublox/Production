/**
 * (c) Tony Scott. This code is provided as is and without warranty of any kind.
 * https://github.com/tscottdev/Lightning-Lookup
 *
 * This work by Tony Scott is licensed under a Creative Commons Attribution 3.0 Unported License.
 * http://creativecommons.org/licenses/by/3.0/deed.en_US
 */

 /**
 * Apex Controller for looking up an SObject via SOSL
 */
public with sharing class LookupSObjectController
{
    /**
     * Aura enabled method to search a specified SObject for a specific string
     */
    @AuraEnabled
    public static Result[] lookup(String searchString, String sObjectAPIName, String descriptionFields)
    {
        String separator = ' | ';
        // Sanitze the input
        String sanitizedSearchString = String.escapeSingleQuotes(searchString);
        String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjectAPIName);

		List<Result> results = new List<Result>();

        // Build our SOSL query
        String searchFields = sObjectAPIName == 'Case' ? 'Id, CaseNumber' : 'Id, Name';
        String[] descriptionFieldsList = new String[]{};
        if(String.isNotBlank(descriptionFields))
        {
           searchFields += ',' + descriptionFields;
           descriptionFieldsList = descriptionFields.split(',');            
        }
        System.debug(LoggingLevel.WARN, searchFields);
        String searchQuery = 'FIND \'' + sanitizedSearchString + '*\' IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(' + searchFields + ') Limit 50';

        // Execute the Query
        List<List<SObject>> searchList = search.query(searchQuery);
	
        // Create a list of matches to return
		for (SObject so : searchList[0])
        {
            String nameField = sObjectAPIName == 'Case' ? 'CaseNumber' : 'Name';
            String description = '';
            for(String dF : descriptionFieldsList)
            {
                description += (String) so.get(dF) + separator;
            }
            if(String.isNotBlank(description))
            {
                description = description.removeEnd(separator);
            }
            
            results.add(new Result( (String)so.get(nameField), so.Id, description ));
        }

        return results;
    }
    
    /**
     * Aura enabled method to search a specified SObject for a specific string
     */
    @AuraEnabled
    public static Result[] lookupSOQL(String searchString, String sObjectAPIName, String descriptionFields)
    {
        String separator = ' | ';
        String noData = ' --none-- ';
        // Sanitze the input
        String sanitizedSearchString = String.escapeSingleQuotes(searchString) + '%';
        String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjectAPIName);

		List<Result> results = new List<Result>();

        // Build our SOSL query
        String nameField = sObjectAPIName == 'Case' ? 'CaseNumber' : 'Name';        
        String searchFields = nameField;
        String[] searchFieldsList;
        String[] descriptionFieldsList = new String[]{};
        if(String.isNotBlank(descriptionFields))
        {
           searchFields += ',' + descriptionFields; 
           descriptionFieldsList = descriptionFields.split(',');
        }
        
        searchFieldsList = searchFields.split(',');            
        
        String query = 'Select Id,';
        for(String f : searchFieldsList)
        {
            query += f + ', ';
        }
        query = query.removeEnd(', ');
        query += ' FROM ' + sanitizedSObjectAPIName + ' WHERE ';
        
        Boolean isFirst = true;
        for(String f : searchFieldsList)
        {
            if(isFirst)
            {                
            	query += f + ' LIKE \'' + sanitizedSearchString + '\'';
                isFirst = false;
            }
            else
            {
                query += ' OR ' + f + ' LIKE \'' + sanitizedSearchString + '\'';
            }
        }
        
        query += ' LIMIT 50';
        
        
        // Execute the Query
        List<SObject> searchList = new List<SObject>();
          searchList =  Database.query(query);
	
        // Create a list of matches to return
		for (SObject so : searchList)
        {
            String description = '';
            for(String dF : descriptionFieldsList)
            {
                description += ((String) so.get(dF) == null ? noData :  (String) so.get(dF)) + separator;
            }
            if(String.isNotBlank(description))
            {
                description = description.removeEnd(separator);
            }
            
            results.add(new Result( (String)so.get(nameField), so.Id, description ));
        }

        return results;
    }

    /**
     * Inner class to wrap up an SObject Label and its Id
     */
	public class Result
    {
        @AuraEnabled
        public String SObjectLabel {get; set;}

        @AuraEnabled
        public Id SObjectId {get; set;}
        
        @AuraEnabled
        public String sObjectDescription {get; set;}

        public Result(String sObjectLabel, Id sObjectId, String sObjectDescription)
        {
            this.SObjectLabel = sObjectLabel;
            this.SObjectId = sObjectId;
            this.sObjectDescription = sObjectDescription;
        }
    }
}
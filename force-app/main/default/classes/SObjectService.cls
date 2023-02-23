public with sharing class SObjectService
{
	@AuraEnabled
	public static List<PicklistValue> getPicklistValues(String fieldName)
	{
		List<PicklistValue> outputResults = new List<PicklistValue>();
		for (Schema.SObjectField fieldResult : Schema.SObjectType.Case.fields.getMap().values())
		{
			Schema.DescribeFieldResult results = fieldResult.getDescribe();
			if ( results.getName() == fieldName && (results.isRestrictedPicklist() || results.getType() == Schema.DisplayType.PICKLIST) )
			{
				for (Schema.PicklistEntry entry : results.getPicklistValues())
				{
					outputResults.add(new PicklistValue(entry));
				}
			}
		}
		if ( fieldName == 'RecordType' )
		{
			for (RecordType theType : [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND IsActive = true])
			{
				outputResults.add(new PicklistValue(theType));
			}
		}
		return outputResults;
	}

	@AuraEnabled
	public static SObjectWrapper getRecordDetails(Id objectId)
	{
		String objectName = objectId.getSObjectType().getDescribe().getName();
		String query = SoqlUtils.buildQuery(objectName);
		query += ' WHERE Id = \'' + objectId + '\'';
		System.debug(LoggingLevel.WARN, query);
		List<SObject> records = Database.query(query);
		if ( !records.isEmpty() )
		{
			return new SObjectWrapper((String)records[0].get('Id'), objectName == 'Case' ? String.valueOf(records[0].get('CaseNumber')) : (String)records[0].get('Name'));
		}
		return null;
	}

	public class SObjectWrapper
	{
		@AuraEnabled
		public String id { get; set; }
		@AuraEnabled
		public String name { get; set; }

		public SObjectWrapper(String id, String name)
		{
			this.id = id;
			this.name = name;
		}
	}


	public class PicklistValue
	{
		@AuraEnabled
		public String value {get; set;}
		@AuraEnabled
		public String label {get; set;}

		public PicklistValue(Sobject theObject)
		{
			this.value = theObject.id;
			this.label = (String)theObject.get('Name');
		}

		public PicklistValue(Schema.PicklistEntry entry)
		{
			this.label = entry.getLabel();
			this.value = entry.getValue();
		}
	}
}
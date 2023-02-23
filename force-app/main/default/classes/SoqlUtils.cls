/**
 * @description Class contains helper methods to build dynamic SOQL queries
 *
 * @author eru
 * @copyright PARX
 */
public with sharing class SoqlUtils {

	//Set of address compound fields
	private static final Set<String> EXCLUDED_FIELDS = new Set<String>{'billingaddress', 'shippingaddress', 'address'};

	/**
	 * @description Returns a map of objects metadata
	 */
	private static Map<String,Schema.SObjectType> globalDescribe
	{
		get
		{
			if (globalDescribe == null)
			{
				globalDescribe = Schema.getGlobalDescribe();
			}
			return globalDescribe;
		}
		set;
	}

	/**
	 * @description Builds SELECT query with all fields for specified object
	 */
	public static String buildQuery(String objectName)
	{
		String query = 'SELECT ' + getSelectClause(objectName) + ' FROM ' + objectName;
		return query;
	}

	/**
	 * @description Returns a list of all fields corresponding to the object.
	 */
	public static List<String> getFields(String objectName)
	{
		Schema.SObjectType objectDescribe = globalDescribe.get(objectName);
		List<String> fields = new List<String>();
		Map<String, Schema.SObjectField> fieldsDescribe = objectDescribe.getDescribe().fields.getMap();
		for (String fieldName : fieldsDescribe.keySet())
		{
			if(EXCLUDED_FIELDS.contains(fieldName) || fieldName.contains('longitude') || fieldName.contains('latitude'))
			{
				continue;
			}
			fields.add(fieldName);
		}
		return fields;
	}

	/**
	 * @description Returns a string of all fields corresponding to the object separated by comma.
	 */
	public static String getSelectClause(String objectName)
	{
		String selectClause = '';
		for (String fieldName : getFields(objectName))
		{
			selectClause += fieldName + ', ';
		}
		selectClause = selectClause.removeEnd(', ');
		return selectClause;
	}
}
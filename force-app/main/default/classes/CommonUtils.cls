Global Class CommonUtils
{
    Public final static string ACTIVATED = 'Activated';
    public final static string NDA_CATEGORY = 'NDA';

    
    public static List<String> getRestrictedProfilesForContract()
    {
        List<String> res = new List<String>();
        
        Process_Settings__c pSetting = Process_Settings__c.getInstance();
        string fText = pSetting.Restricted_Profiles_For_Contract__c;
        
        if(!String.isEmpty(fText))
            res = fText.split(';');
        
        return res;
    }
    
    public static Boolean isAllowedProfileForMerge (String profile)
    {
        Boolean res = false;
        
        Process_Settings__c pSetting = Process_Settings__c.getInstance();
        string fText = pSetting.Account_Allowed_Profiles_To_Merge__c;
        
        if(fText.contains(profile))
            res = true;
        
        return res;
    }
    
    public static Boolean isAllowedProfileForDelete (String profile)
    {
        Boolean res = false;
        
        Process_Settings__c pSetting = Process_Settings__c.getInstance();
        string fText = pSetting.Account_Allowed_Profiles_To_Delete__c;
        
        if(fText.contains(profile))
            res = true;
        
        return res;
    }


    public static List<Schema.FieldSetMember> getFieldSetFields(String fieldSetName, String ObjectName)
    {
        List<Schema.FieldSetMember> fieldSetMemList = new List<Schema.FieldSetMember>();
        Map<String, Schema.SObjectType> gDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType objectType = gDescribeMap.get(ObjectName);
        if(objectType!=null)
        {
            Schema.DescribeSObjectResult descObjectResult = objectType.getDescribe();   
            Schema.FieldSet fieldSetObj = descObjectResult.FieldSets.getMap().get(fieldSetName);        
            if(fieldSetObj!=null)
                fieldSetMemList = fieldSetObj.getFields(); 
        }
        
        return fieldSetMemList;
    }

}
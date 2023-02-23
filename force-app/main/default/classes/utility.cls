public class utility {
    
    //Calculate and return time difference in seconds between two date and time values.
    public static Long getTimeDifferenceInSeconds(DateTime currentDateTime, DateTime pastDateTime){
        Long currentTime = currentDateTime.getTime();
        Long pastTime = pastDateTime.getTime();
        Long diffInmiliSeconds = currentTime - pastTime;
        Long diffInSeconds = diffInmiliSeconds / 1000;
        return diffInSeconds;
    }
    //takes object API name and Field Name as a parameters
    // Function to return all the picklist values
    public static map<String,String> getFieldValues (String objectName, String fieldName){

        map<String,String> ProductFilterFieldMap = new map<String,String>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap();
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            ProductFilterFieldMap.put(pickListVal.getValue(),pickListVal.getValue() );
        }
        return ProductFilterFieldMap;
    }
}
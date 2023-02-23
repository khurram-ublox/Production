/**
* @description Helper class for order processing
*/
public inherited sharing class OrderHelper {
    
    /**
    * @description returns the concatenated dimensions String for one Billings Record.
    * @param Billings__c - o
    * @return String - dimensions
    */
    public static String getDimensions(Billings__c o) {
        
        String dimensions = '';
        if(o.a4a_Region__c != null) dimensions += o.a4a_Region__c;
        if(o.a4a_Product_Category__c != null) dimensions += o.a4a_Product_Category__c;
        if(o.a4a_Country__c != null) dimensions += o.a4a_Country__c;
        if(o.a4a_Product__c != null) dimensions += o.a4a_Product__c;
        if(o.a4a_Project_Owner__c != null) dimensions += o.a4a_Project_Owner__c;
        if(o.a4a_Date__c != null) {
            dimensions += o.a4a_Date__c.year();
            dimensions += o.a4a_Date__c.month();
        }
        
        return dimensions;
    } 

}
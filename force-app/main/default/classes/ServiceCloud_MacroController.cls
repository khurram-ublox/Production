public with sharing class ServiceCloud_MacroController {      
            
    public ServiceCloud_MacroController(){}

    @AuraEnabled
    public static map<string, string> getMacroDropDownValues(){        
        map<string, string> macrosDropDown = new map<string, string>();
        for(Case_Macro__mdt macro : [Select Label, Unique_Name__c from Case_Macro__mdt]){
            macrosDropDown.put(macro.Label, macro.Unique_Name__c);
        }        
        return macrosDropDown;
    }

    @AuraEnabled
    public static map<string, string> getMacroFromAddress(string caseId){
        Case caseEmail = [SELECT Id, Account_uB_Office__c FROM Case where Id =: caseId LIMIT 1];
        map<string, string> fromDropDownDefault = new map<string, string>();      
        map<string, string> fromDropDown = new map<string, string>();
        map<string, string> countryFilter = new map<string, string>();
        for(Macro_From_Address__mdt macro : [Select Label, Country__c, From_Address__c from Macro_From_Address__mdt]){
            fromDropDown.put(macro.From_Address__c, macro.Label + ' <'+macro.From_Address__c+'>');
            countryFilter.put(macro.Country__c, macro.From_Address__c);            
        }
        if(countryFilter.get(caseEmail.Account_uB_Office__c) != null){
        fromDropDownDefault.put(countryFilter.get(caseEmail.Account_uB_Office__c), fromDropDown.get(countryFilter.get(caseEmail.Account_uB_Office__c)));
        fromDropDown.remove(caseEmail.Account_uB_Office__c);

        }
        else{
            fromDropDownDefault.put(countryFilter.get('EMEA'), fromDropDown.get(countryFilter.get('EMEA')));
            fromDropDown.remove('EMEA');
        }
        fromDropDownDefault.putAll(fromDropDown);
        return fromDropDownDefault;
    }

    @AuraEnabled
    public static string getToEmailAddress(string caseId){      
        list<Case> crecord = [SELECT Id, SuppliedEmail, ContactEmail FROM Case where Id =: caseId];            
        Case caseRecord = crecord[0];
        if(caseRecord.ContactEmail != null){
            return caseRecord.ContactEmail;
        }else if(caseRecord.SuppliedEmail != null){
            return caseRecord.SuppliedEmail;
        }        
        return null;
    }

    @AuraEnabled
    public static void runMacro(string caseId, string macroName, string toAddress, string ccAddress, string BccAddress, string fromAddress){
        
        if(macroName == null || string.isBlank(macroName)){
            macroName = 'Case_Send_Email_for_more_info';
        }
        if(fromAddress == null || string.isBlank(fromAddress)){
            fromAddress = 'support@u-blox.com';
        }
        
        ServiceCloud_MacroHandler mHandler = new ServiceCloud_MacroHandler();
        mHandler.setCaseRecordId(caseId);
        mHandler.setMacroUniqueName(macroName);
        mHandler.setToEmailAddress(toAddress);
        mHandler.setCCEmailAddress(ccAddress);
        mHandler.setBCcEmailAddress(BccAddress);
        mHandler.setFromEmailAddress(fromAddress);        
        mHandler.executeActions();
    }

    // This method is being called from Case: After Created/Updated flow
    // This is to send auto email to unknown contacts to get more information

    @InvocableMethod(Label = 'Send PIF')
    public static void sendPIF(list<Case> caseRecords){
        String toAddress;
        string macroName = 'Case_Send_Email_for_more_info'; 
        string fromAddress = 'support@u-blox.com';
        string ccAddress;
        string BccAddress;

        Case caseRecord = caseRecords[0];
        if(caseRecord.ContactEmail != null){
            toAddress = caseRecord.ContactEmail;
        }else if(caseRecord.SuppliedEmail != null){
            toAddress = caseRecord.SuppliedEmail;
        }        
        
        ServiceCloud_MacroHandler mHandler = new ServiceCloud_MacroHandler();
        mHandler.setCaseRecordId(caseRecord.Id);
        mHandler.setMacroUniqueName(macroName);
        mHandler.setToEmailAddress(toAddress);
        mHandler.setCCEmailAddress(ccAddress);
        mHandler.setBCcEmailAddress(BccAddress);
        mHandler.setFromEmailAddress(fromAddress);
        mHandler.setDoUpdateCase(false);       
        mHandler.executeActions();        
    }
}
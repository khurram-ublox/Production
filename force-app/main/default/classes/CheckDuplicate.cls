@RestResource(urlMapping='/CheckDuplicate/')
global with sharing class CheckDuplicate {
    @HttpPost
    global static DuplicateResult getDuplicateRecords(List<sObject> records)
    {
        DuplicateResult dResult = new DuplicateResult();
        
        if(records.size()>0)
        {
            String type = records[0].getSObjectType().getDescribe().getName();
            try{
                Map<string,DuplicateRuleHelper.duplicateRecord> duplicateResultMap = DuplicateRuleHelper.getDuplicateRecords(records);
                
                /* If record not found with shipping address then check it with billing address */
                if(duplicateResultMap.isEmpty()){
                    for(Account obj : (list<Account>)records){
                        obj.BillingPostalCode = obj.ShippingPostalCode;
                        obj.BillingCity = obj.ShippingCity;
                        obj.BillingStreet = obj.ShippingStreet;
                    }
                    duplicateResultMap = DuplicateRuleHelper.getDuplicateRecords(records);
                    
                }
                List<Schema.FieldSetMember> fieldsList = CommonUtils.getFieldSetFields('CheckDuplicate',type);
                
                Set<String> idSet = duplicateResultMap.keySet();
                String apiNames = getFieldsStringForQuery(fieldsList);
                string queryStr = 'select '+apiNames+' from '+type+' where Id IN: idSet';
                
                List<sObject> allRecords = Database.query(queryStr);

                for(sObject objRec : allRecords)
                {
                    string recId = (string)objRec.get('Id');
                    duplicateResultMap.get(recId).record = objRec;
                }                
                dResult.isSuccess = true;
                dResult.duplicateRecords = duplicateResultMap.values();
            }catch(Exception ex){
                dResult.isSuccess = false;
                dResult.errorMessage = ex.getMessage();
                dResult.duplicateRecords = null;           
            }
        }else
        {
            dResult.isSuccess = false;
            dResult.errorMessage = 'Input has no records !';
            dResult.duplicateRecords = null;
        }
        return dResult;
    }
    
    private static String getFieldsStringForQuery(List<Schema.FieldSetMember> fieldsList)
    {
        string apiNames = 'Id';
        for(Schema.FieldSetMember fieldObj : fieldsList)
        {
            apiNames = apiNames +','+fieldObj.getFieldPath();
        }
        return apiNames;
    }
    global class DuplicateResult{
        public Boolean isSuccess {get;set;}
        public String errorMessage {get;set;}
        public List<DuplicateRuleHelper.duplicateRecord> duplicateRecords {get;set;}
    }     
}
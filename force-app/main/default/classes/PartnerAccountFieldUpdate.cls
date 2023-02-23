global class PartnerAccountFieldUpdate implements Database.Batchable<SObject> {
    global static Map<Id, String> errorMap = new map<Id,String>();
    global static Map<Id, String> successMap = new map<Id,String>();
    global static String Entity = 'Account';
    global static String baseURL;
    global  Id accountIdforAttachment;
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        map<String,String> userAccountMap = new Map<String, String>();
        
        for(Account_Owner_Partner_Account_Map__c userAccountCustomSetting :Account_Owner_Partner_Account_Map__c.getAll().values() ){
            userAccountMap.put(userAccountCustomSetting.Name, userAccountCustomSetting.value__c);
        }
        return Database.getQueryLocator([SELECT Id, ownerId,
                                         Partner_Account__c,
                                         partner_User__c
                                         FROM Account
                                         where ownerId = :userAccountMap.keySet() ]);
    }
    
    public void  execute(Database.BatchableContext bc, list<Account> tempAccountList){
        
        List<Account> accountList = new List<Account>();
        
        map<String,Account_Owner_Partner_Account_Map__c> userAccountMap = new Map<String, Account_Owner_Partner_Account_Map__c>();
        
        for(Account_Owner_Partner_Account_Map__c userAccountCustomSetting :Account_Owner_Partner_Account_Map__c.getAll().values() ){
            userAccountMap.put(userAccountCustomSetting.Name.substring(0,15), userAccountCustomSetting);
        }
        
        for (Account tempAccount : tempAccountList){
            
            String accountOwnerId = tempAccount.OwnerId;
            if(userAccountMap.get(accountOwnerId.SubString(0,15)) != NULL){
                if(   userAccountMap.get(accountOwnerId.SubString(0,15)).value__c != tempAccount.Id ){
                    tempAccount.partner_account__c = userAccountMap.get(accountOwnerId.SubString(0,15)).value__c;
                }
                
                tempAccount.partner_User__c = userAccountMap.get(accountOwnerId.SubString(0,15)).New_User_Id__c;
                accountList.add(tempAccount);
            }
        }
        if(accountList.size() > 0){
            List<Database.SaveResult> dsrs = Database.update(accountList, false);
            
            for(Database.SaveResult dsr : dsrs){
                if(!dsr.isSuccess()){
                    String errMsg = dsr.getErrors()[0].getMessage();
                    errorMap.put(dsr.getId(), errMsg);
                    
                } else {
                    //baseURL + '/' + dsr.getId();
                    String sucMsg =  System.URL.getSalesforceBaseUrl() + '/' + dsr.getId();
                    successMap.put(dsr.getId(), sucMsg);
                }
            }
        }
        
        system.debug(errorMap);
        system.debug(successMap);
        
        if(!errorMap.isEmpty()){
            // Creating the CSV file for error
            String finalstr = 'Id, Error \n';
            
            String attName = Entity+'Errors' + system.now().format('YYYYMMDDhhmm') + '.csv';
            for(Id id  : errorMap.keySet()){
                string err = errorMap.get(id);
                string recordString = '"'+id+'","'+err+'"\n';
                finalstr = finalstr +recordString;
            }
            
            Attachment attach = new Attachment(parentId = accountIdforAttachment, name=attName, body = Blob.valueOf(finalstr));
            /* insert the attachment */
            insert attach;
        } 
        if(! successMap.isEmpty()) {
            // Creating the CSV file for successful updates
            String finalstr = 'Id, Link \n';
            String attName = Entity+'Success' + system.now().format('YYYYMMDDhhmm') + '.csv';
            for(Id id  : successMap.keySet()){
                string suc = successMap.get(id);
                string recordString = '"'+id+'","'+suc+'"\n';
                finalstr = finalstr +recordString;
            }
            
            Attachment attach = new Attachment(parentId = accountIdforAttachment, name=attName, body = Blob.valueOf(finalstr));
            /* insert the attachment */
            insert attach;
        }
    }
    public void finish(Database.BatchableContext bc){
        
    }
    
}
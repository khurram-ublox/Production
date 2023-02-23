global class AccountOwnerUpdateWithChannelManager implements Database.Batchable<SObject> {
    global static Map<Id, String> errorMap = new map<Id,String>();
    global static Map<Id, String> successMap = new map<Id,String>();
    global static String Entity = 'Account';
    global static String baseURL; 
    global  Id accountIdforAttachment;
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        Set<Id> oldUserIds = new Set<Id>();
        for(Account_Owner_Partner_Account_Map__c userAccountCustomSetting :Account_Owner_Partner_Account_Map__c.getAll().values() ){
            oldUserIds.add(userAccountCustomSetting.Name);
        }
        return Database.getQueryLocator([SELECT Id, ownerId,New_Channel_Manager__c,New_Channel_Manager__r.Distributor_Name__c,new_channel_manager__r.managerId, owner.ManagerId FROM Account
                                         where owner.Distributor_Name__c != 'Internal' and owner.Distributor_Name__c != NULL
                                         AND OwnerId IN :oldUserIds AND Owner.IsActive = True ]);
    }
    
    public void execute(Database.BatchableContext bc, list<Account> tempAccountList){
        
        List<Account> accountList = new List<Account>();
        for (Account tempAccount : tempAccountList){
            
            if(tempAccount.New_Channel_Manager__c != NULL && tempAccount.New_Channel_Manager__r.distributor_Name__c == 'Internal' && tempAccount.New_Channel_Manager__r.distributor_Name__c != NULL){
                tempAccount.ownerId = tempAccount.New_Channel_Manager__c;  
                
            }else if(tempAccount.New_Channel_Manager__c != NULL && tempAccount.New_Channel_Manager__r.distributor_Name__c != 'Internal' && tempAccount.New_Channel_Manager__r.distributor_Name__c != NULL){
                tempAccount.ownerId = tempAccount.owner.managerId;
                
            }
            else if(tempAccount.New_Channel_Manager__c == NULL   ){
                tempAccount.ownerId = tempAccount.owner.managerId;
            }
            accountList.add(tempAccount);
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
    public void finish(Database.BatchableContext bc){}
    
}
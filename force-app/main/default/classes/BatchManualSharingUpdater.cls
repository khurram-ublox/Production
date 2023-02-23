global without sharing class BatchManualSharingUpdater implements Database.Batchable<SObject>, Database.Stateful{
    global Map<Id, String> errorMap;
	global Map<Id, String> successMap;
    global Map<Id, SObject> IdToSObjectMap;
   	global final String Query;
   	global final String Entity;
   	global final List<String> Fields;
  	global final String Value;
    global String baseURL;
    global Id accountIdforAttachment;
    global List<sObject> tempScope;
    global List<String> fieldstoUpdate;

    global Map<Id, Id> usersIdMap;
    global Set<Id> oldUserIds;

    global BatchManualSharingUpdater(String entity, String query, Id resultsRecordId, Map<Id, Id> usersIdMap, List<String> fieldstoUpdate){
        this.oldUserIds = usersIdMap.keySet();
        this.usersIdMap = usersIdMap;
        this.Entity=entity; accountIdforAttachment = resultsRecordId; this.Query=query;
        this.fieldstoUpdate = fieldstoUpdate;
        errorMap = new Map<Id, String>();
		successMap = new Map<Id, String>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('-------query------------ : '+Query);
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('======size========='+scope.size());
        //deepClone(Boolean preserveId, Boolean preserveReadonlyTimestamps, Boolean preserveAutonumber)
        List<sObject> cloned = scope.deepClone(false, true, false);
        for(Sobject s : cloned){
            for (String field : fieldstoUpdate) {
                String value = String.valueOf(s.get(field));
                if(!String.isBlank(value)) {
                    if(!String.isBlank((String)usersIdMap.get(value))) {
                        s.put(field,usersIdMap.get(value));
                    }
                }
            }
        }
        List<Database.SaveResult> dsrs = Database.Insert(cloned, false);
        tempScope=scope;
        Integer index = 0;
        for(Database.SaveResult dsr : dsrs){
            if(dsr.isSuccess()){
                String sucMsg = URL.getSalesforceBaseUrl().toExternalForm() + '/' + dsr.getId();
                successMap.put(dsr.getId(), sucMsg);
            } else {
                String errMsg = dsr.getErrors()[0].getMessage();
                // errorMap.put(dsr.getId(), errMsg);
                if(Entity == 'AccountTeamMember') {
                    errorMap.put((Id)tempScope[index].get('Id'), errMsg+' User Id: '+(Id)tempScope[index].get('UserId'));
                } else if (Entity == 'CaseTeamMember') {
                    errorMap.put((Id)tempScope[index].get('Id'), errMsg+'Parent Id: '+(Id)tempScope[index].get('ParentId'));
                } else if (Entity == 'CaseShare') {
                    errorMap.put((Id)tempScope[index].get('Id'), errMsg+'  Case Id: '+(Id)tempScope[index].get('CaseId')+'  UserorGroupId: '+(Id)tempScope[index].get('UserorGroupId'));
                }
                 else {
                    errorMap.put((Id)tempScope[index].get('Id'), errMsg);
                }
            }
            index++;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug(errorMap);
        system.debug(successMap);
        if(!errorMap.isEmpty()){
            // Creating the CSV file for error
            String finalstr = 'Id, Error \n';
            string recordString = '"Running Query","'+Query+'"\n';
            finalstr = finalstr +recordString;
            
            String attName = Entity+'Errors' + system.now().format('YYYYMMDDhhmm') + '.csv';
            for(Id id  : errorMap.keySet()){
                string err = errorMap.get(id);
                recordString = '"'+id+'","'+err+'"\n';
                finalstr = finalstr +recordString;
            }

            Attachment attach = new Attachment(parentId = accountIdforAttachment, name=attName, body = Blob.valueOf(finalstr));
            /* insert the attachment */
            insert attach;
        } 
        if(! successMap.isEmpty()) {
            // Creating the CSV file for successful updates
            String finalstr = 'Id, Link \n';
            string recordString = '"Running Query","'+Query+'"\n';
            finalstr = finalstr +recordString;

            Set<id> ids = new Set<Id>();
            for(Id id  : successMap.keySet()){
                string suc = successMap.get(id);
                recordString = '"'+id+'","'+suc+'"\n';
                finalstr = finalstr +recordString;
            }
            for (sObject s : tempScope) {
                ids.add((ID)s.get('Id'));
            }
            
            String attName = Entity+'Success' + system.now().format('YYYYMMDDhhmm') + '.csv';
            Attachment attach = new Attachment(parentId = accountIdforAttachment, name=attName, body = Blob.valueOf(finalstr));
            /* insert the attachment */
            insert attach;
        }
    }

}
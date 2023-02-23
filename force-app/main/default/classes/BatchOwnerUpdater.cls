global class BatchOwnerUpdater implements Database.Batchable<SObject>, Database.Stateful{
    global Map<Id, String> errorMap;
    global Map<Id, SObject> IdToSObjectMap;
	global Map<Id, String> successMap;
   	global final String Query;
   	global final String Entity;
   	global final List<String> Fields;
  	global final String Value;
    global Id accountIdforAttachment;

  	global Set<Id> oldUserIds;
    global Map<Id, Id> usersIdMap;

    global BatchOwnerUpdater(String e, List<String> fields, String filters,Id aa, Map<Id, Id> usersIdMap){
        this.oldUserIds = usersIdMap.keyset();
        this.usersIdMap = usersIdMap;
        Entity=e; this.Fields=fields; accountIdforAttachment = aa;
        String q = 'SELECT ';
        String whereCondition = ' (';
        for(String field : fields) {
            q += field+',';
            whereCondition += field+' IN :oldUserIds OR ';
        }
        q = q.removeEnd(',');
        whereCondition = whereCondition.removeEnd(' OR ');
        q+=' FROM '+e+' Where '+ whereCondition +') '+filters;
        
        Query=q;
        errorMap = new Map<Id, String>();
		successMap = new Map<Id, String>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('-----------query-------- : '+Query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('======size========='+scope.size());
        for(Sobject s : scope){
            for (String f : Fields) {
                String value = String.valueOf(s.get(f));
                if(!String.isBlank(value)) {
                    if(!String.isBlank((String)usersIdMap.get(value))) {
                        s.put(f,usersIdMap.get(value)); 
                    }
                }
            }
        }
        // update scope;
        List<Database.SaveResult> dsrs = Database.Update(scope, false);
        for(Database.SaveResult dsr : dsrs){
            if(dsr.isSuccess()){
                String sucMsg = URL.getSalesforceBaseUrl().toExternalForm() + '/' + dsr.getId();
                successMap.put(dsr.getId(), sucMsg);
            } else {
                String errMsg = dsr.getErrors()[0].getMessage();
                errorMap.put(dsr.getId(), errMsg);
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug(errorMap);
        system.debug(successMap);
        
        if(!errorMap.isEmpty()){
            // Creating the CSV file for error
            String finalstr = 'Id, Error Message \n';
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
            
            String finalstr = 'Id, Record Link \n';
            string recordString = '"Running Query","'+Query+'"\n';
            finalstr = finalstr +recordString;

            for(Id id  : successMap.keySet()){
                string suc = successMap.get(id);
                recordString = '"'+id+'","'+suc+'"\n';
                finalstr = finalstr +recordString;
            }

            String attName = Entity+'Success' + system.now().format('YYYYMMDDhhmm') + '.csv';
            Attachment attach = new Attachment(parentId = accountIdforAttachment, name=attName, body = Blob.valueOf(finalstr));
            /* insert the attachment */
            insert attach;
        }
    }

}
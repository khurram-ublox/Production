@RestResource(urlMapping='/UBX-REST-Generic-Object-Creation/*')

global class UBXRESTGenericObjectCreation {


   global class ObjectsToCreate{
        public String objectName {get; set;}
        public List<String> fieldList {get; set;}
        public List<List<String>> listOfObjectValueList {get; set;}
        public ObjectsToCreate(){}
    
    }


    global class ReturnClass {

        public String success {get; set;}
        public String message {get; set;}
        public List<String> createdIDs {get; set;}

        public ReturnClass(String success, String message, List<String> createdIDs) {
        this.success = success;
        this.message = message;
        this.createdIDs = createdIDs;
        }

    }    
            
        
    @HttpPost 
    global static ReturnClass createObjects(ObjectsToCreate objectsToCreate) {
        
        RestRequest req             = RestContext.request;
        String objectName           = objectsToCreate.objectName;
        List<String> fieldList      = objectsToCreate.fieldList;
        List<List<String>> data     = objectsToCreate.listOfObjectValueList;
        
        List<sObject> objectList    = new List<sObject>();
        List<id> createdIds         = new List<id>();

        Schema.sObjectType objectDef = Schema.getGlobalDescribe().get(objectName).getDescribe().getSObjectType();
        Map<String, Schema.SobjectField> ObjectFieldsMap = objectDef.getDescribe().fields.getMap();
        
        for(Integer d=0; d<data.size(); d++){
            // Create new sObject
            sObject newObject = (sObject)System.Type.forName(objectName).newInstance();
            
            // Set all the fields
            for(Integer i=0; i<fieldList.size(); i++){
                String fieldName    = fieldList[i];
                String fieldValue   = data[d][i];

                if (ObjectFieldsMap.containsKey(fieldName)){
                    string fieldType = ObjectFieldsMap.get(fieldName).getDescribe().getType().name().ToLowerCase();
                    if(fieldType == 'currency' || fieldType == 'double' || fieldType == 'percent' || fieldType == 'decimal' )
                    {
                        newObject.put(fieldName, decimal.valueOf(fieldValue.trim()));
                    }
                    else if(fieldType == 'boolean')
                    {
                        newObject.put(fieldName, Boolean.valueOf(fieldValue));
                    }                  
                    else if(fieldType == 'date')
                    {
                        newObject.put(fieldName, date.valueOf(fieldValue));
                    }               
                    else
                    {
                        newObject.put(fieldName, fieldValue);
                    }
                }
                else{
                    system.debug('Invalid field: '+ fieldName + ' for object type ' + objectName);
                }

            }
            
            // Add the object to the list
            objectList.add(newObject);
        }
        
        // Now insert all the objects
        insert objectList;
        
        // Collect the IDs of the newly created objects
        for(sObject createdObject : objectList){
            createdIds.add(createdObject.Id);
        }

        return new ReturnClass('true', 'Inserted successfully.', createdIds);

    }

}
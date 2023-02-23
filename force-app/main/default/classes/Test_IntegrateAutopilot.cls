/**
 * Created by wsha on 11/22/2017.
 */

@IsTest
private class Test_IntegrateAutopilot {

    static testMethod void testGetMessage() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
        'https://lightning1-rest-endpoint.cs88.force.com/services/apexrest/demo/integrateAutopilot/'+ recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        String msg = IntegrateAutopilot.sayHi();
        // Verify results
        System.assert(msg != null);
        //System.assertEquals('Test Stream', thisStream.Name);
    }


    static testMethod void testCreateStream() {

        //RestRequest req = RestContext.request;

        IntegrateAutopilot.AutopilotActivities aa = new IntegrateAutopilot.AutopilotActivities();
        IntegrateAutopilot.Journey j = new IntegrateAutopilot.Journey();
        IntegrateAutopilot.Actor a = new IntegrateAutopilot.Actor();
        IntegrateAutopilot.Object_Z oz = new IntegrateAutopilot.Object_Z();

        IntegrateAutopilot.responseWrapper responseJSON = new IntegrateAutopilot.responseWrapper();
        IntegrateAutopilot iap = new IntegrateAutopilot();
        List<Map<String, Object>> ebody = new List<Map<String, Object>>();

        String loadString = '{"id" : "cbb1075a-cdb2-4c29-954e-1ca2c8ddab27","instanceId" : "my-instance-name","ingestTime" : "2017-09-28T08:54:47.135Z","timestamp"  : "2017-09-28T08:54:47.098Z","action"  : "email.bounced","isTouch" : false,"tags" : [],"journeyTouchesToDate" : 0,"object" : { "id" : "fd4b62a9-e351-47f2-9c9c-f8d63b06ff5e", "type" : "journey", "name" : "Trial Customer"}, "journey" : { "id"   : "85d4286b-3404-453b-ba29-d45a553e9e91", "name" : "Trial Customer" },  "actor": {   "id" : "2e148513-6644-4549-885f-b95e669f1b9f", "type"  : "contact", "email" : "george@autopilothq.com" } }\\n{ "id" : "cbb1075a-cdb2-4c29-954e-1ca2c8ddab27", "instanceId" : "my-instance-name","ingestTime" : "2017-09-28T08:54:47.135Z", "timestamp"  : "2017-09-28T08:54:47.098Z", "action"  : "email.clicked", "isTouch" : false, "tags" : [], "journeyTouchesToDate" : 0, "object" : { "id"   : "fd4b62a9-e351-47f2-9c9c-f8d63b06ff5e", "type" : "journey", "name" : "Trial Customer"},"journey" : {"id" : "85d4286b-3404-453b-ba29-d45a553e9e91","name" : "Trial Customer"},"actor": {"id" : "2e148513-6644-4549-885f-b95e669f1b9f","type"  : "contact","email" : "eduardinoscar@gmail.com"}}';
        System.debug(loadString);
        String jsonString = loadString;//JSON.serialize(loadString);
        RestRequest req = new RestRequest();
        req.requestURI = 'https://lightning1-rest-endpoint.cs88.force.com/services/apexrest/demo/integrateAutopilot/';//+ recordId;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonString);
        List<String> lines = new List<String>();
        Integer lineCounter = 0;
        String jsonBody = req.requestBody.toString();
        if (!String.isBlank(jsonBody)) {
            if(jsonBody.contains('\n')){
                lineCounter++;
            }
            for(String s : jsonBody.split('\\\\n')){
                lines.add(s);

            }
        }

        Autopilot_Stream__c apStream = new Autopilot_Stream__c();

        for(Integer i=0; i<lines.size(); i++){
            System.debug(lines.size());
            ebody.add((Map<String, Object>)JSON.deserializeUntyped(lines[i]));

            if(ebody[i].containsKey('id')
              ||ebody[i].containsKey('instanceId')
              ||ebody[i].containsKey('ingestTime')
              ||ebody[i].containsKey('timestamp')
              ||ebody[i].containsKey('action')
              ||ebody[i].containsKey('isTouch')
              ||ebody[i].containsKey('tags')
              ||ebody[i].containsKey('journeyTouchesToDate')){
                System.assertEquals(true, ebody[i].containsKey('id'));
                System.assertEquals(true, ebody[i].containsKey('instanceId'));
                System.assertEquals(true, ebody[i].containsKey('ingestTime'));
                System.assertEquals(true, ebody[i].containsKey('timestamp'));
                System.assertEquals(true, ebody[i].containsKey('action'));
                System.assertEquals(true, ebody[i].containsKey('isTouch'));
                System.assertEquals(true, ebody[i].containsKey('tags'));
                System.assertEquals(true, ebody[i].containsKey('journeyTouchesToDate'));
            }

        }

        RestContext.request = req;

        IntegrateAutopilot.responseWrapper rWrapper = new IntegrateAutopilot.responseWrapper();
        rWrapper = IntegrateAutopilot.AutopilotStreamCreationLogic();

        String thisStreamAction = 'email.clicked';

        // Verify results
        System.assert(thisStreamAction != null);
        Autopilot_Stream__c thisStream = [SELECT Id, action__c FROM Autopilot_Stream__c WHERE action__c =:thisStreamAction];
        System.assert(thisStream != null);
        System.assertEquals(thisStream.action__c, 'email.clicked');
    }


// Helper method
    static Id createTestRecord() {
        // Create test record
        Autopilot_Stream__c sTest = new Autopilot_Stream__c(
                Name = 'Test Stream',
                action__c = 'Test action',
                activity_id__c = 'activity id');

        insert sTest;
        return sTest.Id;
    }

}
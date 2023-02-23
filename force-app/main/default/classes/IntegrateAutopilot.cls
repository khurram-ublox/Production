/*

{
	"id" 		 : "asdfasdfsdf",
	"instanceId" : "my-instance-name",
	"ingestTime" : "2017-09-28T08:54:47.135z",
	"timestamp"  : "2017-09-28T08:54:47.135z",
	"action"	 : "email.opened",
	"isTouch"	 : false,
	"tags"		 : [],
	"journeyTouchesToDate" : 0,
	
	"object" : {
	"id"   	 : "jaksldfjlkasjdklf",
	"type"   : "journey",
	"name"   : "Trial Customer"
	},
	
	"journey" : {
	"id"	  : "akljsdfjhasjdkf",
	"name"	  : "Trial Customer"
	},
	
	"actor" : {
	"id"	: "kajskldfasjlkd",
	"type"	: "contact",
	"email" : "george@autopilothq.com"
	} 
}
*/


@RestResource(urlMapping='/prod/integrateAutopilot/*')
global class IntegrateAutopilot {

    @HttpGet
    global static String sayHi(){
        return 'Hi! '+System.Datetime.now();
    }

    //primary logic for the class
    @HttpPost //HttpPost annotation exposes the method as a REST resource and called when an HTTP POST request is sent
    global static responseWrapper AutopilotStreamCreationLogic() {

        RestRequest req = RestContext.request; //the RestRequest for the Apex REST method
        responseWrapper responseJSON = new responseWrapper(); //responseWrapper object for API response

        Integer lineCounter = 0;
        List<String> lines = new List<String>(); //placeholder for the JSON Body of the request
        List<String> emailIds = new List<String>();
        List<Map<String, Object>> ebody = new List<Map<String, Object>>(); //placeholder for the JSON Body of the request
        Map<String, Object> body = new Map<String, Object>(); //placeholder for the JSON Body of the request
        Map<String, Object> src = new Map<String, Object>(); //placeholder for the source object from the JSON request

        //DS
        List<Autopilot_Stream__c> AP_Stream = new List<Autopilot_Stream__c>();
        Map<String, Object> Object_Z   = new Map<String, Object>();
        Map<String, Object> Journey    = new Map<String, Object>();
        Map<String, Object> Actor	   = new Map<String, Object>();


        String jsonBody = req.requestBody.toString(); //the body of the request
        System.debug('jsonBody: '+jsonBody);

        if (!String.isBlank(jsonBody)) { //if the request body is NOT white space, empty ('') or null
            if(jsonBody.contains('\n')){
                lineCounter++;
            }
            for(String s : jsonBody.split('\\\\n')){
                lines.add(s);

            }
        }

        System.debug('lines count: '+lines.size());

        /*for(Integer j=0; j<lines.size(); j++){
            System.debug('line'+j+':'+lines[j]);
            ebody.add((Map<String, Object>)JSON.deserializeUntyped(lines[j]));
        }*/



        //main-loop for obj creation.
        for(Integer i=0; i<lines.size(); i++) {
            System.debug('line'+i+':'+lines[i]);
            ebody.add((Map<String, Object>)JSON.deserializeUntyped(lines[i]));

            //Keep only the email results.
            String actionToken = (String) ebody[i].get('action');
             if (actionToken.startsWith('email.')) {


            //Build object to hold the incoming stream
            Autopilot_Stream__c apStream = new Autopilot_Stream__c();
            if ((ebody[i].containsKey('id'))
                    || (ebody[i].containsKey('instanceId'))
                    || (ebody[i].containsKey('ingestTime'))
                    || (ebody[i].containsKey('timestamp'))
                    || (ebody[i].containsKey('action'))
                    || (ebody[i].containsKey('isTouch'))
                    || (ebody[i].containsKey('tags'))
                    || (ebody[i].containsKey('journeyTouchesToDate'))
                    ) {
                apStream.activity_id__c = (String) ebody[i].get('id');
                apStream.instance_id__c = (String) ebody[i].get('instanceId');
                apStream.ingest_time__c = String.valueOf(ebody[i].get('ingestTime'));
                apStream.timestamp__c = String.valueOf(ebody[i].get('timestamp'));
                apStream.action__c = (String) ebody[i].get('action');
                apStream.isTouch__c = (Boolean) ebody[i].get('isTouch');
                apStream.tags__c = String.valueOf(ebody[i].get('tags'));
                apStream.journeyTouchesToDate__c = (Integer) ebody[i].get('journeyTouchesToDate');

            }

            //Look for object
            if (ebody[i].containsKey('object')) {
                Object_Z = (Map<String, Object>) ebody[i].get('object');
                //parse object data here
                if (Object_Z.containsKey('name')) {
                    System.debug('Object name: ' + Object_Z.get('name'));
                    apStream.object_id__c = (String) Object_Z.get('id');
                    apStream.object_type__c = (String) Object_Z.get('type');
                    apStream.object_name__c = (String) Object_Z.get('name');
                    //aa.object_z.name = (String)Object_Z.get('name');
                }
            }
            //Look for journey
            if (ebody[i].containsKey('journey')) {
                Journey = (Map<String, Object>) ebody[i].get('journey');
                //parse journey data here
                if (Journey.containsKey('name')) {
                    System.debug('Journey name: ' + Journey.get('name'));
                    apStream.journey_id__c = (String) Journey.get('id');
                    apStream.journey_name__c = (String) Journey.get('name');
                    //aa.journey.name = (String)Journey.get('name');
                }
            }
            //Look for actor
            if (ebody[i].containsKey('actor')) {
                Actor = (Map<String, Object>) ebody[i].get('actor');
                //parse actor data here
                if (Actor.containsKey('email')) {
                    emailIds.add((String) Actor.get('email'));
                    apStream.actor_id__c = (String) Actor.get('id');
                    apStream.actor_type__c = (String) Actor.get('type');
                    apStream.actor_email__c = (String) Actor.get('email');
                    apStream.email__c = (String) Actor.get('email');
                    //aa.actor.email = (String)Actor.get('email');
                }
            }
            System.debug('actor email: ' + apStream.actor_email__c);

            //Prevent non email results to get inserted into Autopilot Stream.
            //if(String.valueOf(apStream.action__c).startsWith('email.')){
            //Add apStream to the list
            AP_Stream.add(apStream);
            //}

             }//end-if actionToken

        }//end main-loop


        List<Contact> queriedContacts1 = [SELECT Id FROM Contact WHERE Email = :emailIds ORDER BY CreatedDate DESC];
        System.debug('QueriedContacts: ' + queriedContacts1.size());
        //for(Integer j=0; j<lines.size(); j++){
        //    ebody[j] = (Map<String, Object>)JSON.deserializeUntyped(lines[j]);
        //}
        System.debug('ids: ' + emailIds);
        System.debug('ebody:' + ebody[0]);

        if (queriedContacts1.size() > 0) {
            for (Contact c : queriedContacts1) {
                responseJSON.contactIds.add(c.Id);
            }
        }


        List<Database.SaveResult> insertNewAutopilotStream = Database.insert(AP_Stream); //insert the new autopilot stream
        //List<Database.Error> errors = insertNewAutopilotStream.getErrors(); //grab the error array from the SaveResult object
        for (Integer idx = 0; idx < insertNewAutopilotStream.size(); idx++) {
            if (!insertNewAutopilotStream[idx].isSuccess()) {
                //responseJSON.taskIds.add(insertNewAutopilotStream[idx].getId());
                //respond with failure
                responseJSON.status = 'failure';

            }
        }

        return responseJSON; //return the JSON response
    }

    //wrapper class for the response to an API request
    global class responseWrapper {

        public String status {get{return status;}set;} //status string
        public List<String> contactIds {get;set;} //18 character Contact record Id
        public List<String> taskIds {get;set;} //18 character Task record Id
        public List<String> message {get;set;} //message string



        //constructor
        public responseWrapper() {
            //default all values
            this.status = 'success';
            this.contactIds = new List<String>();
            this.taskIds = new List<String>();

        }
    }

    global class AutopilotActivities{

        public String id {get;set;}
        public String instanceId {get;set;}
        public String ingestTime {get;set;}
        public String timestamp {get;set;}
        public String action {get;set;}
        public Boolean isTouch {get;set;}
        public List<String> tags {get;set;}
        public Integer journeyTouchesToDate {get;set;}
        public Object_Z object_z {get;set;} // in json: object
        public Journey journey {get;set;}
        public Actor actor {get;set;}

        public AutopilotActivities(){
            this.id = '';
            this.instanceId = '';
            this.ingestTime = '';
            this.timestamp  = '';
            this.action		= '';
            this.isTouch	= false;
            this.tags		= new List<String>();
            this.journeyTouchesToDate = 0;
            this.object_Z = new Object_Z();
            this.journey  = new Journey();
            this.actor	  = new Actor();
        }

    }

    global class Object_Z {
        public String id {get;set;}
        public String type_Z {get;set;} // in json: type
        public String name {get;set;}

        public Object_Z(){
            this.id 	= '';
            this.type_Z = '';
            this.name 	= '';
        }

    }

    global class Actor {
        public String id {get;set;}
        public String type_Z {get;set;} // in json: type
        public String email {get;set;}

        public Actor(){
            this.id 	= '';
            this.type_z = '';
            this.email 	= '';
        }

    }

    global class Journey {
        public String id {get;set;}
        public String name {get;set;}

        public Journey(){
            this.id   = '';
            this.name = '';
        }

    }

}//end-class IntegrateAutopilot
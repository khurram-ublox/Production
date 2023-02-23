/**
 * Created by wsha on 3/5/2018.
 */

/**
 * Created by wsha on 2/21/2018.
 */

public class AutopilotStreamAssociation {

    private List<String> streamEmails {get; set;}
    private List<String> conEmails {get; set;}
    private List<String> leadEmails {get; set;}
    private Set<Id> StreamIds {get; set;}
    private Map<Id, Autopilot_Stream__c> mapOfConEmailsInStream {get; set;}
    private Map<Id, Contact> mapOfStreamEmailsInCon {get; set;}
    private Map<Id, Autopilot_Stream__c> StreamMapWithAssociation {get; set;}
    private List<Autopilot_Email_Result__c> StreamEmailResultList {get; set;}


    public AutopilotStreamAssociation(){
        this.streamEmails = new List<String>();
        this.conEmails = new List<String>();
        this.leadEmails = new List<String>();
        this.StreamIds = new Set<Id>();
        this.mapOfConEmailsInStream = new Map<Id, Autopilot_Stream__c>();
        this.mapOfStreamEmailsInCon = new Map<Id, Contact>();
        this.StreamMapWithAssociation = new Map<Id, Autopilot_Stream__c>();
        this.StreamEmailResultList = new List<Autopilot_Email_Result__c>();
    }


    private List<string> getStreamEmails(){

        Map<Id, Autopilot_stream__c> streamMap = new Map<Id, Autopilot_stream__c>(
        [SELECT Id, actor_email__c
        FROM Autopilot_stream__c
        WHERE actor_email__c != NULL
        AND mark_as_read__c = false LIMIT 5000
                /*AND action__c LIKE '%email.%'*/]);

        //fetch the emails from map to list
        for(Autopilot_Stream__c stream : streamMap.values()){
            streamEmails.add(stream.actor_email__c);
        }
        streamEmails.sort();
        return streamEmails;
    }


    private List<String> getContactEmails(){

        Map<Id, Contact> conMap = new Map<Id, Contact>(
        [SELECT Id, Email
        FROM Contact
        WHERE Email IN :getStreamEmails()]);

        //fetch the emails from map to list
        for(Contact con : conMap.values()){
            conEmails.add(con.Email);
        }
        conEmails.sort();
        return conEmails;
    }


    private List<String> getLeadEmails(){

        Map<Id, Lead> leadMap = new Map<Id, Lead>(
        [SELECT Id, Email
        FROM Lead
        WHERE Email IN :getStreamEmails()]);

        //fetch the emails from map to list
        for(Lead l : leadMap.values()){
            leadEmails.add(l.Email);
        }
        leadEmails.sort();
        return leadEmails;
    }


    private Map<Id, Autopilot_Stream__c> getMapOfContactEmailsFromStream(){

        Map<Id, Autopilot_Stream__c> mapOfConEmailsInStream;
        mapOfConEmailsInStream = new Map<Id, Autopilot_Stream__c>(
        [SELECT Id, actor_email__c, action__c, journey_name__c, object_name__c, ingest_time__c, timestamp__c, journey_id__c, object_id__c
        FROM Autopilot_Stream__c
        WHERE actor_email__c IN :getContactEmails()
        AND mark_as_read__c = false]);

        return mapOfConEmailsInStream;
    }


    @TestVisible
    private Map<Id, Autopilot_Stream__c> getMapOfLeadEmailsFromStream(){

        Map<Id, Autopilot_Stream__c> mapOfLeadEmailsInStream;
        mapOfLeadEmailsInStream = new Map<Id, Autopilot_Stream__c>(
        [SELECT Id, actor_email__c, action__c, journey_name__c, object_name__c, ingest_time__c, timestamp__c
        FROM Autopilot_Stream__c
        WHERE actor_email__c IN :getLeadEmails()
        AND mark_as_read__c = false]);

        return mapOfLeadEmailsInStream;
    }


    private Map<Id, Contact> getMapOfStreamEmailsFromContact(){

        Map<Id, Contact> mapOfStreamEmailsInCon;
        mapOfStreamEmailsInCon = new Map<Id, Contact>(
        [SELECT Id, Email
        FROM Contact
        WHERE Email IN :getStreamEmails()]);

        return mapOfStreamEmailsInCon;

    }


    private Map<Id, Lead> getMapOfStreamEmailsFromLead(){

        Map<Id, Lead> mapOfStreamEmailsInLead;
        mapOfStreamEmailsInLead = new Map<Id, Lead>(
        [SELECT Id, Email
        FROM Lead
        WHERE Email IN :getStreamEmails()]);

        return mapOfStreamEmailsInLead;

    }


    private Map<Id, sObject> getCollectionOfMaps(){

        Map<Id, sObject> collectionOfMaps = new Map<Id, sObject>();
        Map<String, sObject> mapBySecretId = new Map<String, sObject>();
        Map<Id, sObject> filteredCollectionOfMaps = new Map<Id, sObject>();

        collectionOfMaps.putAll((Map<Id,SObject>)getMapOfStreamEmailsFromContact());
        collectionOfMaps.putAll((Map<Id,SObject>)getMapOfStreamEmailsFromLead());

        return collectionOfMaps;
    }


    @TestVisible
    private Set<Id> getStreamIds(){

        StreamIds.addAll(mapOfConEmailsInStream.keySet());
        return StreamIds;

    }


    @TestVisible
    private Map<Id, Autopilot_Stream__c> getStreamAssociation(){

        StreamMapWithAssociation = new Map<Id, Autopilot_Stream__c>();
        Map<Id, Autopilot_Stream__c> filteredStreamAssociationMap = new Map<Id, Autopilot_Stream__c>();
        Map<Id, Autopilot_Stream__c> streamEmailsMap = getMapOfContactEmailsFromStream();
        Map<Id, SObject> collectionOfLeadAndCon = getCollectionOfMaps();
        String thisEmail = '';

        //map to hold the relation between each stream Id and the list of similar emails
        for(Id thisId : collectionOfLeadAndCon.keySet()){
            String SObjName = thisId.getSobjectType().getDescribe().getName();
            Contact cont = new Contact();
            Lead lead = new Lead();
            if(SObjName == 'Contact'){
                cont=(Contact)collectionOfLeadAndCon.get(thisId);
                thisEmail = cont.Email;
            }else if(SObjName == 'Lead'){
                lead = (Lead)collectionOfLeadAndCon.get(thisId);
                thisEmail = lead.Email;
            }

            for(Id streamId : streamEmailsMap.keySet()){
                Autopilot_Stream__c aps = streamEmailsMap.get(streamId);

                //start-redundancy
                Map<String, Autopilot_Stream__c> mapBySecretId = new Map<String, Autopilot_Stream__c>();

                String journeyId = aps.journey_id__c;
                String objectId  = aps.object_id__c;
                String action    = aps.action__c;
                String secretId  = journeyId+'-'+objectId+'-'+action;
                String streamEmail = aps.actor_email__c;

                if(thisEmail.equalsIgnoreCase(streamEmail)) {

                    if(!mapBySecretId.keySet().contains(secretId)){
                        mapBySecretId.put(secretId, aps);
                        filteredStreamAssociationMap.put(thisId, aps);
                    }else{
                        streamEmailsMap.remove(streamId);
                    }

                }
                //end-redundancy

            }//end-for streamEmailsMap
        }//end-for collectionOfLeadAndCon

        return filteredStreamAssociationMap;

    }


    public List<Autopilot_Email_Result__c> pullStreamData(Map<Id, Autopilot_Stream__c> nMap){
        Map<Id, Autopilot_Stream__c> newMap = new Map<Id, Autopilot_Stream__c>();
        Map<Id, Autopilot_Stream__c> streamEmailMap = new Map<Id, Autopilot_Stream__c>();
        Map<Id, String> conEmailMap = new Map<Id, String>();
        Map<Id, String> soEmailMap = new Map<Id, String>();

        newMap = nMap;
        String streamEmails = '';

        for(Autopilot_Stream__c aps : [SELECT Id, actor_email__c, journey_id__c, journey_name__c, object_id__c, object_name__c, action__c, ingest_time__c, timestamp__c FROM Autopilot_Stream__c WHERE Id =: newMap.keySet()]){

            streamEmailMap.put(aps.Id, aps);
            streamEmails += aps.actor_email__c + ' OR ';


        }

        streamEmails = streamEmails.endsWith(' OR ')? streamEmails.substring(0, streamEmails.length()- 3) : streamEmails;

        List<List<Sobject>> results = [FIND :streamEmails IN EMAIL FIELDS
                RETURNING Contact (Id, Email), Lead (Id, Email) ];

        List<Contact> conList = new List<Contact>();
        conList = ((List<Contact>)results[0]);
        List<Lead> leadList = new List<Lead>();
        leadList =((List<Lead>)results[1]);
        List<SObject> soList = new List<SObject>();
        soList.addAll(conList);
        soList.addAll(leadList);

        for(SObject s : soList){
            if(String.valueOf(s.Id).substring(0,3)=='003'){
                Contact c = new Contact();
                c = (Contact)s;
                soEmailMap.put(c.Id, c.Email);

            }else if(String.valueOf(s.Id).substring(0,3)=='00Q'){
                Lead l = new Lead();
                l = (Lead)s;
                soEmailMap.put(l.Id, l.Email);

            }

        }

        //  Map<Id, Contact> conMap = new Map<Id, Contact>([SELECT Id, Email FROM Contact WHERE Id =: conEmailMap.keySet()]);


        Map<Id, Autopilot_Stream__c> filteredStreamAssociationMap = new Map<Id, Autopilot_Stream__c>();
        String thisEmail = '';

        //map to hold the relation between each stream Id and the list of similar emails
        for(Id thisId : soEmailMap.keySet()){
            thisEmail = soEmailMap.get(thisId);

            for(Id streamId : streamEmailMap.keySet()){
                Autopilot_Stream__c aps = streamEmailMap.get(streamId);

                /*start-redundancy*/
                Map<String, Autopilot_Stream__c> mapBySecretId = new Map<String, Autopilot_Stream__c>();

                String journeyId = aps.journey_id__c;
                String objectId  = aps.object_id__c;
                String action    = aps.action__c;
                String secretId  = journeyId+'-'+objectId+'-'+action;
                String streamEmail = aps.actor_email__c;

                if(thisEmail.equalsIgnoreCase(streamEmail)) {

                    if(!mapBySecretId.keySet().contains(secretId)){
                        mapBySecretId.put(secretId, aps);
                        filteredStreamAssociationMap.put(thisId, aps);
                    }else{
                        streamEmailMap.remove(streamId);
                    }

                }
                /*end-redundancy*/

            }//end-for streamEmailMap
        }//end-for soEmailMap

        System.debug('filteredStreamAssociationMap: '+filteredStreamAssociationMap);

        List<Autopilot_Email_Result__c> ResultsToSave = new List<Autopilot_Email_Result__c>();
        for (Id i : filteredStreamAssociationMap.keySet()){
            Autopilot_Email_Result__c r = new Autopilot_Email_Result__c();
            Datetime ingestTime = Datetime.valueOfGmt(filteredStreamAssociationMap.get(i).ingest_time__c.replace('T', ' '));
            Datetime timestamp  = Datetime.valueOfGmt(filteredStreamAssociationMap.get(i).timestamp__c.replace('T', ' '));
            r.StreamId__c       = filteredStreamAssociationMap.get(i).Id;
            r.Contact__c        = String.valueOf(i).substring(0,3)=='003'?i:NULL;
            r.Lead__c           = String.valueOf(i).substring(0,3)=='00Q'?i:NULL;
            r.Email__c          = filteredStreamAssociationMap.get(i).actor_email__c;
            r.Journey_Name__c   = filteredStreamAssociationMap.get(i).journey_name__c;
            r.Email_Subject__c  = filteredStreamAssociationMap.get(i).object_name__c;
            r.Sent__c           = filteredStreamAssociationMap.get(i).action__c == 'email.sent'?true:false;
            r.Opened__c         = filteredStreamAssociationMap.get(i).action__c == 'email.opened'?true:false;
            r.Clicked__c        = filteredStreamAssociationMap.get(i).action__c == 'email.clicked'?true:false;
            r.Replied__c        = filteredStreamAssociationMap.get(i).action__c == 'email.replied'?true:false;
            r.Unsubscribed__c   = filteredStreamAssociationMap.get(i).action__c == 'email.unsubscribed'?true:false;
            r.Bounced__c        = filteredStreamAssociationMap.get(i).action__c == 'email.bounced'?true:false;
            r.Deferred__c       = filteredStreamAssociationMap.get(i).action__c == 'email.deferred'?true:false;
            r.Ingest_Time__c    = ingestTime;
            r.Timestamp__c      = timestamp;
            //r.mark_as_read__c   = true;

            ResultsToSave.add(r);

        }

        return ResultsToSave;

    }


    @TestVisible
    private List<Autopilot_Email_Result__c> getStreamData(){
        Map<Id, Autopilot_Stream__c> streamAssociationMap = getStreamAssociation();


        for(Id relatedId : streamAssociationMap.keySet()){

            Autopilot_Stream__c relatedStream  = streamAssociationMap.get(relatedId);
            Autopilot_Email_Result__c r = new Autopilot_Email_Result__c();
            Datetime ingestTime = Datetime.valueOfGmt(relatedStream.ingest_time__c.replace('T', ' '));
            Datetime timestamp  = Datetime.valueOfGmt(relatedStream.timestamp__c.replace('T', ' '));
            r.StreamId__c       = streamAssociationMap.get(relatedId).Id;
            if(String.valueOf(relatedId).substring(0,3)=='003'){
                r.Contact__c    = relatedId;
            }else if(String.valueOf(relatedId).substring(0,3)=='00Q'){
                r.Lead__c       = relatedId;
            }
            r.Email__c          = relatedStream.actor_email__c;
            r.Journey_Name__c   = relatedStream.journey_name__c;
            r.Email_Subject__c  = relatedStream.object_name__c;
            r.Sent__c           = relatedStream.action__c == 'email.sent'?true:false;
            r.Clicked__c        = relatedStream.action__c == 'email.clicked'?true:false;
            r.Opened__c         = relatedStream.action__c == 'email.opened'?true:false;
            r.Bounced__c        = relatedStream.action__c == 'email.deferred'?true:false;
            r.Ingest_Time__c    = ingestTime;
            r.Timestamp__c      = timestamp;
            StreamEmailResultList.add(r);

        }

        return StreamEmailResultList;

    }

}
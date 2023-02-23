/**
 * Service Cloud Case Assignment to Queue
 * 
 * Case Assignment class to assign the case to Queue based on the ub-Office
 *
 * @author Khurram Shahzad 
 * @created 18/11/2021
 *
 *
 */
public without sharing class ServiceCloud_CaseAssignment {
    private static final map<string,Id> QUEUE_MAP = new map<string,Id>();
    private static final map<string, string> CHANNEL_SUPPORT = new map<string, string>();
    private static final map<string, string> SUPPORT_QUEUE = new map<string, string>();
    private static final map<string, string> EMAIL_CASE_ORIGIN = new map<string, string>();

    /* This method is invoked from Process Builder name : Case Assignment
    *  This is assigning the Case to Queue based on the Case ub Office value
    *  Case is assigning to two types of Queues (Support and Channel) based on the Case Account Distributor
    *  If Case Account Distributor is Direct the Queue will be Support otherwise Channel
    *  If Case is from Email(EMEA) and from unknown Contact then it will assign to Support EMEA
    */
    /*
    @InvocableMethod (Label = 'Queue Assignment') 
    public static void assignCaseToQueue(list<Id> caseRecords){
        populateQueueMap();
        list<Case> caseObjectRecords = new list<Case>(); 

        for(Case record : [Select Id,OwnerId,origin,isDirect__c,Account_uB_Office__c,Send_Notification_Mail__c from Case where Id IN:caseRecords]){           
            if(record.isDirect__c && record.Account_uB_Office__c != null && record.Account_uB_Office__c != 'Corporate'){
                record.OwnerId = QUEUE_MAP.get(SUPPORT_QUEUE.get(record.Account_uB_Office__c));
                record.Send_Notification_Mail__c = true;                                          
            }else if(record.Account_uB_Office__c != null && record.Account_uB_Office__c != 'Corporate'){
                record.OwnerId = QUEUE_MAP.get(CHANNEL_SUPPORT.get(record.Account_uB_Office__c));
            }
            //Update the Case origin if the case is coming from E-Mail(EMEA) but assigned to different queue
            if(record.origin == 'E-Mail (EMEA)' && record.Account_uB_Office__c != null && record.Account_uB_Office__c != 'Corporate'){
                record.origin =  EMAIL_CASE_ORIGIN.get(record.Account_uB_Office__c);
            }            
            caseObjectRecords.add(record);
        }
        if(caseObjectRecords.size() > 0){
            database.update(caseObjectRecords, false);
        }
    }*/

    /* This method is invoked from subflow name : Case Assignment
    *  This is assigning the Case to Queue based on the Case ub Office value
    *  Case is assigning to two types of Queues (Support and Channel) based on the Case Account Distributor
    *  If Case Account Distributor is Direct the Queue will be Support otherwise Channel
    *  If Case is from Email(EMEA) and from unknown Contact then it will assign to Support EMEA
    */

    @InvocableMethod(Label = 'Invoked from Flow Case:Case Assignment')
    public static list<Case> assignCaseToQueue(list<Case> caseRecords){
        populateQueueMap();
        list<Case> caseObjectRecords = new list<Case>(); 

        for(Case record : caseRecords){           
            if(record.isDirect__c && record.Account_uB_Office__c != null){
                record.OwnerId = QUEUE_MAP.get(SUPPORT_QUEUE.get(record.Account_uB_Office__c));
                record.Send_Notification_Mail__c = true;                                          
            }else if(record.Account_uB_Office__c != null){
                record.OwnerId = QUEUE_MAP.get(CHANNEL_SUPPORT.get(record.Account_uB_Office__c));
            }else record.OwnerId = QUEUE_MAP.get(SUPPORT_QUEUE.get('Corporate'));

            //Update the Case origin if the case is coming from E-Mail(EMEA) but assigned to different queue
            if(record.origin == 'E-Mail (EMEA)' && record.Account_uB_Office__c != null && record.Account_uB_Office__c != 'Corporate'){
                record.origin =  EMAIL_CASE_ORIGIN.get(record.Account_uB_Office__c);
            }
            caseObjectRecords.add(record);
        }        
        return caseObjectRecords;
    }

    /* This method is to get the All the Queues related to Case and setup the Map as Queue Name and Id key value pair  
    *  Also get and set the Maps with Queue Name based on the ub Office from Custom Meta Data type    
    */
    private static void populateQueueMap(){
        if(QUEUE_MAP.isEmpty()){
            for(QueueSobject Q: [SELECT QueueId, Queue.Name FROM QueueSobject where SobjectType = 'Case' limit 1000]){
                QUEUE_MAP.put(Q.Queue.Name,Q.QueueId);
            }
        }
        if(SUPPORT_QUEUE.isEmpty() || CHANNEL_SUPPORT.isEmpty()){
            for(Support_Queues__mdt sq : [Select Label,Channel_Support__c,Support_Queue__c,Email_Case_Origin__c from Support_Queues__mdt]){
                CHANNEL_SUPPORT.put(sq.Label, sq.Channel_Support__c);
                SUPPORT_QUEUE.put(sq.Label, sq.Support_Queue__c);
                EMAIL_CASE_ORIGIN.put(sq.Label,sq.Email_Case_Origin__c);
            }
        }
    }
}
public virtual class ServiceCloud_EscalationHandler {
    private Case supportCase = new Case();
    private User currentUser = new User();
    private static final set<string> PARTNERS_FAE = new set<string>();
    private static final map<string, string> CHANNEL_SUPPORT = new map<string, string>();
    private static final map<string, string> SUPPORT_L2 = new map<string, string>();
    private static final set<string> EXTERNAL_FAE = new set<string>();
    private static final map<string, set<string>> CASE_TYPE = new map<string, set<string>>();
    private static final map<string,Id> QUEUE_MAP = new map<string,Id>();
    private static final set<Id> CHANNEL_FAE = new set<Id>();
        
    public void setCaseToEscalate(Case c){
        supportCase = c;
    }

    public void setContextUser(User u){
        currentUser = u;
    }

    public ServiceCloud_EscalationHandler(){
        if(CHANNEL_SUPPORT.isEmpty()){
            for(Channel_Support__mdt ch : [Select Label,Queue__c from Channel_Support__mdt]){
                CHANNEL_SUPPORT.put(ch.Label, ch.Queue__c);
            }
        }
        if(CHANNEL_FAE.isEmpty()){
            for(GroupMember cFAE: [SELECT UserOrGroupId FROM GroupMember where Group.Name LIKE '%Channel']){
                CHANNEL_FAE.add(cFAE.UserOrGroupId);
            }
        }
        if(SUPPORT_L2.isEmpty()){
            for(Support_Level2__mdt TM : [Select Label,Queue__c from Support_Level2__mdt]){
                SUPPORT_L2.put(TM.Label, TM.Queue__c);
            }
        }
        if(EXTERNAL_FAE.isEmpty()){
            for(External_FAE__mdt eFAE : [Select Label from External_FAE__mdt]){
                EXTERNAL_FAE.add(eFAE.Label); 
            }
        }
        if(PARTNERS_FAE.isEmpty()){
            for(Partners_with_case_access__mdt partner: [Select Label from Partners_with_case_access__mdt]){
                PARTNERS_FAE.add(partner.Label);                        
            }
        }
        if(CASE_TYPE.isEmpty()){
            for(Case_Type__mdt cType: [Select Label,category__c from Case_Type__mdt]){
                if(CASE_TYPE.get(cType.category__c) == null)            
                    CASE_TYPE.put(cType.category__c, new set<string>());
                CASE_TYPE.get(cType.category__c).add(cType.Label);            
            }
        }
        if(QUEUE_MAP.isEmpty()){
            for(QueueSobject Q: [SELECT QueueId, Queue.Name FROM QueueSobject where SobjectType = 'Case' limit 1000]){
                QUEUE_MAP.put(Q.Queue.Name,Q.QueueId);
            }
        }        
    }

    public virtual Case escalateCase(){
        this.validateUserAndCaseInputs();
        if(this.caseTypeQuality() 
            && currentUser.uB_Office__c == ServiceCloud_Constants.CASE_REGION_EMEA
            && currentUser.ProfileId != ServiceCloud_Constants.PARTNER_PORTAL_PROFILE
            && currentUser.ProfileId != ServiceCloud_Constants.PARTNER_BASE_PROFILE){
            this.assignToQualityQueue();
        }else{
            if(currentUser.ProfileId == ServiceCloud_Constants.PARTNER_PORTAL_PROFILE 
                || currentUser.ProfileId == ServiceCloud_Constants.PARTNER_BASE_PROFILE){
                this.escalateToChannelSupport();            
            }else if(ServiceCloud_Constants.EXTERNAL_USER_ROLE.contains(currentUser.UserRole.Name)
                && (EXTERNAL_FAE.contains(supportCase.owner.Name) 
                    || EXTERNAL_FAE.contains(supportCase.Account.FAE__r.Name))){
                this.escalateToSupportQueue();
            }else if(ServiceCloud_Constants.FAE_PROFILE.contains(currentUser.Profile.Name) && !supportCase.is_Escalated_to_L2__c){
                supportCase.is_Escalated_to_L2__c = true;
                this.escalateToLevel2Support();
            }else this.escalateToLevel3Support();
        }
        this.finish();
        return supportCase;
    }

    protected void escalateToChannelSupport(){
        supportCase.OwnerId = QUEUE_MAP.get(CHANNEL_SUPPORT.get(currentUser.uB_Office__c));
    }

    protected void escalateToLevel2Support(){
        if(currentUser.uB_Office__c == ServiceCloud_Constants.CASE_REGION_EMEA){            
            this.assignToAEQueue();
            /*if(CHANNEL_FAE.contains(currentUser.Id) 
                || CHANNEL_FAE.contains(supportCase.ownerId) 
                || CHANNEL_FAE.contains(supportCase.Account.FAE__c)){
                supportCase.OwnerId = QUEUE_MAP.get(SUPPORT_L2.get(currentUser.uB_Office__c));
            }else this.assignToAEQueue();*/              
        }else supportCase.OwnerId = QUEUE_MAP.get(SUPPORT_L2.get(currentUser.uB_Office__c));        
    }

    protected void escalateToSupportQueue(){
        supportCase.OwnerId = QUEUE_MAP.get(ServiceCloud_Constants.QUEUE_SUPPORT_EMEA);
    }

    protected void escalateToLevel3Support(){        
        if(this.caseTypeQuality()){
            this.assignToQualityQueue();
        }else this.assignToAEQueue(); 
    }

    protected void assignToAEQueue(){
        this.validateCaseTechnology();
        supportCase.OwnerId = QUEUE_MAP.get(ServiceCloud_Constants.TECH_QUEUE_MAP.get(supportCase.Technology__c));               
    }

    protected void assignToQualityQueue(){ 
        supportCase.OwnerId = QUEUE_MAP.get(ServiceCloud_Constants.QUALITY);        
    }

    public virtual void finish(){
        if(supportCase.Case_Initiator_Source__c == null){ 
            supportCase.Case_Initiator_Source__c = supportCase.CreatedById; 
        }        
        if(supportCase.Escalation_Source__c == ServiceCloud_Constants.ESCALATION_SRC_TM){ 
            supportCase.Date_Escalated_by_TM__c = system.now();
        }else if (supportCase.Escalation_Source__c == ServiceCloud_Constants.ESCALATION_SRC_FAE_LEAD){ 
            supportCase.Date_Escalated_by_FAE_Leader__c = system.now();
        }else if (supportCase.Escalation_Source__c == ServiceCloud_Constants.ESCALATION_SRC_AE_APAC){ 
            supportCase.Date_Escalated_by_AE_APAC__c = system.now();
        }else if (ServiceCloud_Constants.FAE_PROFILE.contains(supportCase.Escalation_Source__c)){ 
            if(supportCase.Created_By_Partner__c && supportCase.Current_User_Internal__c){ 
                supportCase.Date_Escalated_by_TM__c = system.now();                
            }else supportCase.Date_Escalated_by_FAE__c = system.now();
        }
        supportCase.Send_Notification_Mail__c = true;
        supportCase.IsEscalated = true;
        supportCase.Status = ServiceCloud_Constants.ESCALATED;                
    }

    private void validateCaseTechnology(){
        if(supportCase.Technology__c == null){
            throw new ApexException(Label.Case_Technology); 
        }else if(supportCase.Technology__c == ServiceCloud_Constants.CASE_TECH_OTHER){
            throw new ApexException(Label.Case_Other_Technology);
        }
    }

    private void validateUserAndCaseInputs(){
        if(supportCase == NULL || currentUser == NULL){ 
            throw new ApexException('Case and user properties must be set to escalate the case');            
        }
        if(currentUser.uB_Office__c == NULL){
            throw new ApexException('u-blox office not mentioned in your user record');
        }
    }

    private boolean caseTypeQuality(){
        if(CASE_TYPE.get(ServiceCloud_Constants.QUALITY).contains(supportCase.Type)){
            return true;
        }
        return false;
    }
}
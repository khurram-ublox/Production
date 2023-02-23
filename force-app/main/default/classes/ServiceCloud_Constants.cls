public with sharing class ServiceCloud_Constants {
    public static final string CASE_REGION_EMEA = 'EMEA';    
    public static final string PARTNER_PORTAL_PROFILE = Hard_Code_Ids__c.getInstance().Partner_Community_Profile_P_Base__c; // Portal-Partner Base Profile
    public static final string PARTNER_BASE_PROFILE = Hard_Code_Ids__c.getInstance().Partner_Base_Profile__c; // Partner Base Profile
    public static final set<string> FAE_PROFILE = new set<string>{
        'FAE',
        'Service FAE'
    };
    public static final string TM_PROFILE = 'Technical Manager';
    public static final string CASE_TECH_CELLULAR = 'Cellular';
    public static final string CASE_TECH_GNSS = 'GNSS';
    public static final string CASE_TECH_SHO = 'Short Range';
    public static final string CASE_TECH_SER = 'Services';
    public static final string CASE_TECH_OTHER = 'other';
    public static final string QUEUE_AE_CEL = 'AE CEL';
    public static final string QUEUE_AE_GNSS = 'AE POS';
    public static final string QUEUE_AE_SHO = 'AE SHO';
    public static final string QUEUE_AE_SER = 'AE SER';
    public static final string QUEUE_SUPPORT_EMEA = 'Support EMEA';    
    public static final string QUALITY = 'Quality';
    public static final string TECHNICAL = 'Technical';
    public static final string ESCALATION_SRC_TM = 'TM';
    public static final string ESCALATION_SRC_FAE_LEAD = 'FAE Leader';
    public static final string ESCALATION_SRC_AE_APAC = 'AE APAC';
    public static final string ESCALATION_SRC_FAE = 'FAE';
    public static final string ESCALATED = 'Escalated';    
    public static final set<string> EXTERNAL_USER_ROLE = new set<string>{
        'Partner RFD',
        'Partner CRG'
    };
    public static final set<string> AE_QUEUE = new set<string>{
        '00G20000001Lsac',
        '00G20000001LsZy',
        '00GD0000003uWXg'
    };      
    public static final map<string, string> TECH_QUEUE_MAP = new map<string,string>{
        CASE_TECH_CELLULAR =>  QUEUE_AE_CEL,
        CASE_TECH_GNSS => QUEUE_AE_GNSS,
        CASE_TECH_SHO => QUEUE_AE_SHO,
        CASE_TECH_SER => QUEUE_AE_SER
    };
    public static final set<string> EMEA_QUEUES = new set<string>{
        'Support EMEA',        
        'EMEA Channel',
        'EMEA Support L2'
    };    
}
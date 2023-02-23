/**
 * @description Class that adds campaign members to a campaign.
 * Sandbox: cogs
 *
 * @author wsha
 */
 
 
@RestResource(urlMapping='/PCN-REST-Service/*')

global class PCNRESTService {


 global class PCNMembers{
        public String myCampaignID {get; set;}
        public String myAction {get; set;}
        public List<String> contactList {get; set;}
        public PCNMembers(){}
    
    }


     global class ReturnClass {

        public String success {get; set;}
        public String message {get; set;}
        public List<CampaignMember> records {get; set;}

        public ReturnClass(String success, String message, List<CampaignMember> records) {
        this.success = success;
        this.message = message;
        this.records = records;
        }

    }    
    


    @HttpGet
    global static ReturnClass getCampaignMembers() {

   
        RestRequest req = RestContext.request;
        String camId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        System.debug('ID: '+camId);
        List<CampaignMember> cm = [SELECT Name FROM CampaignMember WHERE CampaignID =: camId];
        return new ReturnClass('true', 'Query executed successfully.', cm);
    
    }
        
        
    @HttpPost 
    global static ReturnClass changeCampaignMembers(PCNMembers[] Campaign) {
        
        RestRequest req = RestContext.request;
        CampaignMember[] cm = new CampaignMember[]{};
        CampaignMember[] cmtoDel = new CampaignMember[]{};
        List<String> memsToDelete = new List<String>();

        PCNMembers m1 = Campaign[0];
        if(m1.myAction == 'delete'){
            for(Integer d=0; d<m1.contactList.size(); d++){
                memsToDelete.add(m1.contactList[d]);
            }
            cmtoDel = [SELECT Id FROM CampaignMember WHERE CampaignID =: m1.myCampaignID AND ContactID IN : memsToDelete];
            delete cmtoDel;
            

        } 


        if(m1.myAction == 'insert'){
            for(PCNMembers m : Campaign){
                
                for(Integer i=0; i<m.contactList.size(); i++){
                    cm.add(new CampaignMember(campaignId = m.myCampaignID, ContactId = m.contactList[i]));
                }
            }
        
            insert cm;
            
        }

           return new ReturnClass('true', 'Query executed successfully.', cm.size()!=0 ? cm : cmtoDel);

    }


   

    @HttpDelete
    global static ReturnClass deleteAllCampaignMembers() {

        RestRequest req = RestContext.request;
        String camId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        List<CampaignMember> members = [ Select ID from CampaignMember where CampaignID= :camId];

        delete members;

          return new ReturnClass('true', 'Query executed successfully.', members);
        
    }
   
}
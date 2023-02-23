@isTest
private class Test_PCNRESTService {

	
	@isTest
	static void testDoGet() {

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/PCN-REST-Service/getCampaignMembers/';
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    Campaign testCampaign = new Campaign();
    testCampaign.Name = 'Name';
	insert testCampaign;
	Contact con = new Contact();
	con.LastName = 'testContact';
	insert con;
	CampaignMember cMem = new CampaignMember(CampaignId = testCampaign.Id, ContactId = con.Id, status = 'Pending');
	insert cMem;


    PCNRestService.ReturnClass results = PCNRESTService.getCampaignMembers();
    List<CampaignMember> cm = [SELECT Name FROM CampaignMember WHERE CampaignID =: testCampaign.Id];
    System.assertEquals('true', results.success);
    System.assertEquals(0, results.records.size());
    System.assertEquals('Query executed successfully.', results.message);
     
  }


	
	@isTest
	static void testDoInsert() {
	Campaign testCampaign = new Campaign();
    testCampaign.Name = 'Name';
    testCampaign.Status = 'Pending';
    insert testCampaign;

	Contact[] testContactList = new Contact[]{};
	for(Integer j=0; j<3; j++){
		testContactList.add(new Contact(LastName='testContact'+j));
	}
    
    insert testContactList;
    
    PCNRESTService.PCNMembers[] pcnMems = new PCNRESTService.PCNMembers[]{};
    PCNRESTService.PCNMembers pcnMem = new PCNRESTService.PCNMembers();
    pcnMem.myCampaignID = testCampaign.Id;
    pcnMem.myAction = 'insert';
    pcnMem.contactList = new List<String>{testContactList[0].Id, testContactList[1].Id, testContactList[2].Id};
	pcnMems.add(pcnMem);
       
	CampaignMember[] cm = new CampaignMember[]{};
	CampaignMember[] cmToDel = new CampaignMember[]{};
	List<string> memsToDelete = new List<String>();
	
   	if(pcnMem.myAction == 'insert'){	
	for(PCNRESTService.PCNMembers ind : pcnMems){

		for(Integer i=0; i<ind.contactList.size(); i++){
			cm.add(new CampaignMember(CampaignId = ind.myCampaignID, ContactId = ind.contactList[i], Status = 'Pending'));
		}
	}

	insert cm;
	 
	
	}


	pcnMem.myCampaignID = testCampaign.Id;
    pcnMem.myAction = 'delete';
    pcnMem.contactList = new List<String>{testContactList[0].Id, testContactList[1].Id};        
	pcnMems.add(pcnMem);
	if(pcnMem.myAction == 'delete'){
	            for(Integer d=0; d<pcnMem.contactList.size(); d++){
	                memsToDelete.add(pcnMem.contactList[d]);
	            }
	            cmToDel = [SELECT Id FROM CampaignMember WHERE CampaignID =: pcnMem.myCampaignID AND ContactID IN : memsToDelete];
	            delete cmtoDel;
	            
	            
	
	} 

	PCNRESTService.ReturnClass results =  PCNRestService.changeCampaignMembers(pcnMems);   
   	String JsonMsg = JSON.serialize(pcnMems); 	
   	RestRequest req = new RestRequest(); 
   	RestResponse res = new RestResponse();
         
   	req.requestURI = '/services/apexrest/PCN-REST-Service/changeCampaignMembers/'; 
   	req.httpMethod = 'POST';
   	req.requestBody = Blob.valueof(JsonMsg);
   	RestContext.request = req;
   	RestContext.response= res;
   	
   	System.assertEquals('true', results.success);
   	System.assertEquals(0, results.records.size());
    System.assertEquals('Query executed successfully.', results.message);
	
  }



  @isTest
	static void testDoDelete() {

    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/PCN-REST-Service/deleteAllCampaignMembers/';
    req.httpMethod = 'DELETE';
    RestContext.request = req;
    RestContext.response = res;
    PCNRestService.ReturnClass results = PCNRestService.deleteAllCampaignMembers();

    System.assertEquals('true', results.success);
    System.assertEquals(0, results.records.size());
    System.assertEquals('Query executed successfully.', results.message);

  }
	
}
/*
	This class contains business logic for automatic approval of approval process for Opp Product
	Created date: 10/15/2021
	Created by:
*/

public class ApprovalProcessAutomation {
    public void processApprovalrecord(){ 

		String username = userinfo.getUserName();
            List<Opp_Product__c> ListOppProds = [Select Id From Opp_Product__c Where Flag_Approval_Status__c ='Pending' AND  Flagged_Item__c=False];
            List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();

        	For(ProcessInstanceWorkitem workItems: [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =:ListOppProds]){
                
                Approval.ProcessWorkitemRequest apwir = new approval.ProcessWorkitemRequest();
                apwir.setWorkitemId(workItems.Id);
                apwir.setAction('Approve');
                requests.add(apwir);
			}
			Approval.process(requests);
	}
}
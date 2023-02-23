/*
	This Schedulable class for automatic approval of approval process for Opp Product
	Created date: 10/15/2021
	Created by:
*/

global class ApprovalProSchedulable implements system.Schedulable {

	//In execute, call for method from a class that contains business logic
    global void execute(SchedulableContext ctx){
		ApprovalProcessAutomation approvalAumate = new ApprovalProcessAutomation();
		approvalAumate.processApprovalrecord();
	}    
}
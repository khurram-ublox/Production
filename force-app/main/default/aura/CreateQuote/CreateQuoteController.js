({
	doInit : function(component, event, helper) {	
	},
	handleCreateLoad: function (cmp, event, helper) {
	},
	handleRecordUpdated: function (cmp, event, helper) {

		let name = cmp.get('v.parentRecord.Name');
		name += cmp.get('v.parentRecord.OppAutoNumber__c') ? '-u-blox-QR-' + cmp.get('v.parentRecord.OppAutoNumber__c') : "";
		cmp.find("Name").set("v.value", name);
		cmp.find("Opportunity").set("v.value", cmp.get('v.recordId'));
		cmp.find("Account").set("v.value", cmp.get('v.parentRecord.AccountId'));
		cmp.find("Quotation_Account__c").set("v.value", cmp.get('v.parentRecord.AccountId'));
		
	},
	handleSuccess: function (cmp, event, helper) {
		var payload = event.getParams().response;
		cmp.find('notifLib').showToast({
				"title": "Record updated!",
				"message": "The record "+ payload.id + " has been updated successfully.",
				"variant": "success"
		});
		console.log('junaid after load');
		var navEvt = $A.get("e.force:navigateToSObject");
		navEvt.setParams({
			"recordId": payload.id
		});
		navEvt.fire();
	}
})
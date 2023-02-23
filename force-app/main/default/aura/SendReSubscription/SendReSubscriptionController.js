({
    sendEmail : function(component, event, helper) {
        component.set("v.loaded", false);
        var recordId = component.get("v.recordId");
        var recordIdStr = recordId.toString();
        let action = component.get("c.updateSubscriptionField");
        action.setParams({ "contactId" : recordId });

        // Callback
		action.setCallback(this, function(response) {
            component.set("v.loaded", true);
        	var state = response.getState();
            
        	if (state === "SUCCESS") {
                var contactId = response.getReturnValue();
                if(component.get("v.location") !== 'visualforce'){
                    console.log("Location : "+component.get("v.location"));
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The Email is scheduled successfully.",
                        "type": "success"
                    });
                    toastEvent.fire();                    
                	helper.redirecToRecord(contactId);
                }else{
                    component.set("v.showSuccess",true);
                    component.set("v.successMessage","The Email is scheduled successfully.");
                    uJS.closeTab(contactId);
                }
            }else if(state === "ERROR"){
				var errorMsg = response.getError()[0].message;
                if(component.get("v.location") !== 'visualforce'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": errorMsg,
                        "type": "error"
                    });
                    toastEvent.fire();
                }else{
                    component.set("v.showError",true);
                    component.set("v.errorMessage",errorMsg);
                }
			}
		});
        $A.enqueueAction(action);     
       
    },
    cancel: function(component, event, helper){     
            // Close the action panel
            if(component.get("v.location") !== 'visualforce'){
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }else{
                var recordId = component.get("v.recordId");
                uJS.closeTab(recordId);
            } 
        },
    //$A.enqueueAction(action);
    onCheck: function(cmp, evt) {
		let checkCmp = cmp.find("checkbox");
       	let btnclickd = cmp.find("savebuttonid");
        if(checkCmp.get("v.value")) {
    		btnclickd.set("v.disabled",false);
        } else {
            btnclickd.set("v.disabled",true);
        }
    	

	 }

});
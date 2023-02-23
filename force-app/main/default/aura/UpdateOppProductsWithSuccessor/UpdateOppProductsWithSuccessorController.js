({
    updateOppProducts : function(component, event, helper) {
        component.set("v.loaded", false);
        var recordId = component.get("v.recordId");
        var recordIdStr = recordId.toString();
        let action = component.get("c.updateOppProductsWithSuccessor");
        action.setParams({ "productId" : recordId });       

        // Callback
		action.setCallback(this, function(response) {
            component.set("v.loaded", true);       	
        	var state = response.getState();
            
        	if (state === "SUCCESS") {
                var successorProduct = response.getReturnValue();
                if(component.get("v.location") !== 'visualforce'){                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The request has been successfully submitted, it will take a while to update all Opp Products.",
                        "type": "success"
                    });
                    toastEvent.fire();                    
                	helper.redirecToSuccessor(successorProduct);
                }else{
                    component.set("v.showSuccess",true);
                    component.set("v.successMessage","The request has been successfully submitted, it will take a while to update all Opp Products.");
                    uJS.closeTab(successorProduct);
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
                var productRecordId = component.get("v.recordId");
                uJS.closeTab(productRecordId);
            } 
        }
    //$A.enqueueAction(action);

});
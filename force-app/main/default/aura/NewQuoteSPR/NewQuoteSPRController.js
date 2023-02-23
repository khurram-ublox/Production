({
    createQuote : function(component, event, helper) {
        component.set("v.loaded", false);
        var recordId = component.get("v.recordId");
        var recordIdStr = recordId.toString();
        let action = component.get("c.getSPRid");
        action.setParams({ "sprId" : recordId });
        console.log(" SPR current record id ----"+recordId);

        // Callback
		action.setCallback(this, function(response) {
            component.set("v.loaded", true);
       	//action.setCallback(this, getSPRid(sprId){  
        	var state = response.getState();
            
        	if (state === "SUCCESS") {
                var quoteId = response.getReturnValue();
                if(component.get("v.location") !== 'visualforce'){
                    console.log("Location : "+component.get("v.location"));
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The Quotation has been successfully created.",
                        "type": "success"
                    });
                    toastEvent.fire();                    
                	helper.redirecToQuote(quoteId);
                }else{
                    component.set("v.showSuccess",true);
                    component.set("v.successMessage","The Quotation has been successfully created.");
                    uJS.closeTab(quoteId);
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
                var sprRecordId = component.get("v.recordId");
                uJS.closeTab(sprRecordId);
            } 
        }
    //$A.enqueueAction(action);

});
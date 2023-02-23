({
    doInit : function(component, event, helper) {
        // Get a reference to the getCase function defined in the Apex controller
		var action = component.get("c.getCase");
        action.setParams({"caseId": component.get("v.recordId")});

        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var cse = response.getReturnValue();
                if(cse.Status != 'Closed'){
                    var confirmation = confirm('Do you really want to close this Case?');    
                    if (confirmation){
                    	helper.updateCase(component);
                    }    
           		}
            }
        });
        $A.enqueueAction(action);
    }
})
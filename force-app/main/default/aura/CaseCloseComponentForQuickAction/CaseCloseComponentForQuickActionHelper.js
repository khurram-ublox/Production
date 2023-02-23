({
	updateCase : function(component) {
		
        var action = component.get("c.updateCaseStatus");
        action.setParams({"caseId": component.get("v.recordId")});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log("success..hepler");
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
	}
})
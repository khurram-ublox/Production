({
    doInit : function(component, event, helper) {
        var action = component.get("c.getAccountSummary");        
        var recordId = component.get("v.recordId");
        
        action.setParams({ 
              "AccountId": recordId
        });
        action.setCallback(this, function(response) {
             var state = response.getState();
            if(state === "SUCCESS"){
                console.log(response.getReturnValue());
                component.set("v.projectOwner", response.getReturnValue());
            } else{                  
                console.log(state);
            }                
        });
        $A.enqueueAction(action);
    }
})
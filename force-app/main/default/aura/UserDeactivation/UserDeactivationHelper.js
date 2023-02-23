({
    deactivate : function(component, event, helper) {
        var toastEvent = $A.get('e.force:showToast');
        var user = component.get("v.user");
        var reason = component.get("v.reason_set");
		var action = component.get("c.deactivateUser");

        action.setParams({"reason": reason, "user": user});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var dataMap = response.getReturnValue();
                if(dataMap.status == 'success') {
                    console.log(dataMap);
                    //window.location.replace("./");
                    //var user = component.get("v.user");
                    //var urlEvent = $A.get("e.force:navigateToURL");
                    //urlEvent.setParams({
                        //"url": "/"
                    //});
                    //urlEvent.fire();
                    
                    toastEvent.setParams({
                        'title':'Success',
                        'type':'success',
                        'mode':'dismissible',
                        'message':dataMap.message
                    });
                    toastEvent.fire();
                    
                    var load = setTimeout(function() {
                        window.location.replace("./");
                    }, 2000);
                    
                }
                else if(dataMap.status == 'error') {
                    toastEvent.setParams({
                        'title':'Error',
                        'type':'error',
                        'mode':'dismissible',
                        'message':dataMap.message
                    });
                    toastEvent.fire();
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error: " + errors[0].message);
                    }
                } else {
                    alert("Unknown Error");
                }
            }
            else {
                alert("Unknown error");
            }
        });

        $A.enqueueAction(action);
    },
})
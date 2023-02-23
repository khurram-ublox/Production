({
	init : function(component, event, helper) {
	var action = component.get("c.getUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var user = response.getReturnValue();
                component.set("v.user", user);
                //console.log(storeResponse);
            }
        });
        $A.enqueueAction(action);
	},
    deactivate : function(component, event, helper) {
		helper.deactivate(component, event, helper);
    },
    cancel : function(component, event, helper) {
        var user = component.get("v.user");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/settings/"+user.Id
        });
        urlEvent.fire();
    },
   	onGroup: function(cmp, evt) {
        var radio = evt.getSource().get("v.text");
        cmp.set("v.reason_set", radio);
	}
})
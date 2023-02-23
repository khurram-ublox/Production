/**
 * Created by wsha on 15/10/2018.
 */
({
    getDeactivatedUserClient : function(component, event, helper) {

      var enteredUserName = component.find("searchUserName");
      var val = enteredUserName.get("v.value");
        console.log("In getDeactivatedUserClient!");
        console.log("val: "+val);

        var action = component.get("c.reactivateUser");
        action.setParam("uName", val);

        action.setCallback(this, function(response) {
            var userName = response.getReturnValue();
            component.set("v.DeactivatedUser", response.getReturnValue());
            console.log("userName: "+JSON.stringify( response.getReturnValue()));
            console.log("userName: "+response.getReturnValue());

            if(response.getReturnValue() === true){
                console.log('Your profile has been reactivated successfully!');
                var clearUserName = component.find("searchUserName");
                clearUserName.set("v.label","Your profile has been reactivated successfully!");
                clearUserName.set("v.value"," ");
            }

        });
        $A.enqueueAction(action);
    }
})
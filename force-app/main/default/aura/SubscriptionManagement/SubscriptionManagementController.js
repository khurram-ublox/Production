/**
 * Created by wsha on 24/10/2018.
 */
({

    doInit: function(component, event, helper){
        var action = component.get("c.getUserName");
        action.setCallback(this, function (response) {
            var currentUserName = response.getReturnValue();
            console.log('Current Username: '+ JSON.stringify(currentUserName));
            component.set("v.onlineUser", currentUserName);

        });
        $A.enqueueAction(action);
    },

    getUserSubscriptionsClient: function(component, event, helper){

        var action = component.get("c.getUserSubscriptions");
        action.setCallback(this, function (response) {
            var ConSubscriptionDetails = response.getReturnValue();
            console.log('Contact Subscription Details: '+ JSON.stringify(ConSubscriptionDetails));
            component.set("v.ConSubDetailsAttribute", ConSubscriptionDetails);

        });
        $A.enqueueAction(action);

    },

    setUserSubscriptionsClient: function(component, event, helper){
        var toastEvent = $A.get('e.force:showToast');
        var checkboxes = component.find("checkbox");
        var checkboxesStateMap = {};


        for (var i=0; i<checkboxes.length; i++) {
            if (checkboxes[i].get("v.value")==true || checkboxes[i].get("v.value")==false) {
                checkboxesStateMap[checkboxes[i].get("v.name")] = checkboxes[i].get("v.value");
            }
        }
        console.log('checkboxes state map: '+JSON.stringify(checkboxesStateMap));

        var action = component.get("c.setUserSubscriptions");
        action.setParams({
            "subscriptions":checkboxesStateMap
        });
        action.setCallback(this, function (response) {
            var isSaved = response.getReturnValue();
            console.log('Contact Subscription Set: '+ JSON.stringify(isSaved));
            var state = response.getState();

            //if (state === 'SUCCESS') {
            if (isSaved === true) {
                console.log('success');
                toastEvent.setParams({
                    'title': 'Success',
                    'type': 'success',
                    'mode': 'dismissible',
                    'message': 'Your changes have been saved successfully.'
                });
                toastEvent.fire();
            //} else if (state === 'ERROR') {
            } else if (isSaved === false) {
                console.log('error');
                toastEvent.setParams({
                    'title': 'Error',
                    'type': 'error',
                    'mode': 'dismissible',
                    'message': 'There is some issue in saving your changes at this time.'
                });
                toastEvent.fire();
            }

        });
        $A.enqueueAction(action);

    },

    goBack: function(){
        window.history.back();
        return false;
    }

})
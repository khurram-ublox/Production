/**
 * Created by wsha on 24/10/2018.
 */
({

    doInit: function(component, event, helper){
        
		// get variables
        var urlVars = helper.getJsonFromUrl();
        
		// get Contact info
        if(urlVars.e) {

            var action = component.get("c.getContactSubscriptions");
            action.setParams({"email":urlVars.e,"last":urlVars.l,"id":urlVars.i});

            action.setCallback(this, function (response) {
                var state = response.getState();

                if(state === 'SUCCESS') {
                    var contact = response.getReturnValue();
                    var contactJson = JSON.stringify(contact);

                    if(contactJson == 'null' || contactJson == null || contactJson == '{}') {
                        helper.redirectUrl();
                    }
                    else {  
                        //console.log('output '+JSON.stringify(contact));
                        component.set("v.UserEmail", urlVars.e);
                        component.set("v.ConSubDetailsAttribute", contact);
                    }
    
                } else if (state === 'ERROR' || ConSubscriptionDetails==null) {
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        'title': 'Error',
                        'type': 'error',
                        'mode': 'dismissible',
                        'message': 'Sorry! We don\'t find your record. '
                    });
                    toastEvent.fire();
            	}
            
            });
            $A.enqueueAction(action);
        }
        
    },
    
	doCancel: function(component, event, helper) {
        var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({"url": '/' });
        eUrl.fire();
    },
    
    getUserSubscriptionsClient: function(component, event, helper) {
        var toastEvent = $A.get('e.force:showToast');
        var retrievedUserEmail = component.get("v.UserEmail");
        //console.log("In getUnregisteredUserSubscriptionsClient");
        //console.log('user email: '+retrievedUserEmail);

        var action = component.get("c.getUnregisteredUserSubscriptions");
        action.setParam("uEmail", retrievedUserEmail);
        action.setCallback(this, function(response) {
            var state = response.getState();
            var ConSubscriptionDetails = response.getReturnValue();
            var parsedResult = JSON.parse(JSON.stringify(ConSubscriptionDetails));
            //console.log('Result: '+JSON.stringify(ConSubscriptionDetails));

            if(ConSubscriptionDetails==null){
                //console.log('its null');
            }

            if (state === 'SUCCESS') {
                component.set("v.onlineUser", true);
                component.set("v.ConSubDetailsAttribute", parsedResult);
                toastEvent.setParams({
                    'title': 'Success',
                    'type': 'success',
                    'mode': 'dismissible',
                    'message': 'Your subscriptions retrieved successfully.'
                });
                toastEvent.fire();

                var load = setTimeout(function() {
                    window.location.replace("./");
                }, 2000);
                
            } else if (state === 'ERROR' || ConSubscriptionDetails==null) {
                toastEvent.setParams({
                    'title': 'Error',
                    'type': 'error',
                    'mode': 'dismissible',
                    'message': 'Sorry! We don\'t find your record. '
                });
                toastEvent.fire();
            }

        });
        $A.enqueueAction(action);
    },


    setUserSubscriptionsClient: function(component, event, helper){
        var toastEvent = $A.get('e.force:showToast');
        var checkboxes = component.find("checkbox");
        var email = component.get("v.UserEmail");
        
        var checkboxesStateMap = {"email":email};
		//checkboxesStateMap['UserEmail'] = email;
        
        for (var i=0; i<checkboxes.length; i++) {
            if (checkboxes[i].get("v.value")==true || checkboxes[i].get("v.value")==false) {
                checkboxesStateMap[checkboxes[i].get("v.name")] = checkboxes[i].get("v.value");
            }
        }
        console.log(checkboxesStateMap);
        
        
        //console.log('checkboxes state map: '+JSON.stringify(checkboxesStateMap));
		//console.log(checkboxesStateMap['ServiceItem']);
        var action = component.get("c.setContactSubscriptions");
        //action.setParams(JSON.stringify(checkboxesStateMap));
        action.setParams({
            "email":email,
            "ServiceItem" : checkboxesStateMap['ServiceItem'],
            "EventEmail" : checkboxesStateMap['EventEmail'],
        	"Webinar" : checkboxesStateMap['Webinar'],
            "uCenter" : checkboxesStateMap['uCenter'],
            "Blog" : checkboxesStateMap['Blog'],
            "EventAttendance" : checkboxesStateMap['EventAttendance'],
            "Magazine" : checkboxesStateMap['Magazine']
        });
        action.setCallback(this, function (response) {
            var isSaved = response.getReturnValue();
            //console.log('Contact Subscription Set: '+ JSON.stringify(isSaved));
            var state = response.getState();

            if (state === 'SUCCESS') {
                //console.log('success');
                toastEvent.setParams({
                    'title': 'Success',
                    'type': 'success',
                    'mode': 'dismissible',
                    'message': 'Your changes have been saved successfully.'
                });
                toastEvent.fire();
                
                var load = setTimeout(function() {
                    window.location.replace("./");
                }, 2000);
                
            } else if (state === 'ERROR') {
                var tt = response.getError()[0].pageErrors[0];
                console.log(tt.message + ' - ' + tt.statusCode);
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

    }
})
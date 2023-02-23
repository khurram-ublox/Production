({
    doInit : function(component, event, helper) {           
        var action = component.get("c.getAccount");
        var recordId= component.get("v.recordId"); 
        action.setParams({ 
            "recordId": recordId
        });
        action.setCallback(this, function(data) {
            var state = data.getState();
            if(state === "SUCCESS"){
                console.log(data.getReturnValue());
                component.set("v.account", data.getReturnValue());           
            } else{
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    },
    handleError : function(component, event, helper) {
        console.log('error');
    },
    handleCancel : function(component, event, helper) {
        //closes the modal or popover from the component
        helper.closeModal(component,event,helper);
    },
    handleSubmit : function(component, event, helper) {
         component.set("v.loading", "true" );

        event.preventDefault();
        var fields = event.getParam("fields");
	    var action = component.get("c.save"); 
        action.setParams({ 
            "o": fields
        });

        action.setCallback(this, function(data) {
            var state = data.getState();            
            if(state === "SUCCESS"){
                var oId = data.getReturnValue();
                //helper.showMessage('success','Opportunity has been created.');
                helper.refresh(component,event,helper);
                helper.openRecord(component,oId);
            } 
            else if (state === "ERROR") {
                var errors = data.getError();
                if (errors && errors.length > 0) {
                    console.log(errors);
                    if (errors[0] && errors[0].pageErrors && errors[0].pageErrors.length>0) {
                        helper.showError(component,errors[0].pageErrors[0].message);
                    }
                    else if (errors[0] &&  errors[0].fieldErrors && 
                        errors[0].fieldErrors.Quantity && errors[0].fieldErrors.Quantity.length>0) {
                        helper.showError(component,errors[0].fieldErrors.Quantity[0].message);
                    }else
                    {
                        helper.showError(component,"Error-"+errors[0].message);
                    }
                } else {
                    helper.showError(component,"System Error-"+JSON.stringify(errors));
                }
            }
            else{                  
                helper.showError(component,'Sorry, there was an error during the process.');
            }    
        });
        $A.enqueueAction(action);        
	}
})
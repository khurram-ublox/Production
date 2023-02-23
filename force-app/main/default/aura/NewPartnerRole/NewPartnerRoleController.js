({
    doInit : function(component, event, helper) {           
        var action = component.get("c.getRecord");
        var recordId= component.get("v.recordId"); 
        action.setParams({ 
            "recordId": recordId
        });
        action.setCallback(this, function(data) {
            var state = data.getState();
            if(state === "SUCCESS"){
                console.log(data.getReturnValue());
                component.set("v.opportunity", data.getReturnValue());           
                //alert(data.getReturnValue());
                //console.log('sumitstate'+state);
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
        component.set("v.loading", "true");

        event.preventDefault();
        //var fields = JSON.stringify(event.getParam("fields"));
        var fields = event.getParam("fields");
	    var action = component.get("c.save"); 
        action.setParams({ 
            "pr": fields
        });
        action.setCallback(this, function(data) {
            var state = data.getState();
            if(state === "SUCCESS"){
                var oId = data.getReturnValue();
                //console.log(data.getReturnValue());                 
                //helper.showMessage('success','Partner Role has been created.');
                helper.refresh(component,event,helper);
                helper.openRecord(component,oId);
            } 
            else if (state === "ERROR") {
                var errors = data.getError();
                if (errors) {
                    console.log(errors);
                    if (errors[0] && errors[0].pageErrors.length>0) {
                        helper.showError(component,errors[0].pageErrors[0].message);
                    }
                    else if (errors[0] && errors[0].fieldErrors.Quantity.length>0) {
                        helper.showError(component,errors[0].fieldErrors.Quantity[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            else{
                helper.showError(component,'Sorry, there was an error during the process.');
            }     
        });
        $A.enqueueAction(action);        
	}
})
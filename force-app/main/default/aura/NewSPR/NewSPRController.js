({
    doInit : function(component, event, helper) {  
        
        var recordId= component.get("v.recordId");
        var action = component.get("c.getIds");
        action.setParams({ 
            "recordId": recordId
        });
        action.setCallback(this, function(data) {
            var state = data.getState();
            if(state === "SUCCESS"){
                component.set("v.getIds", data.getReturnValue());           
                //alert(data.getReturnValue());                   
                console.log(JSON.stringify(component.get("v.getIds")));
            } else{                  
                console.log(state);
            }    
        });
        
        $A.enqueueAction(action);  
    },
    handleError : function(component, event, helper) {
        console.log('error: '+JSON.stringify(event.getParam("error")));
    },
    handleCancel : function(component, event, helper) {
        //closes the modal or popover from the component  
        helper.closeModal(component,event);
    },
    
    handleSave : function(component,event,helper){
        component.set("v.loading", "true" );
        event.preventDefault(); 
        var eventFields = event.getParam("fields");
        //commented by umar as it was making duplicate records
        //component.find('sprForm').submit(eventFields);

        component.set("v.loading", "true" );
        var action = component.get("c.save"); 
        action.setParams({ 
            "sp" : eventFields
        });
        
        action.setCallback(this, function(data) {
            
            var state = data.getState();
            if(state === "SUCCESS"){
                var oId = data.getReturnValue();    
                
                helper.showMessage('success','SPR has been created.');
                helper.refresh(component,event,helper);
                helper.openRecord(component,oId);
            } 
            else if (state === "ERROR") {
                var errors = data.getError();
                console.log(errors);
                if (errors) {
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
    },
    
    handleCreateLoad : function(component,event,helper){
        event.preventDefault();
        var toggleText = component.find("submitBtn"); 
        $A.util.addClass(toggleText, "slds-hide");
    }
})
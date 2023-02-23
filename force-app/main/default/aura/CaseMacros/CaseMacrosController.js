({
    macrosDropDown : function(component, event, helper) {
        var action = component.get("c.getMacroDropDownValues");        
        
        action.setCallback(this, function(Response) {
            var responseMap = Response.getReturnValue();
            var macrosList = [];                     
            for (var key in responseMap ) {
                macrosList.push({label:key, id:responseMap[key]});               
            }
            component.set("v.options", macrosList);            
        });
        $A.enqueueAction(action, false);
    },

    toAddress : function(component, event, helper) {
        var action = component.get("c.getToEmailAddress");
        var params = {
            "caseId": component.get("v.recordId")            
        }        
        action.setParams(params);
        action.setCallback(this, function(Response) {
            var contactAddress = Response.getReturnValue();            
            component.set("v.toEmail", contactAddress);            
        });
        $A.enqueueAction(action, false);
    },

    fromDropDown : function(component, event, helper) {
        var action = component.get("c.getMacroFromAddress");        
        var params = {
            "caseId": component.get("v.recordId")            
        }        
        action.setParams(params);
        action.setCallback(this, function(Response) {
            var responseMap = Response.getReturnValue();
            var fromList = [];    
            for (var key in responseMap ) {                
                fromList.push({label:responseMap[key], id:key});                
            }
            component.set("v.optionsFrom", fromList);            
        });
        $A.enqueueAction(action, false);
    },

    macroAction : function(component, event, helper) {
        component.set("v.btnLabel", 'Running ...'); 
        var action = component.get("c.runMacro");
        var params = {
            "caseId": component.get("v.recordId"),
            "macroName": component.get("v.selectedValue"),
            "toAddress": component.get("v.toEmail"),
            "ccAddress": component.get("v.ccEmail"),
            "BccAddress": component.get("v.BccEmail"),
            "fromAddress": component.get("v.selectedFromAddress")
        }        
        action.setParams(params);
        action.setCallback(this, function(Response) {                   
            var state = Response.getState();
            if(state === "SUCCESS") {                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Macro Successfully executed",
                    "type": "success"
                });
                toastEvent.fire();
                $A.get("e.force:refreshView").fire();	               

            }else if(state === "ERROR"){
				var errorMsg = Response.getError()[0].message;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": errorMsg,
                    "type": "error"
                });
                toastEvent.fire();                
			}
            component.set("v.btnLabel", 'Run Macro');            
        });
        $A.enqueueAction(action, false);
    },
    
})
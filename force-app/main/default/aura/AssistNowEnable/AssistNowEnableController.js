({
	  doInit : function(component, event, helper) {           
	    var action = component.get("c.checkToken");
        var recordId= component.get("v.recordId");
        var cloneOppId;  
        action.setParams({ 
              "recordId": recordId
          });
        action.setCallback(this, function(data) {
             var state = data.getState();
            if(state === "SUCCESS"){
                    console.log(data.getReturnValue());
                    component.set("v.conform", data.getReturnValue());           
                    //alert(data.getReturnValue());                   
                    //console.log('sumitstate'+state);
                } else{                  
                   console.log(state);
                }                
        });
        $A.enqueueAction(action);        
	},
    
    ok : function(component, event, helper) {           
	    var action = component.get("c.enableToken");
        var recordId= component.get("v.recordId");
        var cloneOppId;  
        action.setParams({ 
              "recordId": recordId
          });
        action.setCallback(this, function(data) {
             var state = data.getState();
            if(state === "SUCCESS"){
                    console.log(data.getReturnValue());
                    //component.set("v.conform", data.getReturnValue());           
                    //alert(data.getReturnValue());                   
                    helper.showMessage('success','The token has been generated and sent to the contact.');
                } else{                  
                    helper.showMessage('error','Sorry, there was an error during the process.');
                }
            cloneOppId= component.get("v.cloneOppId");
            helper.cloneId(recordId);            
        });
        $A.enqueueAction(action);        
	},
   
    resendok: function(component, event, helper) {           
	    var action = component.get("c.resendToken");
        var recordId= component.get("v.recordId");
        var cloneOppId;  
        action.setParams({ 
              "recordId": recordId
          });
        action.setCallback(this, function(data) {
             var state = data.getState();
            if(state === "SUCCESS"){
                    console.log(data.getReturnValue());
                    //component.set("v.conform", data.getReturnValue());           
                    //alert(data.getReturnValue());                   
                	helper.showMessage('success','The token has been sent to the contact.');
                } else{                  
                    helper.showMessage('error','Sorry, there was an error during the process.');
                }
            cloneOppId= component.get("v.cloneOppId");
            helper.cloneId(recordId);            
        });
        $A.enqueueAction(action);        
	},
    
    cancel: function(component, event, helper){     
        // Close the action panel
        $A.get("e.force:closeQuickAction").fire();
    }
    
})
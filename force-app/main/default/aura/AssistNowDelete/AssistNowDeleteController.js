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
                    console.log(state);
                
                } else{                  
                   console.log(state);
                }                
        });
        $A.enqueueAction(action);        
	},
    
    ok : function(component, event, helper) {           
	    var action = component.get("c.deleteToken");
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
                    console.log(state);
                
                    helper.showMessage('success','The token has been removed successfully.');

                } else{                  
                   console.log(state);
                }
            cloneOppId= component.get("v.cloneOppId");
            helper.cloneId(recordId);            
        });
        $A.enqueueAction(action);        
	},
    
    
    cancel: function(component, event, helper){     
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
    
})
({                
    ok : function(component, event, helper) {             
        var action = component.get("c.cloneOpportunity");
        var recordId= component.get("v.recordId");
        var cloneOppId;  
        action.setParams({ 
              "recordId": recordId
          });
        action.setCallback(this, function(data) {
             
            var state = data.getState();
            if(state === "SUCCESS"){
                    console.log(data.getReturnValue());
                    component.set("v.cloneOppId", data.getReturnValue());           
                    //alert(data.getReturnValue());                   
                    console.log(state);
                } else{                  
                   console.log(state);
                }
                cloneOppId= component.get("v.cloneOppId");
            helper.cloneOppId(cloneOppId);            
        });
        $A.enqueueAction(action);        
    },                
    cancel: function(component, event, helper){     
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }

})
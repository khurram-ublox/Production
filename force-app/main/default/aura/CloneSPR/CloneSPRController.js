({                
        ok : function(component, event, helper) {             
            var action = component.get("c.cloneSPRConform");
            var recordId= component.get("v.recordId");
            var cloneSprId;  
            action.setParams({ 
                  "recordId": recordId
              });
            action.setCallback(this, function(data) {
                 
                var state = data.getState();
                if(state === "SUCCESS"){
                        console.log(data.getReturnValue());
                        component.set("v.cloneSprId", data.getReturnValue());           
                        //alert(data.getReturnValue());                   
                        console.log(state);
                    } else{                  
                       console.log(state);
                    }
                cloneSprId= component.get("v.cloneSprId");
                helper.cloneSprId(cloneSprId);            
            });
            $A.enqueueAction(action);        
        },                
        cancel: function(component, event, helper){     
            // Close the action panel
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        }

})
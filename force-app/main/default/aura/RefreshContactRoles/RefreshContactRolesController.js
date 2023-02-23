({
	  doInit : function(component, event, helper) {           
	    var action = component.get("c.refreshContactRoles");
        var recordId= component.get("v.recordId");
        var quotId;  
        action.setParams({ 
              "recordId": recordId
          });
        action.setCallback(this, function(data) {
             var state = data.getState();
            if(state === "SUCCESS"){
                    console.log(data.getReturnValue());
                    component.set("v.quotId", data.getReturnValue());           
                   // alert(data.getReturnValue());
                    console.log(state);
                } else{                  
                   console.log(state);
                }
            quotId= component.get("v.quotId");
            helper.quotId(quotId);            
        });
        $A.enqueueAction(action);        
	}
})
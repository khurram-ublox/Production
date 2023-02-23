({
	  doInit : function(component, event, helper) {           
	    var action = component.get("c.newQuotationMethod");
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
                   // alert(data.getReturnValue());
                    console.log(state);
                } else{                  
                   console.log(state);
                }
            cloneOppId= component.get("v.cloneOppId");
            helper.cloneId(cloneOppId);            
        });
        $A.enqueueAction(action);        
	}
})
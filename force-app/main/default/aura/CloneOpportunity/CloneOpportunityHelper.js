({
	cloneOppId : function(cloneOppId) {
		var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
              "recordId": cloneOppId     
            });
         navEvt.fire();  
	}
})
({
	quotId : function(quotId) {
		var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
              "recordId": quotId     
            });
         navEvt.fire();
	}
})
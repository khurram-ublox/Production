({
	cloneSprId : function(cloneSprId) {
		var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
              "recordId": cloneSprId     
            });
         navEvt.fire();  
	}
})
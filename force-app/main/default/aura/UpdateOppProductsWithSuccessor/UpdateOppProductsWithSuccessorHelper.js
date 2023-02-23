({
	redirecToSuccessor : function(successorId) {
		var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
              "recordId": successorId     
            });
         navEvt.fire();  
	}    
});
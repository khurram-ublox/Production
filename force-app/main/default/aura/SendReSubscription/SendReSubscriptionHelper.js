({
	redirecToRecord : function(contactId) {
		var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
              "recordId": contactId     
            });
         navEvt.fire();  
	}    
});
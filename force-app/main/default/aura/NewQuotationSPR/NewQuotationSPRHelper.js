({
	redirecToQuote : function(quoteId) {
		var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
              "recordId": quoteId     
            });
         navEvt.fire();  
	}    
});
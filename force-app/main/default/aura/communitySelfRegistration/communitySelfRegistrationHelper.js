({
	redirecToLandingPage : function(pageRef) {
		var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
              "url": pageRef     
            });
         urlEvent.fire();  
	}
})
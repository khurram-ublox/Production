({
	init : function(component, event, helper) {
		document.addEventListener("grecaptchaVerified", function(e){
            if(e.detail.action !== 'submitUser'){
                return;
            }            
            var action = component.get("c.reCaptchaRequest");
            action.setParams({               
                recaptchaResponse: e.detail.response
            });
            
            action.setCallback(this, function(response){
                var state = response.getState();                
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();                    
                    component.set("v.recaptchaResult", result);
					console.log('RESULT ---> '+result);                    
                }else{
                    var errors = response.getError();
                    if(errors){
                        var errorMsg = errors[0];				
                        component.set("v.showError", true);
                        component.set("v.errorMessage", errorMsg);                        
                    }
                }
            });
            
            $A.getCallback(function() {
                 $A.enqueueAction(action);
            })(); 
        });
     
        let urlParameters = decodeURIComponent(window.location.search);        
        if(urlParameters !== '' && urlParameters !== undefined){
            urlParameters = urlParameters.substring(1).split('&');              
            for(let i = 0; i < urlParameters.length; i++){
                var param = urlParameters[i].split('=');
                if(param[0] === 'UserSource') {
                    if(param[1] !== undefined){
                        component.set("v.userSource", param[1]);
                    }
                }
                if(param[0] === 'si'){
                    if(param[1] !== undefined && param[1] === '1'){
                        component.set("v.requireNDAInfo", true);
                    }
                }
                console.log(param[1]);
            }              
        }
},

	verify : function(component, event, helper) {
        document.dispatchEvent(new CustomEvent("grecaptchaExecute", {"detail": {action: "submitUser"}}));
        component.set("v.loaded", false);
        var cFName = component.get("v.firstName");
        var cLName = component.get("v.lastName"); 
        var cEmail = component.get("v.email");
        var cAcInfo = component.get("v.accountInfo");
        var cPInfo = component.get("v.projectInfo");
        var cSource = component.get("v.userSource");
        var cTerms = component.get("v.terms");
        var cConcent = component.get("v.marketingConcent");
        
        let action = component.get("c.verifyUser");
        action.setParams({ "firstName" : cFName, "lastName" : cLName, "email" : cEmail, "accountInfo" : cAcInfo, "projectInfo" : cPInfo, "userOrigin" : cSource, "acceptanceCertificate" : cTerms, "marketingConcent" : cConcent});       
		
        // Callback
		action.setCallback(this, function(response) {            
            component.set("v.loaded", true);       	
        	var state = response.getState();
            var userSuccess = response.getReturnValue();
        	if (state === "SUCCESS") {                                   
                helper.redirecToLandingPage(userSuccess);                
            }else if(state === "ERROR"){  
				var errorMsg = response.getError()[0].message;				
                component.set("v.showError", true);
                component.set("v.errorMessage", errorMsg);
                //component.set("v.recaptchaResponse", null);
                //document.dispatchEvent(new Event("grecaptchaReset"));
			}
		});
        $A.enqueueAction(action);
    }
});
({
    initialize: function(component, event, helper) {
        let urlParameters = decodeURIComponent(window.location.search);        
        if(urlParameters !== '' && urlParameters !== undefined){
            var forgotPwdUrl = component.get("v.forgotPasswordUrl");
            var selfRegUrl = component.get("v.selfRegisterUrl");
            forgotPwdUrl = forgotPwdUrl + urlParameters;
            selfRegUrl = selfRegUrl + urlParameters;
            component.set("v.communityForgotPasswordUrl", forgotPwdUrl);
            component.set("v.communitySelfRegisterUrl", selfRegUrl);
        }
    }
})
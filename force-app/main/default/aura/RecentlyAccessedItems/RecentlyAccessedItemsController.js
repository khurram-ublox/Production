/**
 * Created by wsha on 01/10/2018.
 */
({
    doInit: function (component, event, helper) {

        var pageType = component.get('v.pageType');
        var resultType = component.get('v.resultType');
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        component.set("v.cbaseURL", baseURL);
        console.log('baseURL: '+baseURL);

        switch (resultType){
            case 'Unique':
                if (pageType === 'Profile') {
                    var action = component.get("c.getRecentlyViewedUsers");
                    action.setCallback(this, function(data){
                        component.set("v.RecentlyViewed", data.getReturnValue());
                        console.log(data.getReturnValue());
                    });
                    $A.enqueueAction(action);

                }else if(pageType === 'Case'){
                    var action = component.get("c.getRecentlyViewedCases");
                    action.setCallback(this, function(data){
                        component.set("v.RecentlyViewed", data.getReturnValue());
                        console.log(data.getReturnValue());
                    });
                    $A.enqueueAction(action);

                }else if(pageType === 'Topic'){
                    var action = component.get("c.getRecentlyViewedTopics");
                    action.setCallback(this, function(data){
                        component.set("v.RecentlyViewed", data.getReturnValue());
                        console.log(data.getReturnValue());
                    });
                    $A.enqueueAction(action);

                }else if(pageType === 'Knowledge Article'){
                    var action = component.get("c.getRecentlyViewedKnowledgeArticles");
                    action.setCallback(this, function(data){
                        component.set("v.RecentlyViewed", data.getReturnValue());
                        console.log(data.getReturnValue());
                    });
                    $A.enqueueAction(action);

                }

                break;

            case 'Mixed':

                    var action = component.get("c.getRecentlyViewedMixed");
                    action.setCallback(this, function(data){
                        component.set("v.RecentlyViewed", data.getReturnValue());
                        console.log(data.getReturnValue());
                    });
                    $A.enqueueAction(action);

                    break;

        }


    },

    getUserTypeClient: function(component, event, helper){
        var action = component.get("c.getUserType");
        action.setCallback(this, function (response) {
            var isGuestUser = response.getReturnValue();
            console.log('Registered User: '+ JSON.stringify(isGuestUser));
            component.set("v.RegisteredUser", isGuestUser);

        });
        $A.enqueueAction(action);
    }


})
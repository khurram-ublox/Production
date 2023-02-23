(function(w){
    "use strict"; //Optional because LC on LockerService active runs in strict mode

    var functions = {
        "setCommunityName" : setCommunityName,
        "setCommunityBaseURL" : setCommunityBaseURL,
        "isCommunity":isCommunity,
        "closeAndRefreshTab":closeAndRefreshTab,
        "openAndRefreshTab":openAndRefreshTab,
        "openTab":openTab,
        "closeTab":closeTab,
        "isLightning":isLightning,
        "openReport":openReport
    };
    var communityBaseURL = '';
    
    function setCommunityBaseURL(bURL){
        communityBaseURL = bURL;
    }
    
    var communityName = '';   
    //Set community name from outside;
	function setCommunityName(comName) {
        communityName = comName;
    }
    // close tab and refresh console
    function closeAndRefreshTab(id) {
        if( isConsole() ) {
            sforce.console.getFocusedPrimaryTabId(refreshPrimaryTab);
            sforce.console.getEnclosingTabId(closeSubtab);
        }
        else {
            urlRedirect(id);
        }
    }
	
    // open tab and refresh console
    function openAndRefreshTab(id, type = 'tab') {
        if( isConsole() ) {
            
            if(type == 'tab') {
                sforce.console.openPrimaryTab(undefined, '/' + id + '?isdtp=vw', true);
            }
            else {
                sforce.console.getEnclosingPrimaryTabId(function(result)
                {
                    sforce.console.openSubtab(result.id, '/' + id + '?isdtp=vw', true);
                });
            }

            sforce.console.getEnclosingTabId(closeSubtab);
            sforce.console.getFocusedPrimaryTabId(refreshPrimaryTab);

        }
        else {
            urlRedirect(id);
        }
    }
    
    // open tab and refresh console
    function openTab(url, type = 'tab') {
        if( isConsole() ) {
            
            sforce.console.getEnclosingTabId(closeSubtab);
            
            if(type == 'tab') {
                sforce.console.openPrimaryTab(undefined, url , true);
            }
            else {
                sforce.console.getEnclosingPrimaryTabId(function(result)
                {
                    sforce.console.openSubtab(result.id, url, true);
                });
            }
            
            //sforce.console.getFocusedPrimaryTabId(refreshPrimaryTab);
        }
        else {
            urlRedirect(id);
        }
    }
    
    // close tab
    function closeTab(id) {
        if( isConsole() ) {
            sforce.console.getEnclosingTabId(closeSubtab);
        }
        else {
        	urlRedirect(id);
        }
    }

    // checks whether it is Lightning or Classic
    function isConsole() {
        if(sforce.console.isInConsole()) {
            return true;
        }
        return false;
    }
    
    // checks whether it is Lightning or Classic
    function isLightning() {
        if(document.referrer.indexOf(".lightning.force.com") > 0) {
            return true;
        }
        return false;
    }
    
    function isCommunity() {
        if(communityName !='') {//|| document.referrer.indexOf("/s/") > 0
            return true;
        }
        return false;
    }
    
    var closeSubtab = function closeSubtab(result) {
        sforce.console.closeTab(result.id);
    };


    var refreshPrimaryTab = function refreshPrimaryTab(result) {
        sforce.console.refreshPrimaryTabById(result.id , true);
    };

    // open report - function for url buttons
    function openReport( params ) 
    {
        var defaultParams = {Id:'',v0:'',v1:'',v2:'',v3:'',v4:'',v5:'',repFilter:''};
        params = Object.assign( defaultParams , params );
		
        if(isCommunity()) {
            alert('--->'+params['repFilter']);
            console.log('Param--->'+params['repFilter']);
            var repFilters = params['repFilter'];
            var urlParam = params['Id']+"?reportFilters="+repFilters;
            var url = communityBaseURL+"/s/report/"+urlParam; 	    
            alert(url);
            console.log('url--->'+url);
        	//sforce.one.navigateToURL(url);
        	window.parent.location.href = url;
        }else{
            if( isConsole() && isLightning()) {
                var url = "#/sObject/"+params['Id']+"?fv0="+params['v0']+"&fv1="+params['v1']+"&fv2="+params['v2']+"&fv3="+params['v3']+"&fv4="+params['v4']+"&fv5="+params['v5'];
                openTab(url,'subtab');
            }
            else {
                var url = "/"+params['Id']+"?pv0="+params['v0']+"&pv1="+params['v1']+"&pv2="+params['v2']+"&pv3="+params['v3']+"&pv4="+params['v4']+"&pv5="+params['v5'];
                if(isLightning() || isCommunity()) {
                    url = "/one/one.app#/sObject/"+params['Id']+"?fv0="+params['v0']+"&fv1="+params['v1']+"&fv2="+params['v2']+"&fv3="+params['v3']+"&fv4="+params['v4']+"&fv5="+params['v5'];
                }
                window.parent.location.href = url;
            }
        }
        
    }
    
    // open url
    function urlRedirect ( id ) 
    {
        if(isLightning() || isCommunity()) {
            if(isConsole()){
            	sforce.console.getFocusedPrimaryTabId(refreshPrimaryTab);
            }
            sforce.one.navigateToSObject(id);
        }
        else {
            window.parent.location="/"+id;
        }
    }
    
    w.uJS = functions;

})(window);
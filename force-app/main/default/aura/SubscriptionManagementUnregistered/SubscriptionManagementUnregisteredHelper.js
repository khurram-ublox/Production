({
    getJsonFromUrl : function () {
        console.log('init');
       var query = location.search.substr(1);
       var result = {};
       query.split("&").forEach(function(part) {
           var item = part.split("=");
           result[item[0]] = decodeURIComponent(item[1]);
       });
       return result;
    },
    redirectUrl : function () {
    	var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({
            "url": '/subscription' 
        });
        eUrl.fire();
    },
})
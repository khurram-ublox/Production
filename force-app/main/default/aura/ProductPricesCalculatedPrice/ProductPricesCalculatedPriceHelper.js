({
	sortPricesByDate : function(prices) {
        if(prices != null && prices.length >1)
        {
            return prices.sort(function(a,b){
              // Turn your strings into dates, and then subtract them
              // to get a value that is either negative, positive, or zero.
              return  new Date(a.validFrom)- new Date(b.validFrom);
            });
        }
        else
        {
            return prices;
        }
	},
    getCurrentPriceIndex: function(prices)
    {
        var currentDate = new Date();
        var selectedIndex = -1;
        for(var i = 0; i < prices.length; i++)
        {
            if(currentDate -  new Date(prices[i].validFrom) > 0)
            {
                selectedIndex = i;
            }
        }
        
        return selectedIndex;
    }
})
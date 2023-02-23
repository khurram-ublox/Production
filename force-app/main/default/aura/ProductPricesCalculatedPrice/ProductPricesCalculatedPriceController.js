({
    doInit : function(component, event, helper) {
        // Get a reference to the getWeather() function defined in the Apex controller
		var action = component.get("c.getProductPriceCalculatorDataByOppProdId");
        
        action.setParams({
            "oppProdId": component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            var data = response.getReturnValue();
            var price = 0;
            var priceUSD = 0;
            var nextPrice = 0;
            var nextPriceUSD = 0;
            var priceValidUntil = '';
            var currency = '';
            var priceData = null;
            var nextPriceData = null;
			if(data!=null && data.length > 0)
            {
            	var sortedPrices = helper.sortPricesByDate(data);        
                var selectedIndex = helper.getCurrentPriceIndex(sortedPrices);
                if(selectedIndex != -1)
                {
                    priceData = sortedPrices[selectedIndex];
                }
                if(sortedPrices.length > (selectedIndex+1))
                {
                    nextPriceData = sortedPrices[selectedIndex+1]; 
                }
				if(priceData != null)
				{  
				   if(priceData.amount >= 1 && priceData.amount < 10)
				   {
					   price = priceData.priceSampleSize1;
				   }
					
				   if(priceData.amount >= 10 && priceData.amount < 50)
				   {
					   price = priceData.priceSampleSize10;
				   }
				   
				   if(priceData.amount >= 50 && priceData.amount < 100)
				   {
					   price = priceData.priceSampleSize50;
				   }
					
				   if(priceData.amount >= 100 && priceData.amount < 250)
				   {
					   price = priceData.priceSampleSize100;
				   }
					
				   if(priceData.amount >= 250 && priceData.amount < 500)
				   {
					   price = priceData.priceSampleSize250;
				   }
					
				   if(priceData.amount >= 500 && priceData.amount < 1000)
				   {
					   price = priceData.priceSampleSize500;
				   }
				   
				   if(priceData.amount >= 1000)
				   {
					   price = priceData.priceSampleSize1000;
				   }
					
				   priceUSD = price;
				   price = price * priceData.priceMod;
				   price = Math.round(price * 100) / 100;
				   
				   currency = priceData.priceCurrency+' ';
				   
				}
            
				if(nextPriceData != null)
				{  
				   if(nextPriceData.amount > 1 && nextPriceData.amount < 10)
				   {
					   nextPrice = nextPriceData.priceSampleSize1;
				   }
					
				   if(nextPriceData.amount >= 1 && nextPriceData.amount < 50)
				   {
					   nextPrice = nextPriceData.priceSampleSize10;
				   }
				   
				   if(nextPriceData.amount >= 50 && nextPriceData.amount < 100)
				   {
					   nextPrice = priceData.priceSampleSize50;
				   }
				   
					if(nextPriceData.amount >= 100 && nextPriceData.amount < 250)
				   {
					   nextPrice = priceData.priceSampleSize100;
				   }
				   
				   if(nextPriceData.amount >= 250 && nextPriceData.amount < 500)
				   {
					   nextPrice = priceData.priceSampleSize250;
				   }
					
				   if(nextPriceData.amount >= 500 && nextPriceData.amount < 1000)
				   {
					   nextPrice = priceData.priceSampleSize500;
				   }
					
				   if(nextPriceData.amount >= 1000)
				   {
					   nextPrice = nextPriceData.priceSampleSize1000;
				   }
				   priceValidUntil = nextPriceData.validFrom;
				   nextPriceUSD = nextPrice;
				   nextPrice = nextPrice * nextPriceData.priceMod;
				   nextPrice = Math.round(nextPrice * 100) / 100;
				   
				   component.set("v.currency", priceData.priceCurrency+' ');
				}
            }
            component.set("v.price", price);
            component.set("v.priceUSD", priceUSD);
            component.set("v.nextPrice", nextPrice);
            component.set("v.nextPriceUSD", nextPriceUSD);
            component.set("v.currency", currency);
            component.set("v.priceValidUntil", priceValidUntil);
        });
        // Invoke the service
        $A.enqueueAction(action);
    }
    
})
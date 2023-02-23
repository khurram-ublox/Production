({
    doInit : function(component, event, helper) {
      
        var navService = component.find("navService");	
		var action = component.get("c.getProductsByProductPriceId");
        
        component.set('v.columns', 
        [
            { label: 'product name', fieldName: 'productName', type: 'text'},  
            { label: 'ordering number', fieldName: 'productLink', type: 'url', typeAttributes: {label: {fieldName:'orderingNumber'}}},
            { label: 'status', fieldName: 'productStatus', type: 'text'},  
            { label: 'Shop Active', fieldName: 'soldInWebShop', type: 'boolean'}
        ]);
        
        action.setParams({
            "productPriceId": component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var products = response.getReturnValue();
         
                if(products != null)
                {
                    component.set("v.products", products);
                }
            }
            else
            {
                console.log("Failed with state: " + state);
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                // Display the message
                console.error(message);
            }

        });
        // Invoke the service
        $A.enqueueAction(action);
    }
    
})
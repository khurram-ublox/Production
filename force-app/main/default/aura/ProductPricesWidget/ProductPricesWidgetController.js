({
    doInit : function(component, event, helper) 
    {
        var productId = component.get("v.recordId"); 
        component.set("v.exportSettingOnlyShopActive", 1);
        
   
        if(productId)
        {
           var action = component.get("c.getProduct"); 
           $A.enqueueAction(action);
            
           var action = component.get("c.getProductPrices");
		   $A.enqueueAction(action);
            
           component.set("v.productPricingScore", 0);
           component.set("v.selectedTab",'zero');
        }
        else   
        {
            component.set("v.selectedTab",'one');
        }
        
        var action = component.get("c.getAbacusPrices"); 
        $A.enqueueAction(action);
        
        var action = component.get("c.getMAPPrices"); 
        $A.enqueueAction(action);
    },
    getProduct: function(component, event, helper)
    {
        component.set("v.productStatus",'loading');
		var productId = component.get("v.recordId"); 
            
        if(productId)
        {
            var action = component.get("c.getProductByProductId"); 
            action.setParams({
                "productId": component.get("v.recordId")
            });
            action.setCallback(this, function(response) 
            {
                var state = response.getState();
                if (state === "SUCCESS") 
                {
                   component.set("v.productStatus",'success');
                   var product = response.getReturnValue(); 
                    console.log(product);
                   component.set("v.product", product);
                    
                   component.find("addPP_Name").set("v.value", product.Name + "-YYYY-MM-DD");
                   component.find("addPP_Product_Name").set("v.value", product.Name);
                   component.find("addPP_Ordering_Number").set("v.value", product.ProductCode);
                   component.find("addPP_Currency").set("v.value", "USD"); 
                }
                else 
                {
                    component.set("v.productStatus",'error');
                    console.log("Failed with state: " + state);
                    let errors = response.getError();
                    let message = 'Unknown error'; // Default error message
                    // Retrieve the error message sent by the server
                    console.error(errors);
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        message = errors[0].message;
                    }
                    // Display the message
                    console.error(message);
                }
            });
            // Send action off to be executed
            $A.enqueueAction(action);
    	}
    },
    getProductPrices: function(component, event, helper)
    {
        component.set("v.productPricesStatus",'loading');
        
        component.set('v.productpricesColumns', 
        [
            { label: 'Product Price Name', fieldName: 'link', type: 'url', typeAttributes: {label: {fieldName:'name'}}},
            { label: 'Product Name', fieldName: 'productName', type: 'text'},
            { label: 'Ordering Number', fieldName: 'orderingNumber', type: 'text'},
            { label: 'Valid From', fieldName: 'validFrom', type: 'text'},   
            { label: '1+ Price USD', fieldName: 'priceSampleSize1', type: 'number', typeAttributes: { minimumFractionDigits: '4' }}, 
           	{ label: '10+ Price USD', fieldName: 'priceSampleSize10', type: 'number', typeAttributes: { minimumFractionDigits: '4' }},
            { label: '50+ Price USD', fieldName: 'priceSampleSize50', type: 'number', typeAttributes: { minimumFractionDigits: '4' }},
            { label: '100+Price USD', fieldName: 'priceSampleSize100', type: 'number', typeAttributes: { minimumFractionDigits: '4' }},
            { label: '250+ Price USD', fieldName: 'priceSampleSize250', type: 'number', typeAttributes: { minimumFractionDigits: '4' }},
            { label: '500+ Price USD', fieldName: 'priceSampleSize500', type: 'number', typeAttributes: { minimumFractionDigits: '4' }},
            { label: '1000+ Price USD', fieldName: 'priceSampleSize1000', type: 'number', typeAttributes: { minimumFractionDigits: '4' }}
        ]);

        var action = component.get("c.getProductsPricesByProductId"); 
        action.setParams({
            "productId": component.get("v.recordId")
        }); 
        action.setCallback(this, function(response) 
        {
        	var state = response.getState();
            if (state === "SUCCESS") 
            {
                var productPrices = response.getReturnValue(); 
         
            	console.log(productPrices);
             	component.set("v.productPrices", productPrices);
                component.set("v.productPricingScore", "1");
               	component.set("v.productPricesStatus",'loaded successfully (# '+productPrices.length+')');          
            }
            else 
            {
             	component.set("v.productPricesStatus",'error loading');
                console.log("Failed with state: " + state);
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                console.error(errors);
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                // Display the message
                console.error(message);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    getAbacusPrices: function(component, event, helper)
    {
        component.set("v.abacusStatus",'loading');

        component.set('v.abacusColumns', 
        [
        	//{ label: '   id', fieldName: 'id', type: 'text'},
            { label: 'Product Price Name', fieldName: 'link', type: 'url', typeAttributes: {label: {fieldName:'name'}}},
            
            { label: 'Condition Number', fieldName: 'conditionNumber', type: 'text'},
            { label: 'Currency', fieldName: 'priceCurrency', type: 'text'},
            { label: 'Customer Category', fieldName: 'customerCategory', type: 'text'},
            { label: 'Customer Group Number', fieldName: 'customerGroupNumber', type: 'number'}, 
			{ label: 'Product Category', fieldName: 'productCategory', type: 'text'},    
            { label: 'Ordering Number', fieldName: 'productLink', type: 'url', typeAttributes: {label: {fieldName:'orderingNumber'}}},
            { label: 'Start Date', fieldName: 'startDate', type: 'text'},
            { label: 'Series To Amount', fieldName: 'seriesToAmount', type: 'number'}, 
            { label: 'Series Price', fieldName: 'seriesPrice', type: 'number', typeAttributes: { minimumFractionDigits: '2' }}
        ]);
        
        var productId = component.get("v.recordId"); 
        var action = component.get("c.getAbacusProductsPrices"); 
        
        if(productId)
        {
            action.setParams({
            	"productId": component.get("v.recordId"),
                "allProducts": !component.get("v.exportSettingOnlyShopActive")
            });
        }
        else 
        {
            action.setParams({
                "allProducts": !component.get("v.exportSettingOnlyShopActive")
            });
        }
     
        action.setCallback(this, function(response) 
        {
        	var state = response.getState();
            if (state === "SUCCESS") 
            {
                console.log('getAbacusProductsPrices Success!!!');
                var abacusProductPrices = response.getReturnValue(); 
               	var filteredAbacusProductPrices = [];
            	console.log(abacusProductPrices);
             	component.set("v.abacusProductPricesCurrentlyDisplayed", abacusProductPrices.slice(0, 100));
            	var productsWithoutAMatch = 0;
                for(var i = 0; i < abacusProductPrices.length; i++)
                {
                    if(abacusProductPrices[i].productId == null || abacusProductPrices[i].productId == '')
                    {
                        productsWithoutAMatch++;
                        abacusProductPricesWithIssues.push(abacusProductPrices[i]);  
                    }
                    else
                    {
                     	filteredAbacusProductPrices.push(abacusProductPrices[i]);
                       // console.log(productPrices[i].productId);
                    }
                }
                component.set("v.abacusProductPrices", filteredAbacusProductPrices);
                component.set("v.abacusStatus",'loaded successfully (# '+filteredAbacusProductPrices.length+')');          
            }
            else 
            {
             	component.set("v.abacusStatus",'error loading');
                console.log("Failed with state: " + state);
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                console.error(errors);
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                // Display the message
                console.error(message);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
 /*   getAllAbacusPrices: function(component, event, helper)
    {
        component.set("v.abacusStatus",'loading');
        var productId = component.get("v.recordId"); 
        var action;
        
        if(productId)
        {
            //action = component.get("c.getAbacusProductsPricesByProductId"); 
            action = component.get("c.getAbacusProductsPrices"); 
            action.setParams({
            	"productId": component.get("v.recordId"),
                "allProducts": !component.get("v.exportSettingOnlyShopActive")
            });
        }
        else
        {
        	action = component.get("c.getAbacusProductsPrices");

        }
	
        action.setCallback(this, function(response) 
        {
        	var state = response.getState();
            if (state === "SUCCESS") 
            {
                var abacusProductPrices = response.getReturnValue(); 
               	var filteredAbacusProductPrices = [];
            	//console.log(abacusProductPrices[0]);
             	component.set("v.abacusProductPricesCurrentlyDisplayed", abacusProductPrices.slice(0, 100));
            	var productsWithoutAMatch = 0;
                for(var i = 0; i < abacusProductPrices.length; i++)
                {
                    if(abacusProductPrices[i].productId == null || abacusProductPrices[i].productId == '')
                    {
                        productsWithoutAMatch++;
                        abacusProductPricesWithIssues.push(abacusProductPrices[i]);  
                    }
                    else
                    {
                     	filteredAbacusProductPrices.push(abacusProductPrices[i]);
                       // console.log(productPrices[i].productId);
                    }
                }
                component.set("v.abacusProductPrices", filteredAbacusProductPrices);
                component.set("v.abacusStatus",'loaded successfully (# '+filteredAbacusProductPrices.length+')');          
            }
            else 
            {
             	component.set("v.abacusStatus",'error loading');
                console.log("Failed with state: " + state);
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                console.error(errors);
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                // Display the message
                console.error(message);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },*/
    abacusOnlyShopActiveCheckboxClick: function (component, evt) {
        console.log('abacusOnlyShopActiveCheckboxClick');
         var checkCmp = component.find("export_setting_only_shop_active");
         //console.log(checkCmp);
         console.log(component.get("v.exportSettingOnlyShopActive"));
         var action = component.get("c.getAbacusPrices"); 
         $A.enqueueAction(action);
    },
    getMAPPrices: function(component, event, helper)
    {
        component.set("v.mapStatus",'loading');
       	component.set('v.mycolumns', 
        [
        	//{ label: '   id', fieldName: 'id', type: 'text'}, 
            { label: 'Product Prices ID', fieldName: 'link', type: 'url', typeAttributes: {label: {fieldName:'name'}}},
            { label: 'Technology', fieldName: 'technology', type: 'text'},  
            { label: 'Description', fieldName: 'description', type: 'text'},  
            { label: 'Product Name', fieldName: 'productName', type: 'text'},  
            { label: 'Shop Active', fieldName: 'soldInWebShop', type: 'boolean'},
            { label: 'Ordering Number', fieldName: 'productLink', type: 'url', typeAttributes: {label: {fieldName:'orderingNumber'}}},
            //{ label: 'Valid From', fieldName: 'validFrom', type: 'date'},
            //{ label: 'Packaging Size', fieldName: 'moq', type: 'number'},      
            { label: 'Max MAP Pricing', fieldName: 'maxMapPricing', type: 'number'},   
            { label: 'Price_USD_Sample_Size_1', fieldName: 'priceSampleSize1', type: 'number', typeAttributes: { minimumFractionDigits: '4' }}, 
           	{ label: 'Price_USD_Sample_Size_10', fieldName: 'priceSampleSize10', type: 'number', typeAttributes: { minimumFractionDigits: '4' }},
            { label: 'Price_USD_Sample_Size_50', fieldName: 'priceSampleSize50', type: 'number', typeAttributes: { minimumFractionDigits: '4' }},
            { label: 'Price_USD_Sample_Size_100', fieldName: 'priceSampleSize100', type: 'number', typeAttributes: { minimumFractionDigits: '4' }},
            { label: 'Price_USD_Sample_Size_250', fieldName: 'priceSampleSize250', type: 'number', typeAttributes: { minimumFractionDigits: '4' }},
            { label: 'Price_USD_Sample_Size_500', fieldName: 'priceSampleSize500', type: 'number', typeAttributes: { minimumFractionDigits: '4' }},
            { label: 'Price_USD_Sample_Size_1000', fieldName: 'priceSampleSize1000', type: 'number', typeAttributes: { minimumFractionDigits: '4' }},
            
        ]);
        
        var productId = component.get("v.recordId"); 
        var action = component.get("c.getMapProductsPrices"); 
        
        if(productId)
        { 
            action.setParams({
            	"productId": component.get("v.recordId")
            });
        }

        action.setCallback(this, function(response) 
        {
        	var state = response.getState();
            if (state === "SUCCESS") 
            {
                var tempMapPrices = response.getReturnValue();
                var productPricesWithIssues = [];
                console.log('mapProductPrices:');
                console.log(tempMapPrices);

                component.set("v.mapProductPrices", tempMapPrices);
                component.set("v.mapStatus",'loaded successfully');
                //console.log('loaded '+tempMapPrices.length+' product prices');
                var productsWithoutAMatch = 0;
                for(var i = 0; i < tempMapPrices.length; i++)
                {
                    if(tempMapPrices[i].productId == null || tempMapPrices[i].productId =='')
                    {
                        productsWithoutAMatch++;
                        productPricesWithIssues.push(tempMapPrices[i]);
                    }
                    else
                    {
                       // console.log(productPrices[i].productId);
                    }
                }
                
                component.set("v.productPricesWithIssues", productPricesWithIssues);
                component.set("v.mapStatus",'loaded successfully (# '+ tempMapPrices.length +')');
               	component.set("v.issuesStatus",'issues (# '+productPricesWithIssues.length + ') ');
               
                //console.log(''+productsWithoutAMatch+' product prices without a match');
                // console.log(productPrices[0]);
				//var action2 = component.get("c.convertMapToAbacus"); 
        		//$A.enqueueAction(action2);
            }
            else 
            {
                component.set("v.mapStatus",'error loading');
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
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    toggleMapTable: function(component, event, helper) {
       helper.toggleTable(component, 'maptable');
    },
    toggleAbacusTable: function(component, event, helper) {
       helper.toggleTable(component, 'abacustable');
    },
    addProductPrice : function(component, event, helper) {
     	helper.showPopupHelper(component, 'modalcreatepricedialog', 'slds-fade-in-');
		helper.showPopupHelper(component, 'backdrop','slds-backdrop--');
    },
    handleAddProductPriceLoad: function(component, event, helper) {
    	component.find("addPP_Name").set("v.value", component.find("addPP_Ordering_Number").get("v.value") + '-' + component.find("addPP_ValidFrom").get("v.value"));
    },
    handleAddProductPriceSubmit: function(component, event, helper) {  
       //var fields = event.getParam("fields");
       //fields.Name =fields.Product_Name__c + '-' + fields.Valid_From__c;
       /* event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        fields.Name =fields.Product_Name__c + '-' + fields.Valid_From__c;
        component.find('myRecordForm').submit(fields);
        */
       //component.find("addPP_Name").set("v.value", fields.Product_Name__c + '-' + fields.Valid_From__c);
    },
   	handleValidFromChange: function(component, event, helper) {  
 
    
    
        component.find("addPP_Name").set("v.value", component.find("addPP_Ordering_Number").get("v.value") + '-' + $A.localizationService.formatDate(component.find("addPP_ValidFrom").get("v.value"), "yyyy-MM-dd"));
    },
    handleAddProductPriceSuccess: function(component, event, helper) {
        
        component.find("addPP_Price_Sample_Size_1").reset();
        component.find("addPP_Price_Sample_Size_10").reset();
        component.find("addPP_Price_Sample_Size_50").reset();
        component.find("addPP_Price_Sample_Size_100").reset();
        component.find("addPP_Price_Sample_Size_250").reset();
        component.find("addPP_Price_Sample_Size_500").reset();
        component.find("addPP_Price_Sample_Size_1000").reset();
        
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Saved",
            "message": "The record was saved.",
            "type": "success"
        });
        resultsToast.fire();
        
		helper.hidePopupHelper(component, 'modalcreatepricedialog', 'slds-fade-in-');
		helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
        
        var action = component.get("c.getProductPrices");
        $A.enqueueAction(action);
    },
    handleAddProductPriceCancel: function(component, event, helper) {

        component.find("addPP_Price_Sample_Size_1").reset();
        component.find("addPP_Price_Sample_Size_10").reset();
        component.find("addPP_Price_Sample_Size_50").reset();
        component.find("addPP_Price_Sample_Size_100").reset();
        component.find("addPP_Price_Sample_Size_250").reset();
        component.find("addPP_Price_Sample_Size_500").reset();
        component.find("addPP_Price_Sample_Size_1000").reset();
        
		helper.hidePopupHelper(component, 'modalcreatepricedialog', 'slds-fade-in-');
		helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
    },
    handleClick: function(component, event, helper) {
        var btnClicked = event.getSource();         // the button
        var btnMessage = btnClicked.get("v.label"); // the button's label
        component.set("v.message", btnMessage);     // update our message
    },
    abacusExportPopup : function(component, event, helper) 
    {
    	helper.showPopupHelper(component, 'modaldialog', 'slds-fade-in-');
		helper.showPopupHelper(component,'backdrop','slds-backdrop--');
    },
    abortAbacusExport : function(component, event, helper) 
    {
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
		helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
    },
    abacusExport : function(component, event, helper) 
    {
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
		helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
    
        var abacusProductPrices = component.get("v.abacusProductPrices");
        var PositionTitle = 'Selected Position';
        var data = [];
        var headerArray = [];
        var csvContentArray = [];

        //Provide the title 
        var CSV = '';
        
        //Fill out the Header of CSV
		headerArray.push('Konditionsnummer');
        headerArray.push('Waehrung');
        headerArray.push('Kundenstufe');
        headerArray.push('Kunden_Gruppennummer');
        headerArray.push('Produktstufe');
        headerArray.push('Produkt_Gruppennummer');
        headerArray.push('Staffel_vonDatum');
        headerArray.push('Staffel_bisMenge');
        headerArray.push('Staffel_Preis');
        data.push(headerArray);

        var sno = 0;
        for(var i=0;i<abacusProductPrices.length;i++)
        {
            //Initialize the temperory array
            var tempArray = [];
            //use parseInt to perform math operation
            sno = parseInt(sno) + parseInt(1);
            tempArray.push(abacusProductPrices[i].conditionNumber);
            tempArray.push(abacusProductPrices[i].priceCurrency);
            tempArray.push(abacusProductPrices[i].customerCategory);
            tempArray.push(abacusProductPrices[i].customerGroupNumber);
            tempArray.push(abacusProductPrices[i].productCategory);
            tempArray.push(abacusProductPrices[i].orderingNumber);
            tempArray.push(abacusProductPrices[i].startDate);
            var seriesToAmount = abacusProductPrices[i].seriesToAmount.toString();
            seriesToAmount = seriesToAmount + '.0000';
            var seriesPrice = abacusProductPrices[i].seriesPrice.toString();
            var posDot = seriesPrice.indexOf('.');
            var length = seriesPrice.length;
            if(posDot == -1)
            {
                seriesPrice = seriesPrice + '.00';
            }
            else
            {
                var numberOfDecimals = length-1-posDot;
                if(numberOfDecimals == 0)
                {
                    seriesPrice = seriesPrice + '00';
                }
                if(numberOfDecimals == 1)
                {
                    seriesPrice = seriesPrice + '0';
                }

            }
            console.log(seriesPrice + ' #'+posDot+' #'+length);
            
            tempArray.push(seriesToAmount);
            tempArray.push(seriesPrice); 
            
            data.push(tempArray);
        }
        //console.dir(data);
        for(var j=0;j<data.length;j++){
            var dataString = data[j].join(";")+';';
            //console.log(dataString);
            csvContentArray.push(dataString); 
        }
       
        var csvContent = CSV;
        csvContent = csvContentArray.join("\r\n");
        csvContent = csvContent+"\r\n"
           
        //Generate a file name
        var fileName = "Abacus_CSV_Export_1";
        //this will remove the blank-spaces from the title and replace it with an underscore
     
        fileName += ".csv";
        //Initialize file format you want csv or xls
        var uri = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent);
        //console.dir(csvContent);
        if (navigator.msSaveBlob) { // IE 10+
            //console.log('----------------if-----------');
            var blob = new Blob([csvContent],{type: "text/csv;charset=utf-8;"});
            //console.log('----------------if-----------'+blob);
        	navigator.msSaveBlob(blob, fileName);
        }
        else{
            // Download file
            // you can use either>> window.open(uri);
            // but this will not work in some browsers
            // or you will not get the correct file extension    
            var link = document.createElement("a");

            //link.download to give filename with extension
            //link.download = fileName;
            link.setAttribute('download',fileName);
            //To set the content of the file
            link.href = uri;
            
            //set the visibility hidden so it will not effect on your web-layout
            link.style = "visibility:hidden";
            
            //this part will append the anchor tag and remove it after automatic click
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
          
    	}
    },
    abacusXLSExport : function(component, event, helper) 
    {
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
		helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
    
        var abacusProductPrices = component.get("v.abacusProductPrices");
        var PositionTitle = 'Selected Position';
        var data = [];
        var headerArray = [];
        var csvContentArray = [];

        //Provide the title 
        var CSV = '<?xml version="1.0" encoding="UTF-8"?>\r\n<?mso-application progid="Excel.Sheet"?>\r\n<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="https://www.w3.org/TR/html401/">\r\n';
     
        //Fill out the Header of CSV
		headerArray.push('<Cell><Data ss:Type="String">Konditionsnummer</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Waehrung</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Kundenstufe</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Kunden_Gruppennummer</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Produktstufe</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Produkt_Gruppennummer</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Staffel_vonDatum</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Staffel_bisMenge</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Staffel_Preis</Data></Cell>');
        data.push(headerArray);

        var sno = 0;
        for(var i=0;i<abacusProductPrices.length;i++)
        {
            //Initialize the temperory array
            var tempArray = [];
            //use parseInt to perform math operation
            sno = parseInt(sno) + parseInt(1);
            tempArray.push('<Cell><Data ss:Type="String">'+abacusProductPrices[i].conditionNumber+'</Data></Cell>');
            tempArray.push('<Cell><Data ss:Type="String">'+abacusProductPrices[i].priceCurrency+'</Data></Cell>');
            tempArray.push('<Cell><Data ss:Type="String">'+abacusProductPrices[i].customerCategory+'</Data></Cell>');
            tempArray.push('<Cell><Data ss:Type="Number">'+abacusProductPrices[i].customerGroupNumber+'</Data></Cell>');
            tempArray.push('<Cell><Data ss:Type="String">'+abacusProductPrices[i].productCategory+'</Data></Cell>');
            tempArray.push('<Cell><Data ss:Type="String">'+abacusProductPrices[i].orderingNumber+'</Data></Cell>');
            tempArray.push('<Cell><Data ss:Type="String">'+abacusProductPrices[i].startDate+'</Data></Cell>');
            tempArray.push('<Cell><Data ss:Type="Number">'+abacusProductPrices[i].seriesToAmount+'</Data></Cell>');
            tempArray.push('<Cell><Data ss:Type="Number">'+abacusProductPrices[i].seriesPrice+'</Data></Cell>'); 
            
            data.push(tempArray);
        }
        
        //console.dir(data);
        for(var j=0;j<data.length;j++){
            var dataString = '<Row>' + data[j].join("\r\n")+ '</Row>';
            //console.log(dataString);
            csvContentArray.push(dataString); 
        }
       
        var csvContent = CSV;
        csvContent = csvContent +'<Worksheet ss:Name="Abacus Import">\r\n<Table>\r\n<Column ss:Index="1" ss:AutoFitWidth="0" ss:Width="110"/>'+ csvContentArray.join("\r\n") +'</Table>\r\n</Worksheet>\r\n';
        csvContent = csvContent +'</Workbook>\r\n';
        
        //Generate a file name
        var fileName = "Abacus_Export_1";
        //this will remove the blank-spaces from the title and replace it with an underscore
     
        fileName += ".xls";
        //Initialize file format you want csv or xls
        var uri = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent);
        //console.dir(csvContent);
        if (navigator.msSaveBlob) { // IE 10+
            //console.log('----------------if-----------');
            var blob = new Blob([csvContent],{type: "text/csv;charset=utf-8;"});
            //console.log('----------------if-----------'+blob);
        	navigator.msSaveBlob(blob, fileName);
        }
        else{
            // Download file
            // you can use either>> window.open(uri);
            // but this will not work in some browsers
            // or you will not get the correct file extension    
            var link = document.createElement("a");

            //link.download to give filename with extension
            //link.download = fileName;
            link.setAttribute('download',fileName);
            //To set the content of the file
            link.href = uri;
            
            //set the visibility hidden so it will not effect on your web-layout
            link.style = "visibility:hidden";
            
            //this part will append the anchor tag and remove it after automatic click
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
          
    	}
    },
    /********************************************************
     * export : Function used to export the selected records 
     * ***************************************************/
    export : function(component, event, helper) {
        var productPrices = component.get("v.mapProductPrices");
        var PositionTitle = 'Selected Position';
        var dataPos = [];
        var dataSho = [];
        var dataCel = [];
        var headerArray = [];
        var csvContentArrayPos = [];
        var csvContentArraySho = [];
        var csvContentArrayCel = [];
        //Provide the title 
        var CSV = '<?xml version="1.0" encoding="UTF-8"?>\r\n<?mso-application progid="Excel.Sheet"?>\r\n<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="https://www.w3.org/TR/html401/">\r\n';
     
        //Fill out the Header of CSV
		headerArray.push('<Cell><Data ss:Type="String">Technology</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Description</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Ordering Number</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Shop Active</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Product Name</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Max Map Pricing</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Sample. 1+</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Sample. 10+</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Sample. 50+</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Sample. 100+</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Sample. 250+</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Sample. 500+</Data></Cell>');
        headerArray.push('<Cell><Data ss:Type="String">Sample. 1000+</Data></Cell>');
       
        dataPos.push(headerArray);
        dataSho.push(headerArray);
        dataCel.push(headerArray);

        var sno = 0;
        for(var i=0;i<productPrices.length;i++)
        {
            //Initialize the temperory array
            var tempArray = [];
            //use parseInt to perform math operation
            sno = parseInt(sno) + parseInt(1);
            if(productPrices[i].technology)
            {
            	tempArray.push('<Cell><Data ss:Type="String">'+productPrices[i].technology+'</Data></Cell>');
            }
            else
            {
               tempArray.push('<Cell><Data ss:Type="String"></Data></Cell>');
            } 
            
            if(productPrices[i].description)
            {
            	tempArray.push('<Cell><Data ss:Type="String">'+productPrices[i].description+'</Data></Cell>');
            }
            else
            {
               tempArray.push('<Cell><Data ss:Type="String"></Data></Cell>');
            } 
           
            tempArray.push('<Cell><Data ss:Type="String">'+productPrices[i].orderingNumber+'</Data></Cell>');
            
            if(productPrices[i].soldInWebShop != null)
            {
            	tempArray.push('<Cell><Data ss:Type="String">'+productPrices[i].soldInWebShop+'</Data></Cell>');
            }
            else
            {
               tempArray.push('<Cell><Data ss:Type="String"></Data></Cell>');
            } 
 
            tempArray.push('<Cell><Data ss:Type="String">'+productPrices[i].productName+'</Data></Cell>');
            tempArray.push('<Cell><Data ss:Type="String">'+productPrices[i].maxMapPricing+'</Data></Cell>');
            if(productPrices[i].priceSampleSize1 != null)
            {
            	tempArray.push('<Cell><Data ss:Type="String">'+(productPrices[i].priceSampleSize1+'').replace(".", ",")+'</Data></Cell>');
            }
            else   
            {
            	tempArray.push('<Cell><Data ss:Type="String"></Data></Cell>');
            }
            
          	if(productPrices[i].priceSampleSize10 != null)
            {
            	tempArray.push('<Cell><Data ss:Type="String">'+(productPrices[i].priceSampleSize10+'').replace(".", ",")+'</Data></Cell>');
            }
            else   
            {
            	tempArray.push('<Cell><Data ss:Type="String"></Data></Cell>');
            }  
            
           	if(productPrices[i].priceSampleSize50 != null)
            {
            	tempArray.push('<Cell><Data ss:Type="String">'+(productPrices[i].priceSampleSize50+'').replace(".", ",")+'</Data></Cell>');
            }
            else   
            {
            	tempArray.push('<Cell><Data ss:Type="String"></Data></Cell>');
            }   
            
            if(productPrices[i].priceSampleSize100 != null)
            {
            	tempArray.push('<Cell><Data ss:Type="String">'+(productPrices[i].priceSampleSize100+'').replace(".", ",")+'</Data></Cell>');
            }
            else   
            {
            	tempArray.push('<Cell><Data ss:Type="String"></Data></Cell>');
            } 
            
            if(productPrices[i].priceSampleSize250 != null)
            {
            	tempArray.push('<Cell><Data ss:Type="String">'+(productPrices[i].priceSampleSize250+'').replace(".", ",")+'</Data></Cell>');
            }
            else   
            {
            	tempArray.push('<Cell><Data ss:Type="String"></Data></Cell>');
            }   
            
            if(productPrices[i].priceSampleSize500 != null)
            {
            	tempArray.push('<Cell><Data ss:Type="String">'+(productPrices[i].priceSampleSize500+'').replace(".", ",")+'</Data></Cell>');
            }
            else   
            {
            	tempArray.push('<Cell><Data ss:Type="String"></Data></Cell>');
            }   
            
            if(productPrices[i].priceSampleSize1000 != null)
            {
            	tempArray.push('<Cell><Data ss:Type="String">'+(productPrices[i].priceSampleSize1000+'').replace(".", ",")+'</Data></Cell>');
            }
            else   
            {
            	tempArray.push('<Cell><Data ss:Type="String"></Data></Cell>');
            }   
            
            
            
            if(productPrices[i].productCenter == 'Positioning')
            {
                dataPos.push(tempArray);
            }
            else
            {
               if(productPrices[i].productCenter == 'Short Range')
                {
                    dataSho.push(tempArray);
                } 
                else
                {
                    if(productPrices[i].productCenter == 'Cellular')
                    {
                        dataCel.push(tempArray);
                    }
                    else
                    {
                        // as a fallback add the entry to dataPos
                        dataPos.push(tempArray);
                    }
                    
                }
            }
            
            
            
          
        }
        
        for(var j=0;j<dataCel.length;j++){
            var dataString = '<Row>' + dataCel[j].join("\r\n")+ '</Row>';
            csvContentArrayCel.push(dataString);
        }
        for(var j=0;j<dataSho.length;j++){
            var dataString = '<Row>' + dataSho[j].join("\r\n")+ '</Row>';
            csvContentArraySho.push(dataString);
        }
        for(var j=0;j<dataPos.length;j++){
            var dataString = '<Row>' + dataPos[j].join("\r\n")+ '</Row>';
            csvContentArrayPos.push(dataString);
        }
        var csvContent = CSV;
        csvContent = csvContent +'<Worksheet ss:Name="CEL USD">\r\n<Table>\r\n<Column ss:Index="1" ss:AutoFitWidth="0" ss:Width="110"/>'+ csvContentArrayCel.join("\r\n") +'</Table>\r\n</Worksheet>\r\n';
        csvContent = csvContent +'<Worksheet ss:Name="POS USD">\r\n<Table>\r\n<Column ss:Index="1" ss:AutoFitWidth="0" ss:Width="110"/>'+ csvContentArrayPos.join("\r\n") +'</Table>\r\n</Worksheet>\r\n'
        csvContent = csvContent +'<Worksheet ss:Name="SHO USD">\r\n<Table>\r\n<Column ss:Index="1" ss:AutoFitWidth="0" ss:Width="110"/>'+ csvContentArraySho.join("\r\n") +'</Table>\r\n</Worksheet>\r\n'
        csvContent = csvContent +'</Workbook>\r\n';
        
        //Generate a file name
        var fileName = "MAP_Export_1";
        //this will remove the blank-spaces from the title and replace it with an underscore
     
        fileName += ".xls";
        //Initialize file format you want csv or xls
        var uri = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent);
        //console.dir(csvContent);
        
        if (navigator.msSaveBlob) { // IE 10+
            //console.log('----------------if-----------');
            var blob = new Blob([csvContent],{type: "text/csv;charset=utf-8;"});
            //console.log('----------------if-----------'+blob);
        	navigator.msSaveBlob(blob, fileName);
        }
        else{
            // Download file
            // you can use either>> window.open(uri);
            // but this will not work in some browsers
            // or you will not get the correct file extension    
            var link = document.createElement("a");

            //link.download to give filename with extension
            //link.download = fileName;
            link.setAttribute('download',fileName);
            //To set the content of the file
            link.href = uri;
            
            //set the visibility hidden so it will not effect on your web-layout
            link.style = "visibility:hidden";
            
            //this part will append the anchor tag and remove it after automatic click
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
          
    	}
    }
})
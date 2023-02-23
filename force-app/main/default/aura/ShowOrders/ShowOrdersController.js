({
	init : function(component, event, helper) {

        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.

            if (sParameterName[0] === 'Name') { //lets say you are looking for param name - firstName
                component.set('v.AccountName', sParameterName[1]);
            }
        }
        component.set('v.dataSpinner', true);

        component.set("v.Columns", [
            { label: 'Order Name', fieldName: 'OrderName', type:'url', sortable:true, hideDefaultActions: "true",wrapText: true, typeAttributes: { label: { fieldName: 'Name' }, target: '_blank', tooltip: {fieldName: 'Order Name'} }},
            //{ label: 'Order No.', fieldName: 'Order_No__c', type: 'Number', sortable:true, hideDefaultActions: "true",wrapText: true},
        	{ label: 'PO No Line Item', fieldName: 'PO_No_Line_Item__c', type: 'Text', sortable:true, hideDefaultActions: "true",wrapText: true},
            { label: 'Invoice Number', fieldName: 'Invoice_Number__c', type: 'Text',sortable:true, hideDefaultActions: "true",wrapText: true},
            { label: 'Reference', fieldName: 'Reference__c', type:'Text', sortable:true, hideDefaultActions: "true",wrapText: true},
            { label: 'Account Name', fieldName: 'AccountName', type:'url', sortable:true, hideDefaultActions: "true",wrapText: true, typeAttributes: { label: { fieldName: 'accName' }, target: '_blank', tooltip: {fieldName: 'Account Name'} }},
            { label: 'Reporting uB Office', fieldName: 'Reporting_uB_Office__c', type:'Text', sortable:true, hideDefaultActions: "true",wrapText: true},
            { label: 'Order Status', fieldName: 'Order_Status__c', type:'Text', sortable:true, hideDefaultActions: "true",wrapText: true},
			{ label: 'Type Number', fieldName: 'Product_ID__c', type:'Text', sortable:true, hideDefaultActions: "true",wrapText: true},
            //{ label: 'Frame Order', fieldName: 'Frame_Order__c', type:'boolean', sortable:true, hideDefaultActions: "true",wrapText: true},
            { label: 'Order Date', fieldName: 'Order_Date__c', type:'Date', sortable:true, hideDefaultActions: "true",wrapText: true},
            { label: 'Request Date', fieldName: 'Request_Date__c', type:'Date', sortable:true, hideDefaultActions: "true",wrapText: true},
            { label: 'Delivery Date', fieldName: 'Delivery_Date__c', type:'Text', sortable:true, hideDefaultActions: "true",wrapText: true},
            { label: 'Qty Ordered', fieldName: 'Qty_Ordered__c', type:'Number', sortable:true, hideDefaultActions: "true",wrapText: true},
            { label: 'Qty Invoiced', fieldName: 'Qty_Invoiced__c', type:'Number', sortable:true, hideDefaultActions: "true",wrapText: true},
            { label: 'Price per unit', fieldName: 'Price_per_unit__c', type:'Currency', sortable:true, hideDefaultActions: "true",wrapText: true},
            { label: 'Total Value', fieldName: 'Total_Value__c', type:'Currency', sortable:true, hideDefaultActions: "true",wrapText: true },
            { label: 'End Customer Account', fieldName: 'End_Customer_Account__c', type:'url', sortable:true, hideDefaultActions: "true",wrapText: true, typeAttributes: { label: { fieldName: 'endCustomer' }, target: '_blank', tooltip: {fieldName: 'End Customer Account'} }},     
            { label: 'Project Owner Account', fieldName: 'Project_Owner_Account__c', type:'url', sortable:true, hideDefaultActions: "true",wrapText: true,  typeAttributes: { label: { fieldName: 'projOwnerAcc' }, target: '_blank', tooltip: {fieldName: 'Project Owner Account'} }},
          
    	]);
            
        var baseURL = $A.get("$Label.c.PartnerPortalURL");
        var action = component.get("c.getOrders");
        action.setParams({recordId: component.get("v.recordId") });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                	records.forEach(function(record){
                    record.OrderName = baseURL+record.Id;
                   	record.accName= record.Account__r.Name;
            		record.AccountName = baseURL+record.Account__c;
            		if(record.End_Customer_Account__r){
            			record.endCustomer= record.End_Customer_Account__r ? record.End_Customer_Account__r.Name : '';
            			record.End_Customer_Account__c = baseURL+record.End_Customer_Account__c;
            			
            		}else{
            			record.endCustomer = '';
            			record.End_Customer_Account__c = '';
            		}
            		if(record.Project_Owner_Account__r){
            			record.projOwnerAcc= record.Project_Owner_Account__r ? record.Project_Owner_Account__r.Name : '';
            			record.Project_Owner_Account__c = baseURL+record.Project_Owner_Account__c;
            			
            		}else{
            			record.projOwnerAcc = '';
            			record.Project_Owner_Account__c = '';
            		}	
                });        
    
                component.set('v.dataSpinner', false);
                component.set('v.Orders', records);
                //component.set("v.Orders", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
        // sorting
        sortColumn : function (component, event, helper) {
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            component.set("v.sortedBy", fieldName);
            component.set("v.sortedDirection", sortDirection);
            helper.sortData(component, fieldName, sortDirection);
        },
        downloadTableData : function (component, event, helper) {
            var tableCSVData = helper.convertTableDataToCSVString(component);
            if(tableCSVData == '')
            	return;
            var hiddenElement = document.createElement('a');            
          	hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURIComponent(tableCSVData);
          	hiddenElement.target = '_self'; // 
          	hiddenElement.download = 'Account_'+component.get("v.recordId")+'.csv';  
          	document.body.appendChild(hiddenElement); // Required for FireFox browser
    	  	hiddenElement.click();
        }
})
({
      handleSelect : function(component, event, helper) {
        
        var selectedRows = event.getParam('selectedRows'); 
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            
            setRows.push(selectedRows[i]);

        }
        component.set("v.selectedCases", setRows);
        
    },
	init: function(component, event, helper)
	{
        
           component.set('v.mycolumn', [
             {label: 'Select', fieldName: 'Select', type: 'checkbox'},
               {label: 'Case Number', fieldName: 'CaseNumber', type: 'Text'},
             {label: 'Subject', fieldName: 'Subject', type: 'Text'},
               {label: 'Type', fieldName: 'Type', type: 'Text'},
               {label: 'Priority', fieldName: 'Priority', type: 'Text'},
               {label: 'Status', fieldName: 'Status', type: 'Text'}
         ]);
        
		helper.getOriginalCaseDetails(component);
		document.title = 'New Sub Case';
        var caseId = component.get('v.caseId');
        helper.getRelatedCases(component);
        
	},
	cancel: function(component, event, helper)
	{
		var caseId = component.get('v.caseId');
		uJS.closeTab(caseId);
	},
    
    save: function(component, event, helper)
	{
        console.log('in save function');
		var isFormValid = helper.validateRequiredFields(component);
		
		component.set('v.showSpinner', true);
		var cells = component.find('cell');
        var selectedCases2 = component.get('v.selectedCases');
        var myJSON2 = JSON.stringify(selectedCases2);        
        var jsonObj = JSON.parse(myJSON2);
        var getCaseIds = [];
        for(var i = 0; i < jsonObj.length; i++)
        {

            getCaseIds.push(jsonObj[i]['Id']);

        }
        
        var caseAttachmentsComponent = component.find('caseAttachments');
		var selectedAttachmentsIds = '';
		if ( caseAttachmentsComponent !== undefined )
		{
			var selectedCaseAttachments = caseAttachmentsComponent.get('v.selectedAttachmentsIds');
            selectedAttachmentsIds = selectedCaseAttachments.join();
		}
        var caseId = component.get('v.caseId');
        

        if(getCaseIds.length === 0 || selectedAttachmentsIds === '' ||  selectedAttachmentsIds.length === 0 ){

            alert('Please select at least one attachment and one case');
            var spinner = component.set('v.showSpinner',false);
        }else{
            helper.cloneAttachmentToSubcase(component,getCaseIds,selectedAttachmentsIds);
        }
		
		
	}
})
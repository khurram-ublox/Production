({
	init: function(component, event, helper)
	{
		helper.getOriginalCaseDetails(component);
		helper.getCurrentUser(component);
		helper.getOriginalCaseRecordType(component);
		document.title = 'New Sub Case';
	},
	cancel: function(component, event, helper)
	{
		var caseId = component.get('v.caseId');
		uJS.closeTab(caseId);
	},
	save: function(component, event, helper)
	{
		var isFormValid = helper.validateRequiredFields(component);
		if ( !isFormValid )
		{
			return;
		}
		component.set('v.showSpinner', true);
		var cells = component.find('cell');
		var newCase = component.get('v.newCase');
		var currentUser = component.get('v.currentUser');
		cells.forEach(function(cell)
		{
			newCase[cell.get('v.apiName')] = cell.get('v.value');
		});

		newCase.OwnerId = currentUser.Id;
		console.log('newCase', newCase);
		
		var caseAttachmentsComponent = component.find('caseAttachments');
		var selectedAttachmentsIds = '';
		if ( caseAttachmentsComponent !== undefined )
		{
			var selectedCaseAttachments = caseAttachmentsComponent.get('v.selectedAttachmentsIds');
			selectedAttachmentsIds = selectedCaseAttachments.join();
		}
		var caseId = component.get('v.caseId');
		helper.createNewSubCase(component, caseId, newCase, selectedAttachmentsIds);
	}
})
({
	init: function(component, event, helper)
	{
		helper.getOriginalCaseDetails(component);
		helper.getCurrentUser(component);
		document.title = 'Split Case';
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
		var newCase = component.get('v.originalCase');
		var currentUser = component.get('v.currentUser');
		cells.forEach(function(cell)
		{
			newCase[cell.get('v.apiName')] = cell.get('v.value');
		});

		newCase.OwnerId = currentUser.Id;
		console.log('newCase', newCase);

		var caseCommentsComponent = component.find('caseComments');
		var selectedCommentsIds = '';
		if ( caseCommentsComponent !== undefined )
		{
			var selectedCaseComments = caseCommentsComponent.get('v.selectedCommentsIds');
			selectedCommentsIds = selectedCaseComments.join();
		}

		var caseEmailsComponent = component.find('caseEmails');
		var selectedEmailsIds = '';
		if ( caseEmailsComponent !== undefined )
		{
			var selectedCaseEmails = caseEmailsComponent.get('v.selectedEmailsIds');
			selectedEmailsIds = selectedCaseEmails.join();
		}
		
		var caseAttachmentsComponent = component.find('caseAttachments');
		var selectedAttachmentsIds = '';
		if ( caseAttachmentsComponent !== undefined )
		{
			var selectedCaseAttachments = caseAttachmentsComponent.get('v.selectedAttachmentsIds');
			selectedAttachmentsIds = selectedCaseAttachments.join();
		}
		var caseId = component.get('v.caseId');
		helper.createSplitCase(component, caseId, newCase, selectedCommentsIds, selectedEmailsIds, selectedAttachmentsIds);
	},

	cancel: function(component, event, helper)
	{
		var caseId = component.get('v.caseId');
        uJS.closeTab(caseId);
	}


})
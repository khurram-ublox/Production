({
	getOriginalCaseDetails: function(component)
	{
		var selectedCaseId = component.get('v.caseId');
		var getCaseDetailsAction = component.get('c.getOriginalCase');
		getCaseDetailsAction.setParams(
		{
			caseId:	selectedCaseId
		});
		getCaseDetailsAction.setCallback(this, function(response)
		{
			if ( component.isValid() && response.getState() == 'SUCCESS' )
			{
				var caseDetails = response.getReturnValue();
				console.log('case:', caseDetails);
				component.set('v.originalCase', caseDetails);
				component.set('v.showSpinner', false);
			}
			else
			{
				console.error('Error:', response.getError()[0].message);
			}
		});
		$A.enqueueAction(getCaseDetailsAction);
	},

	getCurrentUser: function(component)
	{
		var getCurrentUserAction = component.get('c.getCurrentUser');
		getCurrentUserAction.setCallback(this, function(response)
		{
			if ( component.isValid() && response.getState() == 'SUCCESS' )
			{
				component.set('v.currentUser', response.getReturnValue());
			}
			else
			{
				console.error('Error:', response.getError()[0].message);
			}
		});
		$A.enqueueAction(getCurrentUserAction);
	},

	validateRequiredFields: function(component)
	{
		var requiredFields = component.find('cell');
		var isFormValid = true;
		requiredFields.forEach(function(field){
			if ( field.get('v.required') && ($A.util.isUndefinedOrNull(field.get('v.value')) || field.get('v.value').trim().length == 0) )
			{
				field.set('v.hasError', true);
				isFormValid = false;
			}
		});
		return isFormValid;
	},

	createSplitCase: function(component, originalCaseId, newCase, selectedCommentsIds, selectedEmailsIds, selectedAttachmentsIds)
	{
		console.log('send to backend');
		var splitCaseAction = component.get('c.splitCase');
		splitCaseAction.setParams
		({
			originalCaseId: originalCaseId,
			newCase: newCase,
			selectedCommentsIds: selectedCommentsIds,
			selectedEmailsIds: selectedEmailsIds,
			selectedAttachmentsIds: selectedAttachmentsIds
		});
		splitCaseAction.setCallback(this, function(response)
		{
			if ( component.isValid() && response.getState() == 'SUCCESS' )
			{
				var createdCaseId = response.getReturnValue();
				uJS.openAndRefreshTab(createdCaseId);
			}
			else
			{
				console.error('Error:', response.getError()[0].message);
			}
		});
		$A.enqueueAction(splitCaseAction);
	}

})
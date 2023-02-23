({
	getOriginalCaseDetails: function(component)
	{
        console.log(sforce.console.isInConsole());
		var selectedCaseId = component.get('v.caseId');
		var getCaseDetailsAction = component.get('c.getOriginalCaseForNewSubCase');
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
				component.set('v.newCase', caseDetails);
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
	getOriginalCaseRecordType: function(component) {
		var getOriginalCaseRecordTypeAction = component.get('c.getOriginalCaseRecordType');
		var selectedCaseId = component.get('v.caseId');
		getOriginalCaseRecordTypeAction.setParams(
		{
			caseId:	selectedCaseId
		});
		getOriginalCaseRecordTypeAction.setCallback(this, function(response)
		{
			if ( component.isValid() && response.getState() == 'SUCCESS' )
			{
				component.set('v.currentRecordType', response.getReturnValue());
			}
			else
			{
				console.error('Error:', response.getError()[0].message);
			}
		});
		$A.enqueueAction(getOriginalCaseRecordTypeAction);
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
	createNewSubCase: function(component, originalCaseId, newCase, selectedAttachmentsIds)
	{
		console.log('send to backend');
		var newSubCaseAction = component.get('c.newSubCase');
		newSubCaseAction.setParams
		({
			originalCaseId: originalCaseId,
			newCase: newCase,
			selectedAttachmentsIds: selectedAttachmentsIds
		});
		newSubCaseAction.setCallback(this, function(response)
		{
			if ( component.isValid() && response.getState() == 'SUCCESS' )
			{
				var createdCaseId = response.getReturnValue();
                uJS.openAndRefreshTab(createdCaseId,'subtab');

			}
			else
			{
				console.error('Error:', response.getError()[0].message);
			}
		});
		$A.enqueueAction(newSubCaseAction);
	}
    
})
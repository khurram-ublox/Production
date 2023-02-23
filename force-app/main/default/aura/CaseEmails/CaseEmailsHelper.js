({
	loadCaseEmails: function(component)
	{
		var originalCaseId = component.get('v.originalCaseId');
		var getCaseEmailsAction = component.get('c.getCaseEmails');
		getCaseEmailsAction.setParams(
		{
			caseId: originalCaseId
		});
		getCaseEmailsAction.setCallback(this, function(response)
		{
			if ( component.isValid() && response.getState() == 'SUCCESS' )
			{
				var caseEmails = response.getReturnValue();
				var caseEmailsWrapped = [];
				component.set('v.caseEmails', caseEmails);
				var selectedEmailsIds = component.get('v.selectedEmailsIds');
				caseEmails.forEach(function(email, index)
				{
					var caseEmailWrapper = JSON.parse(JSON.stringify(email));
					caseEmailWrapper.selected = false;
					if ( index === 0 )
					{
						caseEmailWrapper.selected = true;
						selectedEmailsIds.push(email.Id);
						component.set('v.selectedEmailsIds', selectedEmailsIds);
					}
					caseEmailsWrapped.push(caseEmailWrapper);
				});
				component.set('v.caseEmailsWrapped', caseEmailsWrapped);
			}
			else
			{
				console.error('Error:', response.getError()[0].message);
			}
		});
		$A.enqueueAction(getCaseEmailsAction);
	}
})
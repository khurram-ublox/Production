({
	loadCaseAttachments: function(component)
	{
		var originalCaseId = component.get('v.originalCaseId');
		var getCaseAttachmentsAction = component.get('c.getCaseAttachments');
		getCaseAttachmentsAction.setParams(
		{
			caseId: originalCaseId
		});
		getCaseAttachmentsAction.setCallback(this, function(response)
		{
			if ( component.isValid() && response.getState() == 'SUCCESS' )
			{
				var caseAttachments = response.getReturnValue();
				var caseAttachmentsWrapped = [];
				component.set('v.caseAttachments', caseAttachments);
				var selectedAttachmentsIds = component.get('v.selectedAttachmentsIds');
				caseAttachments.forEach(function(attachment)
				{
					var caseAttachmentWrapper = JSON.parse(JSON.stringify(attachment));
					caseAttachmentWrapper.selected = false;
					caseAttachmentsWrapped.push(caseAttachmentWrapper);
				});
				component.set('v.caseAttachmentsWrapped', caseAttachmentsWrapped);
			} 
		});
		$A.enqueueAction(getCaseAttachmentsAction);
	},

	loadCaseEmailAttachments: function(component)
	{
		var originalCaseId = component.get('v.originalCaseId');
		var getCaseEmailAttachmentsAction = component.get('c.getCaseEmailAttachments');
		getCaseEmailAttachmentsAction.setParams(
		{
			caseId: originalCaseId
		});
		getCaseEmailAttachmentsAction.setCallback(this, function(response)
		{
			if ( component.isValid() && response.getState() == 'SUCCESS' )
			{
				var caseAttachments = response.getReturnValue();
				var caseAttachmentsWrapped = [];
				component.set('v.caseAttachments', caseAttachments);
				var selectedAttachmentsIds = component.get('v.selectedAttachmentsIds');
				caseAttachments.forEach(function(attachment)
				{
					var caseAttachmentWrapper = JSON.parse(JSON.stringify(attachment));
					caseAttachmentWrapper.selected = false;
					caseAttachmentsWrapped.push(caseAttachmentWrapper);
				});
				component.set('v.caseAttachmentsWrapped', caseAttachmentsWrapped);
			} 
		});
		$A.enqueueAction(getCaseEmailAttachmentsAction);
	},
})
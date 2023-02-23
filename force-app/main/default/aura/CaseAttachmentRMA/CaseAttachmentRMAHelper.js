({
    loadRMAattachments: function(component)
	{
		var originalCaseId = component.get('v.RMAId');
		var getCaseEmailAttachmentsAction = component.get('c.getRMAattachments');
		getCaseEmailAttachmentsAction.setParams(
		{
			RMAId: originalCaseId
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
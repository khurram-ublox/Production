({
	loadCaseComments: function(component)
	{
		var originalCaseId = component.get('v.originalCaseId');
		var getCaseCommentsAction = component.get('c.getCaseComments');
		getCaseCommentsAction.setParams(
		{
			caseId: originalCaseId
		});
		getCaseCommentsAction.setCallback(this, function(response)
		{
			if ( component.isValid() && response.getState() == 'SUCCESS' )
			{
				var caseComments = response.getReturnValue();
				console.log('caseComments', caseComments);
				var caseCommentsWrapped = [];
				component.set('v.caseComments', caseComments);
				caseComments.forEach(function(comment)
				{
					var caseCommentWrapper = JSON.parse(JSON.stringify(comment));
					caseCommentWrapper.selected = false;
					caseCommentsWrapped.push(caseCommentWrapper);
				});
				console.log('caseCommentsWrapped', caseCommentsWrapped);
				component.set('v.caseCommentsWrapped', caseCommentsWrapped);
			}
		});
		$A.enqueueAction(getCaseCommentsAction);
	}
})
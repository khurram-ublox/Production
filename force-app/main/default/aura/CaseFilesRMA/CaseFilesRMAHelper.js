({
	loadRMAfiles: function(component)
	{
		var originalCaseId = component.get('v.RMAId');
		var getRMAfilesAction = component.get('c.getRMAfiles');
		getRMAfilesAction.setParams(
		{
			RMAId: originalCaseId
		});
		getRMAfilesAction.setCallback(this, function(response)
		{
			if ( component.isValid() && response.getState() == 'SUCCESS' )
			{
				var caseFiles = response.getReturnValue();
				var caseFilesWrapped = [];
				component.set('v.caseFiles', caseFiles);
				var selectedAttachmentsIds = component.get('v.selectedFilesIds');
				caseFiles.forEach(function(files)
				{
					var caseFilesWrapper = JSON.parse(JSON.stringify(files));
					caseFilesWrapper.selected = false;
					caseFilesWrapped.push(caseFilesWrapper);
				});
				component.set('v.caseFilesWrapped', caseFilesWrapped);
			}
		});
		$A.enqueueAction(getRMAfilesAction);
	},


})
({
	loadCaseAttachments: function(component, event, helper)
	{   
        if (component.get('v.fromRMA')) {
			helper.loadRMAattachments(component);
		}
        
	},

	onSelect: function(component, event, helper)
	{
		var selectedAttachmentIds = component.get('v.selectedAttachmentsIds');
		var checkbox = event.target;
		var attachmentIdIndex = selectedAttachmentIds.indexOf(checkbox.id);
		if ( checkbox.checked && attachmentIdIndex == -1 )
		{
			selectedAttachmentIds.push(checkbox.id);
			component.set('v.selectedAttachmentsIds', selectedAttachmentIds);
		}
		else if ( !checkbox.checked && attachmentIdIndex != -1 )
		{
			selectedAttachmentIds.splice(attachmentIdIndex, 1);
			component.set('v.selectedAttachmentsIds', selectedAttachmentIds);
		}
	},
	openCreater: function(component, event, helper)
	{	
		if(!sforce.console.isInConsole())
	    {
	        window.parent.location.replace('/' + event.target.getAttribute('data-accId'));
	    }
	    else
	    {
			console.log(event.target.getAttribute('data-accId'));
	        sforce.console.getEnclosingPrimaryTabId(function(result)
	        {
	        	console.log('result.id : ' + result.id);
	        	sforce.console.closeTab(result.id);
	        	sforce.console.openPrimaryTab(null, '/' + event.target.getAttribute('data-accId') + '?isdtp=vw', true, event.target.getAttribute('data-accName'));
	        });
	    }
	}
})
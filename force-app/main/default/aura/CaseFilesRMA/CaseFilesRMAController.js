({
	loadCaseFiles: function(component, event, helper)
	{   
        if (component.get('v.fromRMA')) {
			helper.loadRMAfiles(component);
		}
        
	},

	onSelect: function(component, event, helper)
	{
		var selectedFilesIds = component.get('v.selectedFileIds');
		var checkbox = event.target;
		var filesIdIndex = selectedFilesIds.indexOf(checkbox.id);
		if ( checkbox.checked && filesIdIndex == -1 )
		{
			selectedFilesIds.push(checkbox.id);
			component.set('v.selectedFileIds', selectedFilesIds);
		}
		else if ( !checkbox.checked && filesIdIndex != -1 )
		{
			selectedFilesIds.splice(filesIdIndex, 1);
			component.set('v.selectedFileIds', selectedFilesIds);
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
({
	loadCaseComments: function(component, event, helper)
	{
		helper.loadCaseComments(component);
	},

	onSelect: function(component, event, helper)
	{
		var selectedCommentsIds = component.get('v.selectedCommentsIds');
		var checkbox = event.target;
		var commentIdIndex = selectedCommentsIds.indexOf(checkbox.id);
		if ( checkbox.checked && commentIdIndex == -1 )
		{
			selectedCommentsIds.push(checkbox.id);
			component.set('v.selectedCommentsIds', selectedCommentsIds);
		}
		else if ( !checkbox.checked && commentIdIndex != -1 )
		{
			selectedCommentsIds.splice(commentIdIndex, 1);
			component.set('v.selectedCommentsIds', selectedCommentsIds);
		}
		console.log('selectedCommentsIds', selectedCommentsIds);
	}
})
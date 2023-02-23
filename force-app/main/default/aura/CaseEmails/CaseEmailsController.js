({
	loadCaseEmails: function(component, event, helper)
	{
		helper.loadCaseEmails(component);
	},

	onSelect: function(component, event, helper)
	{
		var selectedEmailIds = component.get('v.selectedEmailsIds');
		var checkbox = event.target;
		var emailIdIndex = selectedEmailIds.indexOf(checkbox.id);
		if ( checkbox.checked && emailIdIndex == -1 )
		{
			selectedEmailIds.push(checkbox.id);
			component.set('v.selectedEmailsIds', selectedEmailIds);
		}
		else if ( !checkbox.checked && emailIdIndex != -1 )
		{
			selectedEmailIds.splice(emailIdIndex, 1);
			component.set('v.selectedEmailsIds', selectedEmailIds);
		}
	}
})
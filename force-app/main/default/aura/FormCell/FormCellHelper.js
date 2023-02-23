({
	initLookupComponent: function(component, objectName, value)
	{
		var getRecordDetailsAction = component.get('c.getRecordDetails');
		getRecordDetailsAction.setParams(
		{
			objectId: value
		});
		getRecordDetailsAction.setCallback(this, function(response)
		{
			if ( component.isValid() && response.getState() == 'SUCCESS' )
			{
				var recordDetails = response.getReturnValue();
				var lookupComponent = component.find('field');
				if ( lookupComponent !== undefined )
				{
					lookupComponent.set('v.searchString', recordDetails.name);
				}
			}
			else
			{
				console.error('Error', response.getError()[0].message);
			}
		});
		if ( !$A.util.isUndefinedOrNull(value) && value.trim().length > 0 )
		{
			$A.enqueueAction(getRecordDetailsAction);
		}
	}
})
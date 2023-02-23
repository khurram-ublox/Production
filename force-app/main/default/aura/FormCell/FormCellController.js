({
	init: function(component, event, helper)
	{
		var type = component.get('v.type');
		if ( type == 'picklist' )
		{
			var apiName = component.get("v.apiName");
			var getPicklistValuesAction = component.get("c.getPicklistValues");
			getPicklistValuesAction.setParams(
			{
				fieldName: apiName
			});
			getPicklistValuesAction.setCallback(this, function(response) {
				if (component.isValid() && response.getState() === "SUCCESS") {
					component.set('v.options', response.getReturnValue());
				}
			});
			$A.enqueueAction(getPicklistValuesAction);
		}
	},

	updateInnerComponents: function(component, event, helper)
	{
		var type = component.get('v.type');
		if ( type == 'lookup' )
		{
			var objectName = component.get('v.lookupType');
			var value = component.get('v.value');
			helper.initLookupComponent(component, objectName, value);
		}
	},

	onKeyUp: function(component, event, helper)
	{
		var updatedElement = event.target;
		component.set('v.value', updatedElement.value);
		if ( updatedElement.value.trim() != '' && !$A.util.isUndefinedOrNull(updatedElement.value) )
		{
			component.set('v.hasError', false);
		}
	},

	onUpdateLookup: function(component, event, helper)
	{
		var instanceId = event.getParam('instanceId');
		var sObjectId = event.getParam('sObjectId');
		var apiName = component.get('v.apiName');
		if ( apiName == instanceId )
		{
			component.set('v.value', sObjectId);
		}
	},

	onClearLookup: function(component, event, helper)
	{
		var instanceId = event.getParam('instanceId');
		var apiName = component.get('v.apiName');
		if ( apiName == instanceId )
		{
			component.set('v.value', null);
		}
	}

})
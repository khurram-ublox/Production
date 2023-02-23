({
	showHideSpinner: function(component, event, helper)
	{
		var spinner = component.find('spinner');
		var showSpinner = component.get('v.show');
		if ( showSpinner )
		{
			$A.util.removeClass(spinner, 'slds-hide');
			$A.util.addClass(spinner, 'slds-show');
		}
		else
		{
			$A.util.removeClass(spinner, 'slds-show');
			$A.util.addClass(spinner, 'slds-hide');
		}
	}
})
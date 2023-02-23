({
	saveState: function(cmp, event, helper) {
		//var auraId = cmp.get('v.id');
		//console.log(auraId);
		var checkbox = cmp.find('checkbox');
		var isChecked = checkbox.get('v.HTMLAttributes.checked');
		cmp.set('v.checked', !isChecked);
	}

})
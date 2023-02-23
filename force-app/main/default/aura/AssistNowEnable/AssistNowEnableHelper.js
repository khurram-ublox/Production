({
	cloneId : function(concId) {
		var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
              "recordId": concId     
            });
         navEvt.fire();  
	},
    showMessage: function(type,text) {
        var params = {
            'title': 'Info',
            'type': 'info',
            'mode': 'dismissible',
            'message': text
        }
        if(type=='error') {
            params.title = 'Error';
            params.type = 'error';
        }
        else if(type=='success') {
            params.title = 'Success';
            params.type = 'success';
        }

        $A.get('e.force:showToast').setParams(params).fire();
    }
})
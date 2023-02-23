({
    refresh : function(component, event, helper) {
    	$A.get('e.force:refreshView').fire();
        helper.closeModal(component,event,helper); 
	},
    openRecord: function(component, oId) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(isConsole) {
            console.log(isConsole);
            if (isConsole) {
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                    workspaceAPI.openSubtab({
                        parentTabId: response.tabId,
                        url: '/lightning/r/Opportunity/'+oId+'/view',
                        focus: true
                    }).then(function(subtabId) {
                        console.log("The new subtab ID is:" + subtabId);
                    }).catch(function(error) {
                        console.log(error);
                    });
                });
            } else {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": oId,
                    "slideDevName": "related"
                });
                navEvt.fire();
            }
        });
    },
    closeModal : function(component, event) {
        component.set("v.loading", "false" ); 
    	$A.get("e.force:closeQuickAction").fire();
    },
    showError : function(component, text) {
        component.set("v.errorMessage", text);
        var errorDiv = component.find("errorDiv");
        $A.util.removeClass(errorDiv, "slds-hide");
        component.set("v.loading", "false" );
    },
    hideError : function(component) {
        var errorDiv = component.find("errorDiv");
    	$A.util.addClass(errorDiv, "slds-hide");
        component.set("v.loading", "false" );
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
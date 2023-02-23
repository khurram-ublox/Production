({
    
    cloneAttachmentToSubcase: function(component,caseId,selectedAttachmentsIds){
        var caseIds =caseId.join();
        var getCaseDetailsAction = component.get('c.saveAttachmentsToSubCase');
        getCaseDetailsAction.setParams(
            {
                caseId:	caseIds,
                selectedAttachmentsId: selectedAttachmentsIds
            });
        getCaseDetailsAction.setCallback(this, function(response)
                                         {
                                             if ( component.isValid() && response.getState() == 'SUCCESS' )
                                             {
                                                 var caseDetails = response.getReturnValue();
                                                 console.log('case:', caseDetails);
                                                 var caseId = component.get('v.caseId');
                                                 uJS.closeTab(caseId);
                                             }
                                             else
                                             {
                                                 console.error('Error:', response.getError()[0].message);
                                             }
                                         });
        $A.enqueueAction(getCaseDetailsAction);
    },
    
    getRelatedCases: function(component){
        
        var selectedCaseId = component.get('v.caseId');
        var getCaseDetailsAction = component.get('c.getRelatedCases');
        getCaseDetailsAction.setParams(
            {
                caseId:	selectedCaseId
            });
        getCaseDetailsAction.setCallback(this, function(response)
                                         {
                                             if ( component.isValid() && response.getState() == 'SUCCESS' )
                                             {
                                                 var caseDetails = response.getReturnValue();
                                                 console.log('case:', caseDetails);
                                                 component.set('v.relatedCases', caseDetails);
                                             }
                                             else
                                             {
                                                 console.error('Error:', response.getError()[0].message);
                                             }
                                         });
        $A.enqueueAction(getCaseDetailsAction);
    },
    getOriginalCaseDetails: function(component)
    {
        console.log(sforce.console.isInConsole());
        var selectedCaseId = component.get('v.caseId');
        var getCaseDetailsAction = component.get('c.getOriginalCaseForNewSubCase');
        getCaseDetailsAction.setParams(
            {
                caseId:	selectedCaseId
            });
        getCaseDetailsAction.setCallback(this, function(response)
                                         {
                                             if ( component.isValid() && response.getState() == 'SUCCESS' )
                                             {
                                                 var caseDetails = response.getReturnValue();
                                                 console.log('case:', caseDetails);
                                                 component.set('v.originalCase', caseDetails);
                                                 component.set('v.showSpinner', false);
                                             }
                                             else
                                             {
                                                 console.error('Error:', response.getError()[0].message);
                                             }
                                         });
        $A.enqueueAction(getCaseDetailsAction);
    },
    validateRequiredFields: function(component)
    {
        var requiredFields = component.find('cell');
        var isFormValid = true;
        requiredFields.forEach(function(field){
            if ( field.get('v.required') && ($A.util.isUndefinedOrNull(field.get('v.value')) || field.get('v.value').trim().length == 0) )
            {
                field.set('v.hasError', true);
                isFormValid = false;
            }
        });
        return isFormValid;
    }
})
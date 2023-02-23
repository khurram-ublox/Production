({
    
    
    cloneAttachmentToRMAcase: function(component,caseId,selectedAttachmentsIds){
        var caseIds =caseId;
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
                                                 var RMAId = component.get('v.RMAId');
                                                 uJS.closeTab(RMAId);
                                             }
                                             else
                                             {
                                                 console.error('Error:', response.getError()[0].message);
                                             }
                                         });
        $A.enqueueAction(getCaseDetailsAction,false);
    },
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
    getOriginalCaseDetails: function(component)
    {
        var selectedCaseId = component.get('v.RMAcaseId');
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
    cloneFileToRMAcase: function(component,caseId,selectedFilesIds){
        var caseIds =caseId;
        var fileIds = selectedFilesIds;
        var getCaseDetailsAction = component.get('c.saveFilesToSubCase');
        debugger;
        getCaseDetailsAction.setParams(
            {
                caseId:	caseIds,
                selectedFileIds: fileIds
            });
        getCaseDetailsAction.setCallback(this, function(response)
                                         {
                                             if ( component.isValid() && response.getState() == 'SUCCESS' )
                                             {
                                                 var caseDetails = response.getReturnValue();
                                                 var RMAId = component.get('v.RMAId');
                                                 uJS.closeTab(RMAId);
                                             }
                                             else
                                             {
                                                 console.error('Error:', response.getError()[0].message);
                                             }
                                         });
        $A.enqueueAction(getCaseDetailsAction,false);
    },
})
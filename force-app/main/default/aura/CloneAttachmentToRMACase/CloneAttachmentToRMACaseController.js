({
    
    init: function(component, event, helper)
    {
        helper.getOriginalCaseDetails(component);
        document.title = 'Clone Attachment to Case';
        component.set('v.mycolumn', [
            {label: 'Select', fieldName: 'Select', type: 'checkbox'},
            {label: 'Case Number', fieldName: 'CaseNumber', type: 'Text'},
            {label: 'Subject', fieldName: 'Subject', type: 'Text'}
        ]);
    },
    cancel: function(component, event, helper)
    {
        var RMAId = component.get('v.RMAId');
        uJS.closeTab(RMAId);
    },
    save: function(component, event, helper)
    {
        component.set('v.showSpinner', true);
        var cells = component.find('cell');
        var RMACaseId = component.get('v.RMAcaseId');
        var caseAttachmentsComponent = component.find('caseAttachmentRMA');
        var caseFileComponent = component.find('caseFilesRMA');
        console.log(caseFileComponent);
        var selectedAttachmentsIds = '';
        var selectedFilesIds = '';
        if ( caseAttachmentsComponent !== undefined || caseFileComponent !== undefined)
        {
            var selectedCaseAttachments = caseAttachmentsComponent.get('v.selectedAttachmentsIds');
            selectedAttachmentsIds = selectedCaseAttachments.join();
            var selectedCaseFiles = caseFileComponent.get('v.selectedFileIds');
            selectedFilesIds = selectedCaseFiles.join();
        }
        
        if((selectedAttachmentsIds === '' || selectedAttachmentsIds.length === 0) && 
        (selectedFilesIds === '' || selectedFilesIds.length === 0 )){
            alert('please select at least one attachment');
            var spinner = component.set('v.showSpinner',false);
        }else{
            if(selectedAttachmentsIds !== '' || selectedAttachmentsIds.length !== 0){
            helper.cloneAttachmentToRMAcase(component,RMACaseId,selectedAttachmentsIds);
            }
            if(selectedFilesIds !== '' || selectedFilesIds.length !== 0){
                helper.cloneFileToRMAcase(component,RMACaseId,selectedFilesIds);
            }
        }
    }
})
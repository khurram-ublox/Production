({
    toggleSection : function(component, event, helper) {
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.currentTarget.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
        */
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }
    },
    // common reusable function for toggle sections
    toggleSection2 : function(component, event, helper) {
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
        */
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }
    },
    doInit : function(component, event, helper) {
        window.addEventListener("keydown", function(event) {
            var kcode = event.code;
            if(kcode == 'Escape'){
                helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
                helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
                helper.hidePopupHelper(component, 'modaldialogdelete', 'slds-fade-in-');
            }
        }, true);
        helper.getComments(component,event,helper);
        helper.getLoggedUserId(component);
        helper.getLoggedUserType(component);
    },
    post : function(component, event, helper) {
        var comment = component.find("message").get("v.value");
        var commentType = component.get("v.commentType");
        var feedInternalId = component.get("v.feedInternalId"); 
        var feedCustomerId = component.get("v.feedCustomerId");
        var fileContentVersionId = component.get("v.fileContentVersionId")
        var fileContentDocumentId = component.get("v.fileContentDocumentId")
        //partnerPortal
        var feedPartnerId = component.get("v.feedPartnerId"); 
        var userType = component.get("v.userType");
        var userid = component.get("v.userId");
        var feedIdType;
        if(commentType === 'internal'){feedIdType = feedInternalId};
        if(commentType === 'partner'){feedIdType = feedPartnerId};
        if(commentType === 'customer'){feedIdType = feedCustomerId};
        var fileData = '';
        if(component.get("v.fileDataJSON")) fileData = component.get("v.fileDataJSON");

        if(helper.stringIsEmpty(comment,helper)) {
            helper.showMessage('error','Sorry, message can\'t be empty.');
            return;
        }
        
        $A.util.removeClass(component.find("spinner"), "slds-hide"); 
        var action = component.get("c.postComment");
        var params = {
            "caseId": component.get("v.recordId"),
            "feedId": feedIdType,
            "comment": comment,
            "fileData": fileData,
            "commentType": commentType,
            "fileContentVersionId": fileContentVersionId,
            "fileContentDocumentId": fileContentDocumentId
        }
        //return;
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if(state === "SUCCESS"){
                var savedId = response.getReturnValue();
                if(savedId){
                    helper.showMessage('success','The message has been sent.');
                    component.set("v.isFileComponentDisabled", false);
                    component.set("v.fileContentDocumentId", "");
                    component.set("v.fileContentVersionId", "");
                    //helper.refreshFocusedTab(component);
                    $A.get('e.force:refreshView').fire();
                    
                }
            } 
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log(errors);
                    if (errors[0] && errors[0].pageErrors.length>0) {
                        helper.showMessage('error',errors[0].pageErrors[0].message);
                    }
                    else if (errors[0] && errors[0].fieldErrors.Quantity.length>0) {
                        helper.showMessage('error',errors[0].fieldErrors.Quantity[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                $A.util.addClass(component.find("spinner"), "slds-hide"); 
            }
            
        });
        $A.enqueueAction(action);
    },
    postCc : function(component, event, helper) {
        var comment = component.find("message_partner").get("v.value");
        var fileData = '';
        if(component.get("v.fileDataJSON")) fileData = component.get("v.fileDataJSON");
        
        if(helper.stringIsEmpty(comment,helper)) {
            helper.showMessage('error','Sorry, message can\'t be empty.');
            return;
        }
        
        $A.util.removeClass(component.find("spinner"), "slds-hide"); 
        var action = component.get("c.postCcCtrl");
        var params = {
            "caseId": component.get("v.recordId"),
            "comment": comment,
            "fileData": fileData
        }
        
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            
            if(state === "SUCCESS"){
                var savedId = response.getReturnValue();
                if(savedId){
                    helper.showMessage('success','The message has been sent.');
                    //helper.refreshFocusedTab(component);
                    $A.get('e.force:refreshView').fire();
                    
                }
            } 
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log(errors);
                    if (errors[0] && errors[0].pageErrors.length>0) {
                        helper.showMessage('error',errors[0].pageErrors[0].message);
                    }
                    else if (errors[0] && errors[0].fieldErrors.Quantity.length>0) {
                        helper.showMessage('error',errors[0].fieldErrors.Quantity[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                $A.util.addClass(component.find("spinner"), "slds-hide"); 
            }
            
        });
        $A.enqueueAction(action);
    },
    update : function(component, event, helper) {
        
        var commentType = component.get("v.comment_commentType");
        
        var comment = component.find("comment_body").get("v.value");
        if(commentType=='partner' ) comment = component.find("comment_body_partners").get("v.value");
        
        if(helper.stringIsEmpty(comment,helper)) {
            helper.showMessage('error','Sorry, message can\'t be empty.');
            return;
        }
        comment = comment.replace(/<a\/?[^>]+(>|$)|<\/a>/g, ' ');
        
        helper.hidePopupHelper(component, 'modaldialogdelete', 'slds-fade-in-');
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
        helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');

        $A.util.removeClass(component.find("spinner"), "slds-hide"); 
        var action = component.get("c.editComment");
        var params = {
            "commentId": component.get("v.comment_id"),
            "comment": comment,
            "commentType": commentType
        }
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            var isEdited = response.getReturnValue();
            
            if (state === "SUCCESS" && isEdited == true) {
                helper.showMessage('success','The message has been updated.');
                $A.get('e.force:refreshView').fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // log the error passed in to AuraHandledException
                        console.log("Error message: " + errors[0].message);
                        helper.showMessage('error', errors[0].message);
                    }
                } else {
                    helper.showMessage('error','Sorry, there was an error during the process.');
                }
            }
            
            $A.util.addClass(component.find("spinner"), "slds-hide");
            
        });
        $A.enqueueAction(action);
    },
    delete : function(component, event, helper) {
        helper.hidePopupHelper(component, 'modaldialogdelete', 'slds-fade-in-');
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
        helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
        
        $A.util.removeClass(component.find("spinner"), "slds-hide"); 
        var action = component.get("c.deleteComment");
        var params = {
            "commentId": component.get("v.comment_id"),
            "commentType": component.get("v.comment_commentType")
        }

     	action.setParams(params);
		action.setCallback(this, function (response) {
            var state = response.getState();
            var isEdited = response.getReturnValue();
            
            if(isEdited){
                helper.showMessage('success','The message has been removed.');
                $A.get('e.force:refreshView').fire();
                
            } else {                  
                helper.showMessage('error','Sorry, there was an error during the process.');
            }
        });
    	$A.enqueueAction(action);
    },
    toggleButton : function(component, event, helper) {
        var label = component.get("v.toggleIcon");
        if(label == 'fa fa-chevron-down') {
            component.set("v.toggleIcon","fa fa-chevron-right");
            $A.util.addClass(component.find("toggleArea"), "slds-hide");
        } else {
            component.set("v.toggleIcon","fa fa-chevron-down");
            $A.util.removeClass(component.find("toggleArea"), "slds-hide");
        }
    },
    openTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        var idx = event.target.id;
        
        workspaceAPI.openTab({
            url: '/one/one.app?#/sObject/' + idx,
            focus: true
        }).then(function(response) {
            // actions to do after opening tab if necessary
        }).catch(function(error) {
        });
    },
    handleUploadFinished: function (component, event, helper) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        component.set("v.fileContentVersionId", uploadedFiles[0].contentVersionId);
        component.set("v.fileContentDocumentId", uploadedFiles[0].documentId);
        // alert("Files uploaded : " + uploadedFiles.length);
        helper.showMessage('Success','Your file has been uploaded.');

        // let fileName = "";
        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
        uploadedFiles.forEach(function(file) {
            component.set("v.fileName", file.name);
            component.set("v.isFileComponentDisabled", true);
            $A.util.removeClass(component.find("remove_file_link"), "slds-hide");   
            $A.util.removeClass(component.find("remove_file_link_p"), "slds-hide");
        });
        
    },
    removeFile : function(component, event, helper) {

        var action = component.get("c.deleteDocument");
        var params = {
            "docId": component.get("v.fileContentDocumentId")
        }

     	action.setParams(params);
		action.setCallback(this, function (response) {
            var state = response.getState();
            var isDeleted = response.getReturnValue();
            
            if(isDeleted){
                let fileName = component.get("v.fileName");
                component.set("v.fileName", "");
                component.set("v.fileContentDocumentId", "");
                component.set("v.fileContentVersionId", "");
                component.set("v.isFileComponentDisabled", false);
                $A.util.addClass(component.find("remove_file_link"), "slds-hide");
                $A.util.addClass(component.find("remove_file_link_p"), "slds-hide");
                helper.showMessage('Success','Your File [ '+fileName+' ] is successfully deleted.');
                
            } else {
                helper.showMessage('error','Sorry, The file is not deleted and it is available in record attachments.');
            }
        });
    	$A.enqueueAction(action);
    },
        
    changeState : function changeState (component){ 
        component.set('v.isexpanded',!component.get('v.isexpanded'));
    },
    showForm : function(component, event, helper) {
        $A.util.addClass(component.find("text_input"), "slds-hide");
        $A.util.removeClass(component.find("text_textarea"), "slds-hide");
        setTimeout(function(){ 
            //component.find("message").getElement().focus();
        }, 100);
    },
    handleActiveTab: function (component, event) {
        var tab = event.getSource();
        var seltab = tab.get('v.id').substring(2);
        switch (seltab) {
            case 'customer':
                console.log("inside case feed cooment controller and case customer");
                $A.util.removeClass(component.find("post_comment"), "slds-hide");
                $A.util.addClass(component.find("post_comment_partner"), "slds-hide");
                
                //$A.util.addClass(component.find("to_two"), "slds-hide");
                //$A.util.removeClass(component.find("to_one"), "slds-hide");
                
                break;
            case 'internal':
                $A.util.removeClass(component.find("post_comment"), "slds-hide");
                $A.util.addClass(component.find("post_comment_partner"), "slds-hide");
                
                //$A.util.addClass(component.find("to_one"), "slds-hide");
                //$A.util.removeClass(component.find("to_two"), "slds-hide");
                
                break;
            case 'partner':
                $A.util.removeClass(component.find("post_comment"), "slds-hide");
                $A.util.addClass(component.find("post_comment_partner"), "slds-hide");
                
                break;
            case 'all':
                $A.util.addClass(component.find("post_comment"), "slds-hide");
                $A.util.addClass(component.find("post_comment_partner"), "slds-hide");
                
                break;
        }
        component.set("v.commentType",seltab);
        console.log(component.get("v.commentType"));
        component.find("tabs").set("v.selectedTabId",seltab);
        if(seltab=='partner'){
            if(component.get("v.userType").toLowerCase() == 'standard') {
                seltab = 'partner';
            } else {
                seltab = 'u-blox';
            }
        }
        component.find("send_button").set('v.label','Send to '+seltab);
        
    },
    handleClick: function (component, event, helper) {
        var selected = event.currentTarget.value;
        if(selected=='false') {
            component.find("tabs").set("v.selectedTabId","one");
        }
        else {
            component.find("tabs").set("v.selectedTabId","two");
        }
        return;
    },
    handleSelect: function(component, event, helper) {
        var str_value = event.getParam("value");
        var str_arr = str_value.split("_");
        if(str_arr[0]=='partner') {
            $A.util.addClass(component.find("comment_body"), "slds-hide");
            $A.util.removeClass(component.find("comment_body_partners"), "slds-hide");
        }
        else {
            $A.util.removeClass(component.find("comment_body"), "slds-hide");
            $A.util.addClass(component.find("comment_body_partners"), "slds-hide");                                    
        }
        
        switch (str_arr[1]) {
            case "edit": helper.showEditForm(component, str_arr[2], helper); break;
            case "delete": helper.showDeleteForm(component, str_arr[2], helper); break;
        }
    },
    hidePopup: function(component, event, helper){
        helper.hidePopupHelper(component, 'modaldialogdelete', 'slds-fade-in-');
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
        helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
    },
    listenforMentions : function(component, event, helper) {
        clearTimeout(window.timer);
        window.timer = setTimeout($A.getCallback(function(){
            var commentBody = component.get("v.textarea");
            var regex = new RegExp('@[a-z0-9_-]+', 'gi');
            /* Check if the comment has @handle & get the last used handle */
            if(regex.test(commentBody)){
                var handles = commentBody.match(regex);
                var querystring = handles[handles.length-1];
                component.set("v.queryString",querystring);
            }
        }),1000);
    },
    getuserhandles : function(component, event, helper) {
        var user_handle = component.get("v.queryString");
        var action = component.get("c.getMentionAutocomplete");
        action.setParams({
            "queryString" : user_handle.replace(/@/g, '') , 
            "contextId" : "5009E00000ABpsJQAT"
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state==="SUCCESS"){
                /* show menu */
                var menu = component.find("menu");
                $A.util.toggleClass(menu, 'slds-hide');
                
                var possible_mentions = response.getReturnValue().mentionCompletions;
                var predictions = new Array();
                for(var i=0; i< possible_mentions.length; i++){
                    predictions.push(possible_mentions[i].name);
                }
                if(predictions.length > 0){
                    var result = {
                        "needle" : user_handle,
                        "haystack" : predictions
                    };
                    component.set("v.results",result);
                }
            }
        });
        $A.enqueueAction(action);
    }, 
    search_replace : function(component, event, helper){
        var key = event.srcElement.dataset.key;
        var value = event.srcElement.dataset.value;
        var changed_comment = component.get("v.textarea").replace(key,'@['+value+']');
        component.set("v.textarea",changed_comment );
        /*hide menu*/
        var menu = component.find("menu");
        $A.util.toggleClass(menu, 'slds-hide');
    },
    previewFile :function(component,event,helper){
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.record;
        $A.get('e.lightning:openFiles').fire({
            recordIds: [recId]
        });
    }

})
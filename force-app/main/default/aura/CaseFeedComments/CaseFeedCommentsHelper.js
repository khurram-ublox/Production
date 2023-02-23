({
	getCase : function(component) {
		var action = component.get("c.getCase");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var c = response.getReturnValue();
            component.set("v.ca", c);
        });
        $A.enqueueAction(action);
	},
    getLoggedUserId : function(component) {
		var action = component.get("c.getUserId");
        action.setCallback(this, function (response) {
            var r = response.getReturnValue();
            component.set("v.userId", r);
        });
        $A.enqueueAction(action);
	},
    getLoggedUserType : function(component) {
		var action = component.get("c.getUserType");
        action.setCallback(this, function (response) {
            var r = response.getReturnValue();
            component.set("v.userType", r);
            if(r=='Standard') {
                var tabLabel = component.find("tab_partner").get("v.label");
                tabLabel[0].set("v.value", "Partner and Internal Users");
            }
        });
        $A.enqueueAction(action);
	},
    getComments : function(component, event, helper) {
        var action = component.get("c.getComments");
       
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var data = response.getReturnValue();
            data = JSON.parse(JSON.stringify(data));
            
			var comments_unsorted = [];
            var countItems = { 
                internal: 0,
                customer: 0,
                partner: 0
            }
            //component.set("v.jsObj", { aValue: 5 });
            
            var arr = [];
            var countItem = 0;
            if(data['customer']) {
                //data['customer'] = data['customer'].replace(/>/g,'&gt;').replace(/</g, '&lt;').replace(/(?:\r\n|\r|\n)/g, '<br>');
                let usersProfileMap = data['profilesCustomer'] ? new Map(JSON.parse(data['profilesCustomer']).items.map(i => [i.id, i.profileName])) : new Map();
                var feedUser = 'Customer';
                data['customer'] = JSON.parse(data['customer']);
                arr = data['customer'].items;
                Object.keys(arr).forEach(function(key) {
                    var richText = helper.bodyRichText(helper, arr[key]['body']['messageSegments']);                    
                    
                    if(arr[key]['user']['additionalLabel'] != null && arr[key]['user']['additionalLabel'] != 'Customer' && arr[key]['user']['additionalLabel'] != 'Partner'){
                        feedUser = 'Customer - '+arr[key]['user']['additionalLabel'];
                    }else if(arr[key]['user']['additionalLabel'] != null){
                        feedUser = arr[key]['user']['additionalLabel']; 
                    }
                    var arrPush = {
                        'Id' : arr[key]['id'],
                        //'Body' : arr[key]['body']['text'].replace(/(?:\r\n|\r|\n)/g, '<br>'),
                        'Body' : richText,
                        'CreatedTimestamp' : new Date(arr[key]['createdDate']).getTime(),
                        'CreatedDate' : new Date(arr[key]['createdDate']),
                        'CreatedById' : arr[key]['user']['id'],
                        'CreatedByName' : arr[key]['user']['displayName'],
                        'Type' : 'customer',
                        'UserType' : arr[key]['user']['userType'] == 'Internal' ? 'Internal': feedUser,
                        //'UserType' : arr[key]['user']['additionalLabel'] == null ? 'customer': arr[key]['user']['additionalLabel'].toLowerCase(),
                        'IsRichText' : arr[key]['body']['isRichText'],
                        'profileName' : arr[key]['user']['userType'] == 'Internal' ? usersProfileMap.get(arr[key]['user']['id']) : 'empty'
                    };
                    
                    if(arr[key]['capabilities']['content']) {
                        arrPush.fileId = arr[key]['capabilities']['content']['id'];
                        arrPush.fileDesc = arr[key]['capabilities']['content']['title'];
                    }
                    comments_unsorted.push(arrPush);
                    countItem++;
                }); 
                countItems.customer = countItem;
                component.set("v.feedCustomerId", data['customerId'] );
            }
            countItem=0;
            if(data['internal']) {
                //data['internal'] = data['internal'].replace(/>/g,'&gt;').replace(/</g, '&lt;').replace(/(?:\r\n|\r|\n)/g, '<br>');
                let usersProfileMap = data['profilesInternal'] ? new Map(JSON.parse(data['profilesInternal']).items.map(i => [i.id, i.profileName])) : new Map();
                //var usersProfileMap = new Map(JSON.parse(data['profilesInternal']).items.map(i => [i.id, i.profileName]));
                
                data['internal'] = JSON.parse(data['internal']);
                arr = data['internal'].items;

                Object.keys(arr).forEach(function(key) {
                    var richText = helper.bodyRichText(helper,arr[key]['body']['messageSegments']);
                    
                    var arrPush = {
                        'Id' : arr[key]['id'],
                        //'Body' : arr[key]['body']['text'].replace(/(?:\r\n|\r|\n)/g, '<br>'),
                        'Body' : richText,
                        'CreatedTimestamp' : new Date(arr[key]['createdDate']).getTime(),
                        'CreatedDate' : new Date(arr[key]['createdDate']),
                        'CreatedById' : arr[key]['user']['id'],
                        'CreatedByName' : arr[key]['user']['displayName'],
                        'Type' : 'internal',
                        'UserType' : arr[key]['user']['userType'] == 'Internal' ? 'Internal': arr[key]['user']['additionalLabel'] == null ? 'Internal': arr[key]['user']['additionalLabel'],
                        //'UserType' : arr[key]['user']['additionalLabel'] == null ? 'internal': arr[key]['user']['additionalLabel'].toLowerCase(),
                        'IsRichText' : arr[key]['body']['isRichText'],
                        'profileName' : usersProfileMap.get(arr[key]['user']['id'])
                    };
                    
                    if(arr[key]['capabilities']['content']) {
                        arrPush.fileId = arr[key]['capabilities']['content']['id'];
                        arrPush.fileDesc = arr[key]['capabilities']['content']['title'];
                    }
                    comments_unsorted.push(arrPush);
                    countItem++;
                }); 
                countItems.internal = countItem;
                component.set("v.feedInternalId", data['internalId'] );
            }
            var pcomments_unsorted = [];
			countItem=0;
            if(data['partner']) {
                
                let usersProfileMap = data['profilesPartner'] ? new Map(JSON.parse(data['profilesPartner']).items.map(i => [i.id, i.profileName])) : new Map();
                //var usersProfileMap = new Map(JSON.parse(data['profilesPartner']).items.map(i => [i.id, i.profileName]));
                
                data['partner'] = JSON.parse(data['partner']);
                arr = data['partner'].items;

				// data['partner'] = data['partner'].replace(/>/g,'&gt;').replace(/</g, '&lt;').replace(/(?:\r\n|\r|\n)/g, '<br>');
            

                Object.keys(arr).forEach(function(key) {
                    var richText = helper.bodyRichText(helper,arr[key]['body']['messageSegments']);
                                        
                    var arrPush = {
                        'Id' : arr[key]['id'],
                        //'Body' : arr[key]['body']['text'].replace(/(?:\r\n|\r|\n)/g, '<br>'),
                        'Body' : richText,
                        'CreatedTimestamp' : new Date(arr[key]['createdDate']).getTime(),
                        'CreatedDate' : new Date(arr[key]['createdDate']),
                        'CreatedById' : arr[key]['user']['id'],
                        'CreatedByName' : arr[key]['user']['displayName'],
                        'Type' : 'partner',
                        'UserType' : arr[key]['user']['userType'] == 'Internal' ? 'Internal': arr[key]['user']['additionalLabel'] == null ? 'Partner': arr[key]['user']['additionalLabel'],
                        //'UserType' : arr[key]['user']['additionalLabel'] == null ? 'partner': arr[key]['user']['additionalLabel'].toLowerCase(),
                        'IsRichText' : arr[key]['body']['isRichText'],
                        'profileName' : arr[key]['user']['userType'] == 'Internal' ? usersProfileMap.get(arr[key]['user']['id']) : 'empty'
                    };
                    
                    if(arr[key]['capabilities']['content']) {
                        arrPush.fileId = arr[key]['capabilities']['content']['id'];
                        arrPush.fileDesc = arr[key]['capabilities']['content']['title'];
                    }
                    comments_unsorted.push(arrPush);
                    countItem++;
                });  
                countItems.partner = countItem;
                component.set("v.feedPartnerId", data['partnerId'] );
            }

            if(data['powerPartner']) {

                data['powerPartner'] = JSON.parse(data['powerPartner']);
                arr = data['powerPartner'].items;

				// data['partner'] = data['partner'].replace(/>/g,'&gt;').replace(/</g, '&lt;').replace(/(?:\r\n|\r|\n)/g, '<br>');
            

                Object.keys(arr).forEach(function(key) {
                    
                    var arrPush = {
                            'Id' : arr[key]['id'],
                            'Body' : arr[key]['body'],
                            'CreatedTimestamp' : arr[key]['createdTimestamp'],
                            'CreatedDate' : arr[key]['createdDate'],
                            //'CreatedDate' : new Date(arr[key]['createdDate'].replace(" ","T").concat(".000Z")),
                            'CreatedById' : arr[key]['user']['id'],
                            'CreatedByName' : arr[key]['user']['displayName'],
                            'Type' : 'partner',
                            'UserType' : arr[key]['user']['userType'],
                            //'UserType' : arr[key]['user']['additionalLabel'] == null ? 'partner': arr[key]['user']['additionalLabel'].toLowerCase(),
                            'IsRichText' : arr[key]['isRichText'],
                            'profileName' : arr[key]['user']['profileName']
                    };
                    if(arr[key]['containFile']) {
                        arrPush.fileId = arr[key]['fileId'];
                        arrPush.fileDesc = arr[key]['fileDesc'];
                    }
                    comments_unsorted.push(arrPush);
                    countItem++;
                }); 
                countItems.partner = countItem;
                //added for partner portal
                component.set("v.feedPartnerId", data['powerPartnerId'] );
            }

            var comments = comments_unsorted.slice(0);
            comments.sort(function(a,b) {
                return b.CreatedTimestamp - a.CreatedTimestamp;
            });

            component.set("v.comments", comments);
            component.set("v.allcomments", comments);
            component.set("v.commentsCount", countItems);
            
            component.set("v.textarea","");
            component.set("v.textarea_partner","");
            component.set("v.fileDataJSON","");
            component.set("v.fileName","");
            component.set("v.toggleIcon","fa fa-chevron-right");
            
            
            $A.util.addClass(component.find("remove_file_link"), "slds-hide");
            $A.util.addClass(component.find("remove_file_link_p"), "slds-hide");
            $A.util.removeClass(component.find("text_textarea"), "slds-hide");
            $A.util.addClass(component.find("text_input"), "slds-hide");
            helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
            helper.hidePopupHelper(component, 'modaldialogdelete', 'slds-fade-in-');
            helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
            $A.util.addClass(component.find("spinner"), "slds-hide");
            
        });
        $A.enqueueAction(action);
    },
    showMessage: function(type,text) {
        var params = {
            'title': 'Info',
            'type': 'info',
            'mode': 'dismissible',
            'message': text
        }
        if(type.toLowerCase()=='error') {
            params.title = 'Error';
            params.type = 'error';
        }
        else if(type.toLowerCase()=='success') {
            params.title = 'Success';
            params.type = 'success';
        }
        
        $A.get('e.force:showToast').setParams(params).fire();
    },
    refreshFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.refreshTab({
                tabId: focusedTabId,
                includeAllSubtabs: false
            });
        })
        .catch(function(error) {
        });
    },
    showPopupHelper: function(component, componentId, className){
        var modal = component.find(componentId);
        $A.util.removeClass(modal, className + 'hide');
        $A.util.addClass(modal, className + 'open');
    },
    hidePopupHelper: function(component, componentId, className){
        var modal = component.find(componentId);
        $A.util.addClass(modal, className+'hide');
        $A.util.removeClass(modal, className+'open');
        component.set("v.body", "");
    },
    showEditForm: function(component, eventId, helper){
        var myObject = component.get("v.comments");
        var body = myObject[eventId]['Body'];
        
        component.find("comment_body").set("v.value",body);
        component.find("comment_body_partners").set("v.value",body);
        component.set("v.comment_id",myObject[eventId]['Id']);
        component.set("v.comment_commentType",myObject[eventId]['Type']);
        
        helper.showPopupHelper(component, 'modaldialog', 'slds-fade-in-');
        helper.showPopupHelper(component,'backdrop','slds-backdrop--');
    },
    showDeleteForm: function(component, eventId, helper){
        var myObject = component.get("v.comments");

        var shortMessage = helper.removeTags(myObject[eventId]['Body']);
        if(shortMessage.length>30) shortMessage = shortMessage.substring(0,30)+'...';
        
        component.set("v.comment_id",myObject[eventId]['Id']);
        component.set("v.comment_delete_data",'from '+myObject[eventId]['CreatedByName']+' ('+shortMessage+')');
        component.set("v.comment_commentType",myObject[eventId]['Type']);
        
        helper.showPopupHelper(component, 'modaldialogdelete', 'slds-fade-in-');
        helper.showPopupHelper(component,'backdrop','slds-backdrop--');
    },
    removeTags: function(string,type) {
        type = type || '';
        if(type == 'all') {
            string = string.replace(/<\/?[^>]+(>|$)/g, '');
            string = string.replace(/&nbsp;/g,' ');
            string = string.replace(/ /g,'');
            string = string.replace('\t','');
        }
        else {
            string = string.replace(/<\/?[^>]+(>|$)/g, ' ');
            string = string.replace('\t',' ');
            string = string.trim();
        }
        return string;
	},
    stringIsEmpty: function(string,helper) {
    	string = helper.removeTags(string, 'all');
        if(!string) {
            return true;
        }
        return false;
	},
    bodyRichText: function(helper, bodyArray) {
        var richText = '';
        var markupType = '';
        var isCode = 0;
        Object.keys(bodyArray).forEach(function(item) {
            markupType = bodyArray[item]['markupType'];
            switch (bodyArray[item]['type']) {
                case "MarkupBegin":
                    if(markupType == 'Hyperlink') {
                        richText += '<a href="' + bodyArray[item]['url'] + '" alt="' + bodyArray[item]['altText'] + '" target="_blank">';
                    }
                    else if(markupType == 'Code') {
                        richText += '<' + bodyArray[item]['htmlTag'] + '><ol class="linenums">';
                        isCode = 1;
                    }
                    else richText += '<' + bodyArray[item]['htmlTag'] + '>';
                    break;
                case "MarkupEnd":
                    if(markupType == 'Code') {
                        richText += '</ol>';
                        isCode = 0;
                    }
                    richText += '</' + bodyArray[item]['htmlTag'] + '>';
                    break;
                case "InlineImage":
                    //richText += '<lightning:fileCard fileId="' + bodyArray[item]['thumbnails']['fileId'] +  '" description="' + bodyArray[item]['altText'] + '" hideDescription="true" />';
                    richText += '<a href="' + bodyArray[item]['url'] +  '">' + bodyArray[item]['altText'] + '</a>';
                    break;
                case "Mention":
                    richText += '<a href="/lightning/r/User/' + bodyArray[item]['record']['id'] +  '/view">@' + bodyArray[item]['record']['name'] + '</a>';
                    break;
                default:
                    if (typeof bodyArray[item]['markupType'] == 'undefined' && bodyArray[item]['type'] == 'Text') {
                        
                        bodyArray[item]['text'] = bodyArray[item]['text'].replace(/&lt;/gm, '<');
                        bodyArray[item]['text'] = bodyArray[item]['text'].replace(/&gt;/gm, '>');
                    }
                    var text = '';
                    if(isCode) {
                        var lines = bodyArray[item]['text'].split('\n');
                        lines.forEach(function(entry) {
                            text += '<li class="L0">'+entry+'</li>';
                        });
                    }
                    else text = helper.linkify(bodyArray[item]['text']);
                    richText += text;
            }
        });
        return richText;
    },
   
linkify: function (inputText) {
        var replacedText, replacePattern1, replacePattern2, replacePattern3;
        
    	//URLs starting with http://, https://, or ftp://
        // To remove parentheses from url in inputText. Updated by ufar on 14 03 2022
    	// regex updated from "/(\b(https?|ftp):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gim"; 
      	replacePattern1 = /(\b(https?|ftp|file|<a):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;+(+)]*[-A-Z0-9+&@#\/%=~_|])/gim;
        replacedText = inputText.replace(replacePattern1, '<a href="$1" target="_blank">$1</a>');
        
        //URLs starting with "www." (without // before it, or it'd re-link the ones done above).
        replacePattern2 = /(^|[^\/])(www\.[\S]+(\b|$))/gim;
        replacedText = replacedText.replace(replacePattern2, '$1<a href="http://$2" target="_blank">$2</a>');
        
        //Change email addresses to mailto:: links.
        replacePattern3 = /(([a-zA-Z0-9\-\_\.])+@[a-zA-Z\_]+?(\.[a-zA-Z]{2,6})+)/gim;
        replacedText = replacedText.replace(replacePattern3, '<a href="mailto:$1">$1</a>');
        
        return replacedText;
    },
    
    gotoURL : function (url) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/006/o"
        });
        urlEvent.fire();
    },
        
	MAX_FILE_SIZE: 3000000, 
    getBlob : function(component,file) {
        if (file.size > this.MAX_FILE_SIZE) {
            alert('File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' + 'Selected file size: ' + file.size);
            component.set('v.fileDataJSON',"");
            return;
        }

        var fr = new FileReader();

        var self = this;
        fr.onload = function() {
            var fileContents = fr.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;

            fileContents = fileContents.substring(dataStart);
            var fileData = {
                'fileName': file.name,
                'fileContents': fileContents,
                'contentType': file.type
            }
            var fileDataJson = JSON.stringify(fileData);
            component.set('v.fileDataJSON',fileDataJson);
        };

        fr.readAsDataURL(file);
        
        return true;
    },
    

})
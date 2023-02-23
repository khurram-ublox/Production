import { LightningElement,api } from 'lwc';
import jsForce from '@salesforce/resourceUrl/JSForce';
import getSOQLResult from '@salesforce/apex/LeaverMetadataAccess.getSOQLResult';
import {exportCSVFileFromHTMLTable} from 'c/fileDownloadCSVUtil'

export default class MetadataDetail extends LightningElement {
    @api mname;
    @api detail;
	@api count;
    @api conn;
    @api configInfo={};
    @api currentUserId;
    @api nextUserId;
    @api usersObject = [];
    @api recordListHTML='';
    records=[];
    activeSections = ['C'];
    activeSectionsMessage = '';
    version = '48.0';

    handleSectionToggle(event) {

        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
        }
    }
    connectedCallback(){
        this.processConfig();
    }

    processConfig()
    {
        var actionType = this.configInfo.type;
        switch (actionType) {
            case 'SOQL':
                this.processSOQLRequest();
                break;
            case 'METADATA':
                this.processMetadataRequest();
                break;
            case 'TOOLING':
                this.processToolingRequest();
                break;
            default:    
        }
    }
    processToolingRequest(){
        var cmpThis = this;
        var cQuery = 'select '+this.configInfo.fields+' from '+this.configInfo.objectAPI+' '+this.configInfo.filter ;
        try{
        this.conn.tooling.query(cQuery,function(err, metadata) {
            if(err)
            {    
                alert('Meta Error : '+err);
                return;
            }
            if(metadata && metadata.records)
            {   
                cmpThis.detail = "Total records in Org-"+metadata.totalSize;
                metadata.records.forEach(metaObj => {
                    cmpThis.callToolObjectAPI(metaObj);
                });        
            }else{
                cmpThis.detail = "No result check Metadata config";
            }            
        });
        }catch(ex)
        {
            alert('Meta Excep:'+JSON.stringify(ex));
        }
    }
    processMetadataRequest(){
        var types = [{type: this.configInfo.objectAPI, folder: null}];
        this.conn.metadata.list(types,function(err, metadata) {
            if (err) { return alert(JSON.stringify(err)); }
            alert('Metadata->'+JSON.stringify(metadata));
        });        
    }

    callToolObjectAPI(metaObj)
    {
        try{
        var cmThis = this;     
        this.conn.request('/services/data/v'+this.version+'/tooling/sobjects/'+this.configInfo.metaObject+'/'+metaObj.Id+'', function(err, response) {
            if(!err && response)
                cmThis.checkForWorkflowAlert(response);
            if(err)
                alert('Error tooling sObject->'+JSON.stringify(err));    
        });
        }catch(ex)
        {
            alert('Exception Tooling Sobjects->'+ex);
        }
    }

    checkForWorkflowAlert(response)
    {
        var localConfigInfo = JSON.parse(JSON.stringify(this.configInfo));
        localConfigInfo.metaNameField = 'FullName';
        localConfigInfo.metaObjectView = 'WorkflowEmails';
        var isEmailPresent = false;
        
        if(response.Metadata)
        {
            response.Metadata.ccEmails.forEach(ccEmailObj => {
                if(ccEmailObj == this.usersObject[0].Email){
                    isEmailPresent = true;
                }
            });
            response.Metadata.recipients.forEach(recObj => {
                if(recObj.recipient == this.usersObject[0].Email){
                    isEmailPresent = true;
                }
            });
            if(response.Metadata.senderAddress == this.usersObject[0].Email){
                isEmailPresent = true;
            }
            if(isEmailPresent)
            {
                this.createMetaListView(response,localConfigInfo);
            }
        }
    }

    processSOQLRequest()
    {
        var cmpThis = this;
        var qStr = 'SELECT '+this.configInfo.fields+' from '+this.configInfo.objectAPI;
        if(this.configInfo.filter!=null && this.configInfo.filter!='')
            qStr +=' '+this.configInfo.filter;
        qStr = this.populateMergeFields(qStr);
        this.callSOQL(qStr);            
    }

    processSOQLResponse____(res)
    {
        var dInfo = '0';
        if(res.totalSize)
            dInfo = res.totalSize;
           
        this.detail = 'Records Count - '+ dInfo;
        this.createIdListView(res.records);
        this.records = res.records;
    }

    processApexSOQLResponse(res)
    {
        var dInfo = '0';
        if(res) {
			this.count = res.length;
			this.detail = this.configInfo.filter;
		}
        if(res && res.length!=0) {
            this.createIdListView(res);
            this.records = res;            
        }    
    }   

    createIdListView(records)
    {
        if(records)
        {
			var currentUid = this.usersObject[0];
			if(currentUid) currentUid = currentUid.Id;
			var nextUid = this.usersObject[1];
			if(nextUid) nextUid = nextUid.Id;

			var user_fields = this.configInfo.userFields.replace(/ /g,'').split(',');

			//if(this.configInfo.objectAPI == 'Account') console.log(records);
            var htmlStr ='<table class="tRecData slds-table slds-table_cell-buffer slds-table_bordered">';
			var elemStr = '';

			var fields_list = this.configInfo.fields.split(',');
			if(fields_list.length>0) {
				htmlStr += '<thead><tr class="slds-line-height_reset"><th scope="col"><div class="slds-truncate">#<div></th>';
				for(var i = 0; i < fields_list.length; i++) {
					htmlStr += '<th scope="col"><div class="slds-truncate">'+fields_list[i].trim()+'</div></th>';
					// if user lookup field, add also preovius values to the table.
					if(user_fields.includes(fields_list[i].trim()) && nextUid) htmlStr += '<th scope="col"><div class="slds-truncate">'+fields_list[i].trim()+'_OLD</div></th>';
				}
				htmlStr += '</tr></thead><tbody>';
			}

            for(var i = 0; i < records.length; i++) {

				elemStr += '<tr><td>'+(i+1)+'</td>';
				for(var ii = 0; ii < fields_list.length; ii++) {
					var field_name = fields_list[ii].trim();
					var field_value = records[i][field_name];
					var thC = '';
					var thN = '';
					if(field_value !== undefined) {
						if(user_fields.includes(field_name) && nextUid) {
							if(field_value==currentUid) {
								thC = 'style="color: #b97900"';
								thN = 'style="color: #1bb81b"';
							}
							elemStr += '<th><a href="/'+field_value.replace(currentUid,nextUid)+'" target="_blank" '+thN+'>'+field_value.replace(currentUid,nextUid)+'</a></th>';
							elemStr += '<th><a href="/'+field_value+'" target="_blank" '+thC+'>'+field_value+'</a></th>';
						}
						else {
							if(field_value==currentUid) {
								thC = 'style="color: #b97900"';
							}
							if(field_name.toLowerCase() == 'id' || user_fields.includes(field_name)) elemStr += '<th><a href="/'+field_value+'" target="_blank" '+thC+'>'+field_value+'</a></th>';
							else elemStr += '<th>'+field_value+'</th>';
						}
					}
					else {
						elemStr += '<th></th>';
						if(user_fields.includes(field_name) && nextUid) elemStr += '<th></th>';
					}
				}
				elemStr += '</tr>'; 
                // //var urlStr = '/lightning/r/'+this.configInfo.objectAPI+'/'+records[i].Id+'/view';
            }
            htmlStr += elemStr + "</tbody></table>";
            this.recordListHTML =  htmlStr;
        }
        
    }

    createMetaListView(response,lConfig)
    {
        if(response)
        {
            var htmlStr ='<ul class="slds-has-dividers_top slds-has-block-links">';
            var elemStr = '<li class="slds-item">';
            var urlStr='/lightning/setup/'+lConfig.metaObject+'/page?address=%2F'+response.Id
            elemStr =elemStr+ '<a href="'+urlStr+'" target="_blank">'+response.Id+' - '+response[lConfig.metaNameField]+'</a>';
            elemStr =elemStr+'</li>';  
            htmlStr=htmlStr+ elemStr;
            htmlStr=htmlStr+"</ul>";
            this.recordListHTML = this.recordListHTML + htmlStr;
        }       
    }
    processMetadataResponse(res)
    {
        this.detail = 'Records - '+ JSON.stringify(res);
    }

    populateMergeFields(qStr){
        var currentUid = this.usersObject[0];
        qStr = this.replaceAll(qStr,'{uid}',currentUid.Id);
        qStr = this.replaceAll(qStr,'{uAlias}',currentUid.Alias);
        qStr = this.replaceAll(qStr,'{uEmail}',currentUid.Email);
        return qStr;
    }

    replaceAll(strObj,searchStr,replacementStr)
    {
        return strObj.split(searchStr).join(replacementStr);
    }

    callSOQL(qStr)
    {
        var cmpThis = this;
        const request = { soqlStr: qStr };    
        getSOQLResult(request)
            .then(result => {
                cmpThis.processApexSOQLResponse(result);
            })
            .catch(error => {

                alert('Error from Apex SOQL->'+JSON.stringify(error));
            });
    }
    handleDownloadClick()
    {
        this.downloadCSVFile();
    }
    downloadCSVFile() {        
        let tableDataElement = this.template.querySelector("lightning-formatted-rich-text").value;
        let wrapperDiv= document.createElement('div');
        wrapperDiv.innerHTML = tableDataElement;
        let tableEle = wrapperDiv.querySelector("table");
        let fName = this.configInfo.objectName+"-"+Date.now();
        exportCSVFileFromHTMLTable(tableEle, fName);
    }
    
}
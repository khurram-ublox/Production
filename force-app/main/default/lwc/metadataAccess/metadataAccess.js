import { LightningElement,wire,track,api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript } from 'lightning/platformResourceLoader';
import leaverConfigJS from '@salesforce/resourceUrl/LeaverPageConfig';
import { getErrorStrings,showMessage,showErrorMessage } from 'c/commonUtils';
import jsForce from '@salesforce/resourceUrl/JSForce';
import getSOQLResult from '@salesforce/apex/LeaverMetadataAccess.getSOQLResult';

export default class MetadataAccess extends LightningElement {
    metadataInitialized = false;
    @api userSessionId='';
    @api connObj;
    @api useMetaAPI = false;
    @track totalCount=0;
    currentUserId;
    nextUserId;
    userObjects = [];
    configData = [];
    config={};
    startSearch = false;
    renderedCallback() {
        this.config = this.configData[0];        
        this.loadScriptFunc(null);
        this.hideHelpText();        
    }
    
    loadScriptFunc(paramAttr)
    {
        if (this.metadataInitialized) {
            if(paramAttr!=null)
                this.startSearch = true;
            return;
        }
        try{
            
            Promise.all([
                loadScript(this,leaverConfigJS),
                loadScript(this,jsForce)                
            ]).then(() => {
                    this.configData = leaverConfig;
                    this.metadataInitialize();
                    this.metadataInitialized = true;
                    if(paramAttr!=null)
                    {
                        this.startSearch = true;
                    }
            })
            .catch(error => {
                alert('JS Load Error ->'+error);                
            });      
        }catch(ex)
        {
            alert('JS Load Error ->'+error);
        }
    }
    handleLoad(event){
        var cmpThis = this;
        this.hideHelpText();
    }
    handleSubmit(event){
        event.preventDefault();
        this.startSearch = false;
        const fields = event.detail.fields;
        //this.currentUserId = fields.FAE__c;
        this.nextUserId = fields.New_Channel_Manager__c;
        this.callUserQuery();        
    }
    handlelookupupdate(event){
        if(event.detail.selectedRecord){
            this.currentUserId = event.detail.selectedRecord.Id;
            console.log("The result from lookupupdate:  "  + this.currentUserId);
        }
    }
    hideHelpText()
    {
        var helpElement = this.template.querySelectorAll('lightning-input-field');
        helpElement.forEach(function(userItem) {
            var pStyle = document.createElement('style');
            pStyle.innerHTML = 'lightning-helptext {display:none;}';
            userItem.appendChild(pStyle);
        });
    }
    @api
    get configDataObj(){
        var cmpThis = this;
        var configObj = [];
        configObj = cmpThis.configData.filter(function( obj ) {
            var addConfig = ((cmpThis.useMetaAPI == false) && (obj.type != 'SOQL')) ? false:true;
            return addConfig;
        });
        return configObj;
    }

    metadataInitialize()
    {
        if(this.userSessionId!='')
        {
            try{
                if(this.connObj == undefined && this.useMetaAPI)
                    this.connObj = new jsforce.Connection({ accessToken: this.userSessionId }); 
                	this.metadataInitialized = true;                               
            }catch(ex){
                alert('Error:'+ex);
            }
        }
    }

    callUserQuery(){
        console.log("Eneter callUserQuery:  "  + this.currentUserId);
        var cmpThis = this;
        var qStr = 'select Id,Alias,Name,Email from user where ';
        
        if(this.currentUserId==null)
            return; 

        if(this.currentUserId!=null)
            qStr += 'id=\''+this.currentUserId+'\'';
        if(this.nextUserId!=null){
            if(this.currentUserId!=null)
                qStr +=' OR ';
            qStr +='id =\''+this.nextUserId+'\'';
        }
        this.callSOQL(qStr);
        /*if(this.connObj)
        {
            this.connObj.query(qStr, function(err, res) {
                if (err) {
                    return alert('Query Error-->'+err);
                }
                cmpThis.processUserResponse(res);
            });
        }*/
    }
    processUserResponse(res)
    {
        var vRecords = res.records;
		this.userObjects[1] = null;
        for (var i=0; i < vRecords.length; i++) {
            var record = vRecords[i];
            if(record.Id == this.currentUserId)
            {
                this.userObjects[0] = record;
            } else if(record.Id == this.nextUserId) {
                this.userObjects[1] = record;
            }
        }
        this.loadScriptFunc('Submit');
    }
    processApexUserResponse(res)
    {
        var vRecords = res;
		this.userObjects[1] = null;
        for (var i=0; i < vRecords.length; i++) {
            var record = vRecords[i];
            if(record.Id == this.currentUserId)
            {
                this.userObjects[0] = record;
            } else if(record.Id == this.nextUserId) {
                this.userObjects[1] = record;
            }
        }
        this.loadScriptFunc('Submit');
    }
    showErrorMsg(error)
    {
        var errStr = getErrorStrings(error);
        this.dispatchEvent(showMessage('error','Error :',JSON.stringify(error),'pester'));        
    }
    showMessage(type,title,msg)
    {
        this.dispatchEvent(showMessage(type,title,msg,'pester'));        
    }

    callSOQL(qStr)
    {
        var cmpThis = this;
        const request = { soqlStr: qStr };    
        getSOQLResult(request)
            .then(result => {
                cmpThis.processApexUserResponse(result);
            })
            .catch(error => {

                alert('Error from Apex SOQL->'+JSON.stringify(error));
            });
    }
}
import { LightningElement,wire, api, track } from 'lwc';
import addUserFileMethod from '@salesforce/apex/userFileComponentHelper.addUserFile';
import { NavigationMixin } from 'lightning/navigation';
import CreateUserFileFault from '@salesforce/label/c.CreateUserFileFault';

export default class ContactUserFileAction extends NavigationMixin(LightningElement) {
    @api recordId;
    @track
    showMessage = '';
    sObject = 'User_File__c';
    
    label = {
        CreateUserFileFault
    };

    connectedCallback(){
        addUserFileMethod({ contactId: this.recordId })
            .then(result => {
                this.processResponse(result);                
            })
            .catch(error => {
                this.showMessage = 'There is system Error!';
            });        
    }
    
    processResponse(tResponse)
    {
        if(tResponse && tResponse != '')
        {
            if(tResponse.status =='Success' && tResponse.uFileId){
                this.navigateToUserFileRecord(tResponse.uFileId);
                this.closeAction();
            }
            else
            {
                this.showMessage = tResponse.message;
            }
        }else{
            this.showMessage = this.label.CreateUserFileFault;
        }
    }
    navigateToUserFileRecord(recId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recId,
                objectApiName: this.sObject,
                actionName: 'view'
            },
        });
    }

    closeAction(){
        const closeAction = new CustomEvent('close');
        this.dispatchEvent(closeAction);
    }
}
import { LightningElement,api } from 'lwc';
import getUserFileMethod from '@salesforce/apex/userFileComponentHelper.getUserFileForLoggedInUser';
import UFNOTPRESENT from '@salesforce/label/c.UserFileNotPresent';
import UFCOMPERROR from '@salesforce/label/c.UserFileComponentError';

export default class CommunityFileRelatedList extends LightningElement {
    @api title;
    @api searchURLParam;
    @api recordId;
    @api containerMinHeight;

    showFileRelatedList = false;
    showMessage = '';
    label = {
        UFNOTPRESENT,
        UFCOMPERROR
    };
    connectedCallback(){
        getUserFileMethod()
            .then(result => {
                if(result){
                    this.showMessage = '';
                    this.recordId = result.Id;
                    this.showFileRelatedList = true;
                }else{
                    this.showFileRelatedList = false;
                    this.showMessage = this.label.UFNOTPRESENT;
                }                
            })
            .catch(error => {
                this.showFileRelatedList = false;
                this.showMessage = this.label.UFCOMPERROR;
            }); 
                       
    }

    renderedCallback(){
        this.initCustomStyle();
    }
    initCustomStyle()
    {
        let bodyStyle = document.body.style;
        if(bodyStyle)
        {
            bodyStyle.setProperty('--container-min-height', this.containerMinHeight);
        }
    }            
}
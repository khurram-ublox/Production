import { LightningElement,wire, api, track } from 'lwc';
import getUserFileMethod from '@salesforce/apex/userFileComponentHelper.getUserFileForLoggedInUser';
import { NavigationMixin } from 'lightning/navigation';
import UFNOTPRESENT from '@salesforce/label/c.UserFileNotPresent';
import UFCOMPERROR from '@salesforce/label/c.UserFileComponentError';

export default class ContactUserCommunityUserFilePageRedirect extends NavigationMixin(LightningElement) {
    @api recId;
    @api redirectPageName ='userfile';
    showMessage = '';
    label = {
        UFNOTPRESENT,
        UFCOMPERROR
    };
    connectedCallback(){
        getUserFileMethod()
            .then(result => {
                if(result){
                    this.navigateToUserFilePage(result.Id);
                }else{
                    this.showMessage = this.label.UFNOTPRESENT;
                }                
            })
            .catch(error => {
                this.showMessage = this.label.UFCOMPERROR;
            });        
    }

    getUrlMethod(rId)
    {
        let urlAdd = '/s/'+this.redirectPageName+'?tId='+rId;
        return urlAdd;
    }
    navigateToUserFilePage(rId) {
        let urlAdd = this.getUrlMethod(rId); 
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url:urlAdd,
                isredirect : true
            }            
        },true);
    }
}
import { LightningElement,wire,api } from 'lwc';
import cUserId from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import communityPath from '@salesforce/community/basePath';

import PARTNER_HOME_MESSAGE_LABEL from '@salesforce/label/c.PartnerHomeMessage';
import FINANCE_PARTNER_HOME_MESSAGE_LABEL from '@salesforce/label/c.PartnerHomeFinanceMessage';


const USER_REC_FIELDS = [
    "User.Name",
    "User.FirstName",
    "User.Contact.Account.Name",
    "User.Contact.Account.LogoId__c",
    "User.Profile.Name"
];
export default class PartnerUserHome extends LightningElement {
    partnerUserId = cUserId;
    userRec = null;
    userAccLogoLink='';
    userAccLogoPresent = false;
    isFinanceUser = false;

    label = {
        PARTNER_HOME_MESSAGE_LABEL,
        FINANCE_PARTNER_HOME_MESSAGE_LABEL
    };

    @wire(getRecord, { recordId: '$partnerUserId', fields: USER_REC_FIELDS })
    wiredRecord({ error, data }) { 
        if ( error ) { 
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
        } else if ( data ) {
            this.userRec = data;
            if(this.userRec && this.userRec.fields.Contact.value 
                && this.userRec.fields.Contact.value.fields.Account.value)
            {
                let accLogoId = this.userRec.fields.Contact.value.fields.Account.value.fields.LogoId__c.value;
                if(accLogoId){
                    let communityName = '';
                    if(communityPath && communityPath.endsWith('/s'))
                    {
                        communityName = communityPath.substr(0,communityPath.length-2);
                    }
                    this.userAccLogoLink = communityName+'/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId='+accLogoId;
                    this.userAccLogoPresent = true;
                }

                let profileName = this.userRec.fields.Profile.value.fields.Name.value;
                if(this.userRec.fields.Profile.value && profileName)
                {
                    this.isFinanceUser = profileName.includes("Finance")?true:false;
                }
            }
        } 
    }
}
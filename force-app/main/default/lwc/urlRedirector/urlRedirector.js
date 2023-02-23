import { LightningElement } from 'lwc';
import { NavigationMixin } from "lightning/navigation";

export default class UrlRedirector extends NavigationMixin(LightningElement) {
   
    url_string = '';

    handleUrlChange(event){
        this.url_string = event.target.value;
    } 

    handleEnter(event){
        if(event.keyCode === 13){
            this.handleSearch();
        }
    }

    handleSearch () {
        let sf_keys_object = {
            '001': 'Account',
            '007': 'Activity',
            '00P': 'Attachment',
            '701': 'Campaign',
            '00v': 'Campaign Member',
            '500': 'Case',
            '003': 'Contact',
            '800': 'Contract',
            '01Z': 'Dashboard',
            '00U': 'Event',
            '00l': 'Folder',
            '00Q': 'Lead',
            '00B': 'List View',
            '002': 'Note',
            '006': 'Opportunity',
            '00k': 'Opportunity Product',
            'a1G': 'Opp Product',
            'a01': 'Partner Roles',
            'a07': 'Billings__c',
            '01u': 'Pricebook Entry',
            '01s': 'Pricebook2',
            '01t': 'Product2',
            '00e': 'Profile',
            '00O': 'Report',
            '0Q0': 'Quote',
            '0QL': 'QuoteLineItem',
            '00T': 'Task',
            '005': 'User',
        };
    
        let sf_keys_array = Object.keys(sf_keys_object);

            var hostname = window.location.hostname;
            var domain_base = 'https://' + hostname;

            var id = '';
            var object = '';

            var url_parts = this.url_string.split('/');

            url_parts.forEach(function(url_substring) {
                if ((url_substring.length == 15 || url_substring.length == 18) && sf_keys_object[url_substring.slice(0, 3)] !== undefined) {
                    id = url_substring;
                    object = sf_keys_object[url_substring.slice(0, 3)];
                    if(domain_base.includes("lightning")) domain_base += '/lightning/r/' + id + '/view';
                    else if(domain_base.includes("partner.u-blox.com")) domain_base += '/s/detail/' + id;
                    else if(domain_base.includes(".my.site.com")) domain_base += '/partner/s/detail/' + id;
                    else domain_base += '/' + id;
                }
            });

            if (id === '') {
                alert('The URL / ID is not valid.');
                return false;
            }
            const config = {
                type: 'standard__webPage',
                attributes: {
                    url: domain_base
                }
            };
            this[NavigationMixin.Navigate](config);
    }
}
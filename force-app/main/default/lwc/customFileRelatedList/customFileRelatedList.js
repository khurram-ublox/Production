import { api, LightningElement, track, wire } from 'lwc';
import getFilteredContentDetails from '@salesforce/apex/CustomFileRelatedListService.getFilteredContentDetails';
import { NavigationMixin,CurrentPageReference } from 'lightning/navigation';
import CommunityFileRecordNotPresent from '@salesforce/label/c.CommunityFileRecordNotPresent';
const SEARCH_DELAY = 500;

const actions = [
    { label: 'Download', name: 'Download' }
];

const columns = [
    { label: 'Title', fieldName: 'downloadUrl',wrapText : true, type:'url',
        cellAttributes: { 
            iconName: { fieldName: 'icon' }, iconPosition: 'left' 
        },
        typeAttributes: {
            label: { 
                fieldName: 'Title'
            },
            title : 'Title'
        },
        sortable : true 
    },
    { label: 'Created By',  fieldName: 'CREATED_BY',
        cellAttributes: { 
            iconName: 'standard:user', iconPosition: 'left' 
        }
    },
    { label: 'File Size',   fieldName: 'Size' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    }
];

export default class CustomFileRelatedList extends NavigationMixin(LightningElement) {

    @api title;
    @api showDetails;
    @api showFileUpload;
    @api showsync;
    @api recordId;
    @api usedInCommunity;
    @api showFilters;
    @api accept = '.csv,.doc,.xsl,.pdf,.png,.jpg,.jpeg,.docx,.doc';
    @api searchURLParam;

    @track dataList;
    @track columnsList = columns;
    @track searchStr;
    @track noDataPresent = false;
    @track errorMsg='';
    
    sortedBy;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    
    isLoading = false;

    wiredFilesResult;
    searchTimeout;

    label = {
        CommunityFileRecordNotPresent
    };    

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
      if (currentPageReference) {
         let urlStateParameters = currentPageReference.state;
         let searchParamStr = this.searchURLParam;
         if(urlStateParameters && searchParamStr)
         {
            let paramVal =  urlStateParameters[searchParamStr];
            if(paramVal)
                this.searchStr = paramVal;
         }
      }
    }

    connectedCallback() {
        this.handleSync();
    }

    getBaseUrl(){
        let baseUrl = 'https://'+location.host+'/';
        return baseUrl;
    }

    handleRowAction(event){

        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'Preview':
                // This is for extending component for other options to show in future version
                this.previewFile(row);
                break;
            case 'Download':
                this.downloadFile(row);
                break;
            case 'Delete':
                // This is for extending component for other options to show in future version
                this.handleDeleteFiles(row);
                break;
            default:
        }

    }

    previewFile(file){
        
        if(!this.usedInCommunity){
            
            this[NavigationMixin.Navigate]({
                type: 'standard__namedPage',
                attributes: {
                    pageName: 'filePreview'
                },
                state : {
                    selectedRecordId: file.ContentDocumentId
                }
            });
        } else if(this.usedInCommunity){
            
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: file.fileUrl
                }
            }, false );
        }
        
    }

    downloadFile(file){
        this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: file.downloadUrl
                }
            }, false 
        );
    }

    handleDeleteFiles(row){

        this.isLoading = true;

        deleteContentDocument({
            recordId : row.ContentDocumentId
        })
        .then(result => {
            this.dataList  = this.dataList.filter(item => {
                return item.ContentDocumentId !== row.ContentDocumentId ;
            });
        })
        .catch(error => {
            //console.error('Error-\n',error);
            //this.errorMsg = JSON.stringify(error);
        })
        .finally(()=>{
            this.isLoading = false;
        });
    }

    handleSync(){
        this.isLoading = true;
        getFilteredContentDetails({
            recordId : this.recordId,
            searchStr : this.searchStr
        })
        .then(result => {
            this.handleResponse(result);            
        })
        .catch(error => {
            //console.error('Error-\n',error);
        })
        .finally(()=>{
            this.isLoading = false;
        });        
    }

    handleResponse(result){
        let imageExtensions = ['png','jpg','gif'];
        let supportedIconExtensions = ['ai','attachment','audio','box_notes','csv','eps','excel','exe',
                        'flash','folder','gdoc','gdocs','gform','gpres','gsheet','html','image','keynote','library_folder',
                        'link','mp4','overlay','pack','pages','pdf','ppt','psd','quip_doc','quip_sheet','quip_slide',
                        'rtf','slide','stypi','txt','unknown','video','visio','webex','word','xml','zip'];
        let finalData = result ;
        let baseUrl = this.getBaseUrl();
        finalData.forEach(file => {
            file.downloadUrl = baseUrl+'sfc/servlet.shepherd/document/download/'+file.ContentDocumentId+'?operationContext=S1';
            file.fileUrl     = baseUrl+'sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId='+file.Id;
            file.CREATED_BY  = file.ContentDocument.CreatedBy.Name;
            file.Size        = this.formatBytes(file.ContentDocument.ContentSize, 2);

            let fileType = file.ContentDocument.FileType.toLowerCase();
            if(imageExtensions.includes(fileType)){
                file.icon = 'doctype:image';
            }else{
                if(supportedIconExtensions.includes(fileType)){
                    file.icon = 'doctype:' + fileType;
                }
            }                
        });
        this.dataList = finalData;
        if(this.dataList && this.dataList.length>0)
        {
            this.noDataPresent = false;
        }else{
            this.noDataPresent = true;
        }
    }
    get disableDownloadButton(){
        let showDownload = false;
        let lTable = this.template.querySelector('lightning-datatable');
        if(lTable){
            let selectedRows = lTable.getSelectedRows();
            if(selectedRows && selectedRows.length > 0){
                showDownload = true;
            }else{
                showDownload = false;
            }
        }
        return !showDownload;
    }

    handleDownload(){
        let baseUrl = this.getBaseUrl();
        var contentIdStr = "";
        let selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows(); 
        if(selectedRows && selectedRows.length > 0){
            let rowsSelectedCount = selectedRows.length;
            selectedRows.forEach(function (row,index) {
                let delimeterStr = index == (rowsSelectedCount-1) ?'': '/';
                contentIdStr = contentIdStr.concat(row.ContentDocumentId,delimeterStr);
            });
            let zipDownloadUrl = baseUrl+'sfc/servlet.shepherd/document/download/'+contentIdStr+'?';
            let allFiles = {};
            allFiles.downloadUrl = zipDownloadUrl;
            this.downloadFile(allFiles);
        }
    }
    handleUploadFinished(){
        this.handleSync();
    }
    formatBytes(bytes,decimals) {
        if(bytes == 0) return '0 Bytes';
        var k = 1024,
            dm = decimals || 2,
            sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
            i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
    }

    handleSearch(event){
        try{
            // for search throttling
            if (this.searchTimeout) {
                clearTimeout(this.searchTimeout);
            }
            if(event.target.value){
                this.searchStr = event.target.value;
            }else{
                this.searchStr = '';
            }

            this.searchTimeout = setTimeout(() => {
                this.handleSync();
                this.searchTimeout = null;     
            }, SEARCH_DELAY);
        }catch(error){
            //console.error('Error-\n',error);
        }
    }

    handleSortdata(event) {
        try{
            const { fieldName: sortedBy, sortDirection } = event.detail;
            const tempData = [...this.dataList];
            this.sortDirection = sortDirection;
            this.sortedBy = sortedBy;
            let tSortedBy = (sortedBy == 'downloadUrl') ? 'Title':sortedBy;
            tempData.sort( this.sortBy( tSortedBy, sortDirection === 'asc' ? 1 : -1 ) );
            this.dataList = tempData;    
        }catch(error)
        {
            //console.error('Error-\n',error);
        }    
    }

    sortBy( field, reverse, primer ) {

        const key = primer
            ? function( x ) {
                  return primer(x[field]);
              }
            : function( x ) {
                  return x[field];
              };

        return function( a, b ) {
            a = key(a);
            b = key(b);
            return reverse * ( ( a > b ) - ( b > a ) );
        };

    }
    
}
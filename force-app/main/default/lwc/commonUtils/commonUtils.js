import { ShowToastEvent } from 'lightning/platformShowToastEvent';
var getErrorStrings = function(errors) {
    if (!Array.isArray(errors)) {
        errors = [errors];
    }

    return (
        errors
            // Remove null/undefined items
            .filter((error) => !!error)
            // Extract an error message
            .map((error) => {
                // UI API read errors
                if (Array.isArray(error.body)) {
                    return error.body.map((e) => e.message);
                }
                // UI API DML, Apex and network errors
                else if (error.body && typeof error.body.message === 'string') {
                    return error.body.message;
                }
                // JS errors
                else if (typeof error.message === 'string') {
                    return error.message;
                }
                // Unknown error shape so try HTTP status text
                return error.statusText;
            })
            // Flatten
            .reduce((prev, curr) => prev.concat(curr), [])
            // Remove empty strings
            .filter((message) => !!message)
    );
}

var showErrorMessage = function (type,title,mode,error){
    var errStr = this.getErrorStrings(error);
    this.showMessage(type,title,JSON.stringify(errStr),mode);
}

var showMessage = function(type,title,msg,mode){
    const event = new ShowToastEvent({
        variant:type,
        title: title,
        message: msg,
        mode:mode
    });  
    
    return event;
}

export {getErrorStrings,showErrorMessage,showMessage};
trigger accountPreventDeletion on Account (before delete) {
    for(Account acc : Trigger.Old){
        if(acc.Customer_No__c!=null){
            acc.AddError('Cannot delete Abacus account. Please contact Sales admin.');
            system.debug('Adding debug from SB');
        }
    }
}
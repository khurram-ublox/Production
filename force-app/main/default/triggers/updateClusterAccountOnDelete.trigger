trigger updateClusterAccountOnDelete on Account (before delete, after delete) {

    if (Trigger.IsBefore)
    {
        AccountClusterClass.updateAccountClusterBeforeDelete(Trigger.oldMap);
    }
    else if (Trigger.IsAfter)
    {
        AccountClusterClass.updateAccountClusterAfterDelete(Trigger.oldMap);
    }
}
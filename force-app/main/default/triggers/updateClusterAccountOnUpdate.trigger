trigger updateClusterAccountOnUpdate on Account (after update) {
    AccountClusterClass.updateClusterAfterUpdate(Trigger.newMap, Trigger.oldMap);
}
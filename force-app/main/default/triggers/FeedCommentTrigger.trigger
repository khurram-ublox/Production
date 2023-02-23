trigger FeedCommentTrigger on FeedComment (before insert) { 
    TriggerFactory.createAndExecuteHandler(FeedCommentTriggerHandler.Class);
}
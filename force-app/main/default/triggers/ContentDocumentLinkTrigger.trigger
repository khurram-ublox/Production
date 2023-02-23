trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert,after insert,before delete) {
    TriggerFactory.createAndExecuteHandler(ContentDocumentLinkTriggerHandler.Class);
}
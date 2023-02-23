trigger EmailMessageTrigger on EmailMessage (before insert) {
    TriggerFactory.createAndExecuteHandler(EmailMessageTriggerHelper.Class);
}
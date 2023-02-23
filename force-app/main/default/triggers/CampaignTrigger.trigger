trigger CampaignTrigger on Campaign (after insert){
    TriggerFactory.createAndExecuteHandler(CampaignTriggerHandler.class);
}
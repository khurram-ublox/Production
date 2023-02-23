/**
 * @description Trigger that creates additional member statuses for a new campaign.
 *
 * @author ldra
 */
 
trigger setCampaignOnCreate on Campaign (after insert) {
    for(Campaign c : Trigger.New) {
        String campaignID = c.Id;

        CampaignMemberStatus[] statusExists = [select Id from CampaignMemberStatus where campaignId = :campaignID and Label IN ('Pending','Opened','Bounced','Unsubscribed','Clicked')];
        if (statusExists.size() == 0) {
        // Add new campain member statuses
        List<CampaignMemberStatus> statuses = new List<CampaignMemberStatus>();
            statuses.add(new CampaignMemberStatus(campaignId = campaignID, Label = 'Pending', IsDefault = true));
            statuses.add(new CampaignMemberStatus(campaignId = campaignID, Label = 'Opened'));
            statuses.add(new CampaignMemberStatus(campaignId = campaignID, Label = 'Bounced'));
            statuses.add(new CampaignMemberStatus(campaignId = campaignID, Label = 'Unsubscribed'));
            statuses.add(new CampaignMemberStatus(campaignId = campaignID, Label = 'Clicked'));
        insert statuses;
        }
    }
}
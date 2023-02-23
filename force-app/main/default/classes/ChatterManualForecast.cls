global class ChatterManualForecast implements Schedulable {
    
    global void execute(SchedulableContext ctx) {

        String groupName = 'Manual Forecast';
        String apexName = 'ChatterManualForecast';

        CollaborationGroup[] g = [Select Id from CollaborationGroup where Name = :groupName];
        String error = 'CollaborationGroup "'+groupName+'" not found.';
        if(!g.isEmpty()) {
            Id groupId = g[0].Id;
            
            Set<Id> toAdd = new Set<Id>{};
                        
            List<CollaborationGroupMember> delCol = new List<CollaborationGroupMember>{};
            List<CollaborationGroupMember> addCol = new List<CollaborationGroupMember>{};
                                
            CollaborationGroupMember[] cgm = [Select Id, MemberId, NotificationFrequency from CollaborationGroupMember where CollaborationGroupId = :groupId and CollaborationRole = 'Standard'];
            String cgms = JSON.serialize(cgm);
            //System.debug(cgms);
            
            Opp_Product__c[] opp = [SELECT Opportunity__r.Account.New_Channel_Manager__c FROM Opp_Product__c WHERE Flagged_Item__c = true and Opportunity__r.Owner.UserType = 'Standard' and Opportunity__r.Owner.IsActive = true];
            for(Opp_Product__c opp_1 : opp) {
                Id channel_manager = opp_1.Opportunity__r.Account.New_Channel_Manager__c;
                if( !toAdd.contains(channel_manager) ) {
                    toAdd.add(channel_manager);
                }
            }
            
            User[] users = [SELECT Id, UserPreferencesDisableAllFeedsEmail From User WHERE Id in :toAdd and UserPreferencesDisableAllFeedsEmail = true];
            for(User u : users) {
                u.UserPreferencesDisableAllFeedsEmail = false;
            }
            update users;
            

            if(!opp.isEmpty()) {
                // go through existing members
                for(CollaborationGroupMember cgm_1 : cgm) {
                    // if user not found in flagged list --> remove from the group
                    if( !toAdd.contains(cgm_1.MemberId) ) {
                        //System.debug('delete '+cgm_1.MemberId);
                        delCol.add(cgm_1);
                    }
                    // if user found in flagged list --> remove from the list as it is already in the group
                    else {
                        toAdd.remove(cgm_1.MemberId);
                        // change email notification preferences so user always will be signed up for emails
                        if(cgm_1.NotificationFrequency != 'P') cgm_1.NotificationFrequency = 'P';
                    }
                }
                
                // update NotificationFrequency for existing users in CollaborationGroupMember
                update cgm;
                
                // add new users
                for(Id channel_manager : toAdd) {
                    System.debug(channel_manager);
                    CollaborationGroupMember nCol = new CollaborationGroupMember(MemberId = channel_manager, CollaborationGroupId = groupId, NotificationFrequency = 'P');
                    addCol.add(nCol);
                }
                
                //delete delCol;
                //insert addCol;

                Database.DeleteResult[] resultDel = Database.Delete(delCol, false);
                for(Database.DeleteResult rD : resultDel) {
                    System.debug(rD);
                }
                Database.SaveResult[] resultIns = Database.Insert(addCol, false);
                for(Database.SaveResult rS : resultIns) {
                    System.debug(rS);
                }

                FeedItem[] feedText = [SELECT Body FROM FeedItem where Type <> 'TrackedChange' and ParentId = :groupId Order By CreatedDate LIMIT 1];
                error = 'First post not found in the chatter.\n Group Id: '+groupId;
                if(!feedText.isEmpty()) {
                    FeedItem fi = new FeedItem(Body=feedText[0].Body, ParentId=groupId, Type='TextPost', IsRichText=true);
                    insert fi;
                    error = '';
                }
            }
            
        }
        
        if(error != '') {
            //System.debug(error);
            SendEmail.toAdmin('Error in apex scheduled job: '+apexName,error);
        }
        
        
    }
}
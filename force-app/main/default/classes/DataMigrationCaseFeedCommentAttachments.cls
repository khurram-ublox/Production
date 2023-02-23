public with sharing class DataMigrationCaseFeedCommentAttachments {

    public void Execute(Datetime MIGRATIONDATE, Set<Id> oldPartnerIds, String accountIdforAttachment, Boolean useCreatedById) {
        // configue it and reply to pramod
        List<Case> tempCase = new List<Case>();
        if(useCreatedById) {
            tempCase.addAll( [Select Id, subject, OwnerId, CreatedById,CreatedDate  From Case where CreatedDate <=:MIGRATIONDATE AND (ownerId IN :oldPartnerIds OR createdById IN :oldPartnerIds)] );
        } else {
            tempCase.addAll( [Select Id, subject, OwnerId, CreatedById,CreatedDate  From Case where CreatedDate <=:MIGRATIONDATE AND ownerId IN :oldPartnerIds] );
            
        }
        List<FeedItem> items =  [Select Id, Body From FeedItem Where Type = 'TextPost' AND ParentId IN :tempCase];
        Set<id> communicationIds = new Set<id>();
        for(FeedItem item : items) {
            if(item.body == 'Internal Communication'){
                communicationIds.add(item.id);
            }
        }

        List<FeedComment> feedComments = new List<FeedComment>();
        if(!communicationIds.isEmpty()){
            feedComments.addAll([Select Id, CommentBody, relatedrecordId From FeedComment Where FeedItemId IN :communicationIds AND CreatedDate <=:MIGRATIONDATE]);
        }

        Set<Id> contentVersionIds = new Set<Id>();
        for(FeedComment comment: feedComments){
            if (!String.isBlank(comment.relatedrecordId)) {
                contentVersionIds.add(comment.relatedrecordId);
            }
        }
        set<id> contentDocumentIds = new set<id>();
        for(ContentVersion cv : [select id, Title, ContentDocumentId from contentversion where id IN :contentVersionIds]) {
            contentDocumentIds.add(cv.ContentDocumentId);
        }
        if (!contentDocumentIds.isEmpty()) {
            
            List<ContentDocumentLink> cDLinksAll = [SELECT Visibility FROM ContentDocumentLink WHERE ContentDocumentId IN :contentDocumentIds];
            List<ContentDocumentLink> cDLinks = new List<ContentDocumentLink>();

            for(ContentDocumentLink link : cDLinksAll) {
                if(link.visibility == 'InternalUsers') {
                    link.visibility = 'AllUsers';
                    cDLinks.add(link);
                }
            }
            
            if (!cDLinks.isEmpty()) {
                Database.SaveResult[] srList = Database.update(cDLinks, true);
        
                // Iterate through each returned result
                Integer counter = 0;
                String finalstr = 'Id, Success \n';
                String finalstrerr = 'Id, Error \n';
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        // Creating the CSV file for error
                        string recordString = '"'+sr.getId()+'","Success"\n';
                        finalstr = finalstr +recordString;
                    } else {
                        
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            // Creating the CSV file for error
                            string errcsv = err.getStatusCode() + ': ' + err.getMessage() + ' : ' + err.getFields();
                            string recordString = '"'+cDLinks.get(counter).id+'","'+errcsv+'"\n';
                            finalstrerr = finalstrerr +recordString;
                            
                        }
                    }
                    counter++;
                }
                String attName = 'CaseFeedCommentsAttachmentsErrors' + system.now().format('YYYYMMDDhhmm') + '.csv';
                Attachment attach = new Attachment(parentId = accountIdforAttachment, name=attName, body = Blob.valueOf(finalstr));
                insert attach;
                String attNameerr = 'CaseFeedCommentsAttachmentsSuccess' + system.now().format('YYYYMMDDhhmm') + '.csv';
                Attachment attacherr = new Attachment(parentId = accountIdforAttachment, name=attNameerr, body = Blob.valueOf(finalstrerr));
                insert attacherr;
            }
        }

    }
}
public class CaseFeedCommentsHelper {
    private static Map<string,string> commentsMap = new Map<string,string>();
    private static final string FEEDBODY_INTERNAL = 'Internal Communication';
    private static final string FEEDBODY_PARTNER = 'Partner Communication';
    private static final string STANDARD = 'Standard';
    private static final string POWERPARTNER = 'powerPartner';
    private static final string CUSTOMER = 'customer';
    private static final string PARTNER = 'partner';
    private static final string INTERNAL = 'internal';
    private static final string INTERNALUSERS = 'InternalUsers';
    private static final string ALLUSERS = 'AllUsers';
    private static final string TEXTPOST = 'TextPost';
    private static final string TEXTCOMMENT = 'TextComment';
    private static final string CONTENTCOMMENT = 'ContentComment';
    private static final Datetime MIGRATIONDATE = Datetime.newInstance(2023, 01, 29, 0, 0, 0); //y,m,d,h,m,s

    private static final map<string, string> feedUserType = new map<string, string>{
        'Standard' => 'Internal',
        'PowerPartner' => 'Partner',
        'CSPLitePortal' => 'Customer'
    };
    private static final map<string, string> userProfile = new map<string, string>{
        'internal' => 'profilesInternal',
        'partner' => 'profilesPartner',
        'customer' => 'profilesCustomer'
    };

    public static map<string,object> feedComments(Id caseId){
        String internalId = '';
        String partnerId = '';
        String internalCommunicationId = '';
        Map<String, String> communicationIds = new Map<String, String>();//{FEEDBODY_PARTNER => '', FEEDBODY_INTERNAL => ''};

        if(!Test.isRunningTest()) {
            ConnectApi.FeedElementPage result = ConnectApi.ChatterFeeds.getFeedElementsFromFeed(null, ConnectApi.FeedType.Record, caseId, 0, ConnectApi.FeedDensity.AllUpdates, null, 100, null);
            for (ConnectApi.FeedElement f : result.elements) {
                if(f instanceof ConnectApi.FeedItem ) {
                    ConnectApi.FeedItem fi = (ConnectApi.FeedItem) f;
                    // get comments for customers
                    if(fi.type == ConnectApi.FeedItemType.CreateRecordEvent) { feedComments(CUSTOMER, 'customerId', fi.id); }
                    //get comments for internal
                    if(fi.type == ConnectApi.FeedItemType.TextPost && fi.visibility == ConnectApi.FeedItemVisibilityType.InternalUsers && f.Body.text == FEEDBODY_INTERNAL) { internalId = fi.id; }
                    //get comments from partnerPortal
                    if(fi.type == ConnectApi.FeedItemType.TextPost && fi.visibility == ConnectApi.FeedItemVisibilityType.InternalUsers && f.Body.text == FEEDBODY_PARTNER) { communicationIds.put(FEEDBODY_PARTNER, fi.id); }

                }
            }
        }

        Case cObj = [Select Id, Last_Comment_By__c, Return_To__c, AccountId, Partner_Communication__c, CreatedDate, ownerId, CreatedById from Case where Id = :caseId];
        String pCommId = cObj.Partner_Communication__c;
        // This block of code for partner portal users
        for(FeedItem item : [Select Id, Body From FeedItem Where Type =:TEXTPOST AND ParentId=:pCommId]){
            if(item.body == FEEDBODY_PARTNER){
                communicationIds.put(FEEDBODY_PARTNER, item.id);
            }
        }
        //use above query 
        // This block of code is for Internal users and Internal Partner users
        // This block is only for considering comments for internal partner users before the migration date. which we have decided to not migrate to new users but show already existing comments.
        if(cObj.CreatedDate <= MIGRATIONDATE && UserInfo.getUserType() == POWERPARTNER) {
            for(FeedItem item : [Select Id, Body From FeedItem Where Type =:TEXTPOST AND ParentId=:caseId]){
                if(item.body == FEEDBODY_INTERNAL){
                    communicationIds.put(FEEDBODY_INTERNAL, item.id);
                }
            }
        }
        if(internalId != '') {
            feedComments(INTERNAL, 'internalId', internalId);
        }
        
        if(!communicationIds.isEmpty()) {
            if(UserInfo.getUserType() == STANDARD && communicationIds.containsKey(FEEDBODY_PARTNER)) {
                feedComments(PARTNER, 'partnerId', communicationIds.get(FEEDBODY_PARTNER));
            }
            if(UserInfo.getUserType() == POWERPARTNER) {
                powerPartnerFeedComments(communicationIds.get(FEEDBODY_PARTNER), communicationIds.get(FEEDBODY_INTERNAL));
            }
        }

        return commentsMap;
    }

    public static void feedComments(String userType, String commentTypeById, String userId){
        ConnectApi.CommentPage rc = ConnectApi.ChatterFeeds.getCommentsForFeedElement(null, userId, null, 100);
        addToCommentsMap(rc, userType, commentTypeById, userId);
    }

    public static void addToCommentsMap(ConnectApi.CommentPage ri, string userType, string commentType, string feedId){
        string usersJson = feedUsersProfile(ri);
        if(usersJson != null){
            commentsMap.put(userProfile.get(userType), usersJson);
        }
        commentsMap.put(commentType, feedId);
        commentsMap.put(userType, JSON.serialize(ri));
    }

    @TestVisible private static void powerPartnerFeedComments(String partnerId, String internalCommunicationId){
        map<Id,Id> createdByUserIds = new map<Id,Id>();
        map<Id, User> createdByUserMap = new map<Id, User>();
        map<Id, User> createdByFeedUserMap = new map<Id, User>();
        list<itemsDetailWrapper> itemDetails = new list<itemsDetailWrapper>();
        itemsWrapper iWrapper = new itemsWrapper();
        List<FeedComment> feedComments = new List<FeedComment>();
        List<FeedComment> internalFeedComments = new List<FeedComment>();
        
        // add partner comments to the show feed
        if(!String.isEmpty(partnerId)) {
            feedComments.addAll([Select Id, CommentBody,CreatedById,relatedrecordId,CreatedBy.Name,CreatedDate,IsRichText From FeedComment Where FeedItemId =:partnerId]);
        }
        //add internal comments to the show feed
        if(!String.isEmpty(internalCommunicationId)) {
            feedComments.addAll([Select Id, CommentBody,CreatedById,relatedrecordId,CreatedBy.Name,CreatedDate,IsRichText From FeedComment Where FeedItemId =:internalCommunicationId AND CreatedDate <=:MIGRATIONDATE]);
        }

        Set<Id> contentVersionIds = new Set<Id>();
        for(FeedComment comment: feedComments){
            createdByUserIds.put(comment.Id,comment.CreatedById);
            if (!String.isBlank(comment.relatedrecordId)) {
                contentVersionIds.add(comment.relatedrecordId);
            }
        }
        for(User u : [SELECT Id,FirstName,LastName,UserType,Profile.Name FROM User where Id IN : createdByUserIds.values()]){
            createdByUserMap.put(u.Id,u);
        }
        for(Id key : createdByUserIds.keySet()){
            createdByFeedUserMap.put(key, createdByUserMap.get(createdByUserIds.get(key)));
        }

        Map<Id, ContentVersion> cVersions =  new Map<Id, ContentVersion>([select id, Title, ContentDocumentId from contentversion where id IN :contentVersionIds]);
        for(FeedComment fComment : feedComments){

            String fileId = String.isBlank(fComment.relatedrecordId) ? '' : cVersions.get(fComment.relatedrecordId).ContentDocumentId;
            String fileTitle = String.isBlank(fComment.relatedrecordId) ? '' : cVersions.get(fComment.relatedrecordId).Title;

            itemsDetailWrapper item = new itemsDetailWrapper();
            userInfoWrapper uInfo = new userInfoWrapper();
            uInfo.id = fComment.CreatedById;
            uInfo.displayName = createdByFeedUserMap.get(fComment.id).FirstName+' '+createdByFeedUserMap.get(fComment.id).LastName;
            uInfo.userType = feedUserType.get(createdByFeedUserMap.get(fComment.id).UserType);
            uInfo.profileName = createdByFeedUserMap.get(fComment.id).Profile.Name;

            item.id = fComment.id;
            item.createdTimestamp = fComment.CreatedDate.getTime();
            item.createdDate = fComment.CreatedDate;
            item.containFile = !String.isBlank(fComment.relatedrecordId);
            item.fileId = fileId;
            item.fileDesc = fileTitle;
            item.user = uInfo;
            item.body = String.valueOf(fComment.CommentBody).escapeJava().unescapeHtml4();
            item.isRichText = fComment.IsRichText;
            itemDetails.add(item);
        }
        iWrapper.items = itemDetails;
        commentsMap.put('powerPartnerId' , partnerId);
        commentsMap.put(POWERPARTNER , JSON.serialize(iWrapper));
    }

    private static string feedUsersProfile(ConnectApi.CommentPage ri){
        JSONParser parser = JSON.createParser(JSON.serialize(ri));
        Set<String> ids = new Set<String>();
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'user')) {
                while(parser.nextToken()!= JSONToken.END_ARRAY) {
                    if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'id')) {
                        parser.nextToken();
                        ids.add(parser.getText());
                    }
                }
            }
        }

        List<user> users = [select id, profile.name from user where id IN :ids];
        if(Test.isRunningTest()) {
            users = [select id, profile.name from user limit 3];
        }
        string usersJsonArray = null;
        if(!users.isEmpty()) {
            list<itemsDetailWrapper> usersProfiles = new list<itemsDetailWrapper>();
            itemsWrapper iWrapper = new itemsWrapper();
            for(User user : users){
                itemsDetailWrapper item = new itemsDetailWrapper();
                item.id = user.id;
                item.profileName = user.profile.name;
                usersProfiles.add(item);
            }
            iWrapper.items = usersProfiles;
            usersJsonArray = JSON.serialize(iWrapper);
        }
        return usersJsonArray;
    }

    public static Boolean editComments(Id commentId, String comment, String commentType){
        try {
            if(commentType == CUSTOMER){
                comment = formatComment(comment);
            }else comment = comment.escapeHtml4();             
            FeedComment fc = [Select id, CommentBody,IsRichText from FeedComment where Id = :commentId];
            fc.IsRichText = true;
            fc.CommentBody = comment;
            update fc;
        } catch (Exception e) {
            throw new AuraHandledException('We are uable to update this comment. Error: '+e.getMessage());  
        }
        return true;
    }

    public static Boolean deleteComment(Id commentId, String commentType){
        if(commentType== PARTNER) {
            CaseComment cc = [Select Id from CaseComment where Id = :commentId];
            delete cc;
        }
        else {
            ConnectAPI.ChatterFeeds.deleteComment(null, commentId);
        }
        return true;
    }
    public static Boolean deleteDocument(Id docId){
        ContentDocument conDoc =[SELECT Id FROM ContentDocument where Id = :docId];
        delete conDoc;
        return true;
    }

    public static Id postfeedComment(String caseId, String feedId, String comment, String fileData, String commentType, String fileContentVersionId, String fileContentDocumentId){
        
        String fileId = fileContentDocumentId;
        String fileCVId = fileContentVersionId;
        Case c = [Select Id,Status, Last_Comment_By__c, Return_To__c,AccountId,Partner_Communication__c from Case where Id = :caseId];
        String pCommentId=c.Partner_Communication__c;
        // update case status when FAE add comment/message to customer
        
        if(commentType == CUSTOMER){                       
            c.Status='Waiting For Response';
            update c;
        }
        
        if(commentType == INTERNAL){ // condition added to fix the Bug, Before that every comment for customer was falling under the internal communication (Ksha: 11/04/21)
            for(FeedItem item : [Select Id, Body From FeedItem Where Type =:TEXTPOST AND ParentId=:caseId]){
                if(item.body == FEEDBODY_INTERNAL){
                    feedId = item.Id;
                }
            }

            if(String.isBlank(feedId)){
                if(!Test.isRunningTest()) {
                    ConnectApi.FeedElement fi = ConnectApiHelper.postFeedItemWithRichText(null, caseId, FEEDBODY_INTERNAL, INTERNALUSERS);
                    feedId = fi.id;
                }
            }
        }
        
        //for partner portal
        if(commentType == PARTNER){
            if(String.isEmpty(c.Partner_Communication__c)){
                Partner_Communication__c pComment = new Partner_Communication__c(Partner_Account__c=c.AccountId);//case__c = caseId
                insert pComment;
                pCommentId =pComment.Id;
                c.Partner_Communication__c = pComment.Id;
            }
            for(FeedItem item : [Select Id, Body From FeedItem Where Type =:TEXTPOST AND ParentId=:pCommentId]){
                if(item.body == FEEDBODY_PARTNER){
                    feedId = item.Id;
                }
            }
            if(string.isBlank(feedId)){
                FeedItem fi = new FeedItem(CreatedById = UserInfo.getUserId(),Body=FEEDBODY_PARTNER, Type = TEXTPOST, ParentId=pCommentId,IsRichText=false); //, Visibility = 'InternalUsers'
                insert fi;
                feedId = fi.id;
            }
        }
        
        string postComId = '';
        if(commentType == INTERNAL && !string.isBlank(feedId)){
            if(!Test.isRunningTest()) {
                ConnectApi.Comment co = ConnectApiHelper.postCommentWithMentions(null, feedId, comment, fileId);
                postComId = co.Id;
            } else {
                postComId = '012D0000000BarOIAS';
            }
        }
        else if(!string.isBlank(feedId)){ 
            if(commentType == PARTNER){
            	comment = comment.escapeHtml4();                
            }else {                
                comment = formatComment(comment);                          
            }
            String cmntType = TEXTCOMMENT;
            if(!String.isBlank(fileCVId)){
                cmntType = CONTENTCOMMENT;
            }
            FeedComment fc = new FeedComment(CreatedById = UserInfo.getUserId(),CommentBody=comment, FeedItemId=feedId, CommentType=cmntType,IsRichText=true);
            
            if(!String.isBlank(fileCVId) ) {
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = fileId;
                cdl.LinkedEntityId = commentType == PARTNER ? pCommentId : caseId;
                cdl.ShareType = 'V';
                cdl.Visibility = commentType == INTERNAL? INTERNALUSERS : ALLUSERS;
                try{ insert cdl; }Catch(Exception ex){}                
                fc.RelatedRecordId = fileCVId;
            }
            insert fc;
            postComId = fc.Id;
        }
        if(commentType != CUSTOMER) {
            String myId = UserInfo.getUserId();
            if(myId!=c.Last_Comment_By__c) {
                if(c.Last_Comment_By__c != null) {
                    c.Return_To__c = c.Last_Comment_By__c;
                }
                c.Last_Comment_By__c = myId;
            }
            update c;
        }
        return postComId;
    }

    public static Id uploadAttachment(Id caseId, String comment, String fileData){

        CaseComment cc = new CaseComment(ParentId = caseId, CommentBody = comment, IsPublished = false);
        insert cc;
        
        if(fileData!='')  {
            Map<String, Object> f = (Map<String, Object>)JSON.deserializeUntyped(fileData);

            Attachment a = new Attachment();
            a.parentId = caseId;

            a.Body = EncodingUtil.base64Decode((String)f.get('fileContents'));
            a.Name = (String)f.get('fileName');
            a.ContentType = (String)f.get('contentType');

            insert a;
        }

        Case c = [Select Id, Last_Comment_By__c, Return_To__c from Case where Id = :caseId];
        String myId = UserInfo.getUserId();
        if(myId!=c.Last_Comment_By__c) {
            if(c.Last_Comment_By__c != null) {
                c.Return_To__c = c.Last_Comment_By__c;
            }
            c.Last_Comment_By__c = myId;
        }
        update c;

        return cc.Id;
    }

    private static string formatComment(string caseCommentText){
        caseCommentText = caseCommentText.replaceAll('<p><br></p>','<p>&nbsp;</p>').replaceAll('<br>','<p></p>');
        caseCommentText = caseCommentText.replaceAll('<strong>','<b>').replaceAll('</strong>','</b>');
        caseCommentText = caseCommentText.replaceAll('<em>','<i>').replaceAll('</em>','</i>');
        caseCommentText = caseCommentText.replaceAll('<strike>','<s>').replaceAll('</strike>','</s>');
        return caseCommentText;
    }

    public class itemsWrapper {
        public list<itemsDetailWrapper> items;
    }
    public class itemsDetailWrapper {
        public string id;
        public string profileName;
        public Long createdTimestamp;
        public Datetime createdDate;
        public Boolean containFile;
        public string fileId;
        public string fileDesc;
        public userInfoWrapper user;
        public string body;
        public Boolean isRichText;
    }
    public class userInfoWrapper {
        public string id;
        public string displayName;
        public string userType;
        public string profileName;
    }
}
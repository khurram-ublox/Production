public without sharing class CaseFeedCommentsCtrl {
    
    @AuraEnabled
    public static Id getUserId() {
        return UserInfo.getUserId();
    }

    @AuraEnabled
    public static string getUserType() {
        return UserInfo.getUserType();
    }

    @AuraEnabled(cacheable=true)
    public static Map<string,object> getComments(Id caseId) {
        return CaseFeedCommentsHelper.feedComments(caseId);
    }
    
    @AuraEnabled
    public static Boolean editComment(Id commentId, String comment, String commentType) {
        return CaseFeedCommentsHelper.editComments(commentId,comment,commentType);
    }

    @AuraEnabled
    public static Boolean deleteComment(Id commentId, String commentType) {
        return CaseFeedCommentsHelper.deleteComment(commentId,commentType);        
    }

    @AuraEnabled
    public static Id postComment(String caseId, String feedId, String comment, String fileData, String commentType, String fileContentVersionId, String fileContentDocumentId) {
        return CaseFeedCommentsHelper.postfeedComment(caseId,feedId,comment,fileData,commentType, fileContentVersionId, fileContentDocumentId);    
    }

    @AuraEnabled
    public static Boolean deleteDocument(String docId){
        return CaseFeedCommentsHelper.deleteDocument(docId);    
    }
    
    @AuraEnabled
    public static Id postCcCtrl(Id caseId, String comment, String fileData) {
        return CaseFeedCommentsHelper.uploadAttachment(caseId,comment,fileData);
    }
}
/**
 * Created by wsha on 01/10/2018.
 */

public with sharing class RecentlyAccessedItems {

     @AuraEnabled
    public static boolean getUserType(){
        boolean isGuestUser = false;
        if (UserInfo.getUserType() != 'Guest') {
            isGuestUser = true;
        }
        return isGuestUser;
    }


    @AuraEnabled
    public static List<RecentlyViewed> getRecentlyViewedMixed(){
        Id thisUser = UserInfo.getUserId();
        return [ SELECT
                Id, Name,
                Type, LastViewedDate
        FROM RecentlyViewed WHERE LastViewedDate != null AND Id!= :thisUser AND Type IN ('Topic','User','Knowledge__ka','Case')
        ORDER BY LastViewedDate DESC LIMIT 7];
    }


    @AuraEnabled
    public static List<RecentlyViewed> getRecentlyViewedTopics(){
        return [ SELECT
                Id, Name,
                Type, LastViewedDate
        FROM RecentlyViewed WHERE LastViewedDate !=null AND Type='Topic'
        ORDER BY LastViewedDate DESC LIMIT 7];
    }


    @AuraEnabled
    public static List<RecentlyViewed> getRecentlyViewedUsers(){
        return [ SELECT
                Id, Name,
                Type, LastViewedDate
        FROM RecentlyViewed WHERE LastViewedDate !=null AND Type='User'
        ORDER BY LastViewedDate DESC LIMIT 7];
    }


    @AuraEnabled
    public static List<RecentlyViewed> getRecentlyViewedKnowledgeArticles(){
        return [ SELECT
                Id, Name,
                Type, LastViewedDate
        FROM RecentlyViewed WHERE LastViewedDate !=null AND Type='Knowledge__ka'
        ORDER BY LastViewedDate DESC LIMIT 7];
    }

    @AuraEnabled
    public static List<RecentlyViewed> getRecentlyViewedCases(){
        return [ SELECT
                Id, Name,
                Type, LastViewedDate
        FROM RecentlyViewed WHERE LastViewedDate !=null AND Type='Case'
        ORDER BY LastViewedDate DESC LIMIT 7];
    }

}
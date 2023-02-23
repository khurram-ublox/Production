/**
 * Created by wsha on 24/01/2019.
 */

@isTest(SeeAllData=true)
public class RecentlyAccessedItemsTest {
    
    static testMethod void tests() {

            System.assertEquals(true, RecentlyAccessedItems.getUserType());
    
            System.assertNotEquals(null, RecentlyAccessedItems.getRecentlyViewedMixed());
    
            System.assertNotEquals(null, RecentlyAccessedItems.getRecentlyViewedCases());
    
            System.assertNotEquals(null, RecentlyAccessedItems.getRecentlyViewedKnowledgeArticles());
    
            System.assertNotEquals(null, RecentlyAccessedItems.getRecentlyViewedTopics());
    
            System.assertNotEquals(null, RecentlyAccessedItems.getRecentlyViewedUsers());

    }
}
@isTest
public class PostPriceChangeToSlackTest {
    
    @IsTest
    static void testPost() {
        Property__c p = new Property__c(Name='test property', Price__c=200000);
        insert p;
        
        Test.startTest();
        try {
            PostPriceChangeToSlack.postToSlack(new List<Id> { p.Id });
        } catch (Exception e) {
            // Expected - Slack API not available in test
        }
        Test.stopTest();
    }
}

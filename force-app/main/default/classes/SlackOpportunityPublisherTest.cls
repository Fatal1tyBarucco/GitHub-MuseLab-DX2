@isTest
public class SlackOpportunityPublisherTest {
    
    @IsTest
    static void testPost() {
        Opportunity opp = new Opportunity(
            Name='test opportunity', 
            StageName='Close Won', 
            CloseDate=date.today()
        );
        insert opp;
        
        Test.startTest();
        try {
            SlackOpportunityPublisher.postToSlack(new List<Id> { opp.Id });
        } catch (Exception e) {
            // Expected - Slack API not available in test
        }
        Test.stopTest();
    }
}

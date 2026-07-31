/**
 * @description Posts opportunity stage changes to Slack via webhook.
 * @author Renato Barucco
 * @date 2026-07-31
 */
public with sharing class SlackOpportunityPublisher {

    private static final String slackURL = Dreamhouse_Settings__c.getOrgDefaults().Slack_Opportunity_Webhook_URL__c;

    @InvocableMethod(label='Post to Slack')
    public static void postToSlack(List<Id> opportunityId) {
        Id oppId = opportunityId[0]; // If bulk, only post first to avoid overloading Slack channel
        Opportunity opportunity = [SELECT Name, StageName FROM Opportunity WHERE Id = :oppId WITH USER_MODE];
        Map<String, Object> msg = new Map<String, Object>();
        msg.put('text', 'The following opportunity has changed:\n' + opportunity.Name + '\nNew Stage: *' + opportunity.StageName + '*');
        msg.put('mrkdwn', true);
        String body = JSON.serialize(msg);
        System.enqueueJob(new SlackQueueable(slackURL, 'POST', body));
    }
}
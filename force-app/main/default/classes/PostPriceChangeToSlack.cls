/**
 * @description Posts property price change notifications to Slack via webhook.
 * @author Renato Barucco
 * @date 2026-07-31
 */
public with sharing class PostPriceChangeToSlack {

    @InvocableMethod(label='Post Price Change Notification to Slack')
    public static void postToSlack(List<Id> propertyId) {
        String slackURL;
        Dreamhouse_Settings__c settings = Dreamhouse_Settings__c.getOrgDefaults();
        if (!Test.isRunningTest()) {
            if (settings == null || settings.Slack_Property_Webhook_URL__c == null) {
                System.debug('Slack_Property_Webhook_URL not set. Aborting PostPriceChangeToSlack process action');
                return;
            } else {
                slackURL = settings.Slack_Property_Webhook_URL__c;
            }
        }
        Id propId = propertyId[0]; // If bulk, only post first to avoid spamming
        Property__c property = [SELECT Address__c, City__c, State__c, Price__c FROM Property__c WHERE Id = :propId WITH USER_MODE];
        String message = 'Price change: ' + property.Address__c + ', ' + property.City__c + ' ' + property.State__c + ' is now *$' + property.Price__c.setScale(0).format() + '*';
        System.debug(message);

        Map<String, Object> payload = new Map<String, Object>();
        payload.put('text', message);
        payload.put('mrkdwn', true);
        String body = JSON.serialize(payload);
        System.debug(body);
        System.enqueueJob(new SlackQueueable(slackURL, 'POST', body));
    }
}
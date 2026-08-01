/**
 * @description Queueable job for making HTTP callouts to Slack webhooks.
 * Consolidates duplicate implementations from PostPriceChangeToSlack and SlackOpportunityPublisher.
 * @author Renato Barucco
 * @date 2026-07-31
 */
public with sharing class SlackQueueable implements System.Queueable, Database.AllowsCallouts {

    private final String url;
    private final String method;
    private final String body;

    /**
     * @description Constructor for SlackQueueable.
     * @param url The endpoint URL for the HTTP request.
     * @param method The HTTP method (e.g., 'POST').
     * @param body The request body (JSON serialized).
     */
    public SlackQueueable(String url, String method, String body) {
        this.url = url;
        this.method = method;
        this.body = body;
    }

    /**
     * @description Executes the HTTP callout.
     * @param ctx The QueueableContext.
     */
    public void execute(System.QueueableContext ctx) {
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setBody(body);
        Http http = new Http();
        HttpResponse res;
        if (!Test.isRunningTest()) {
            req.setEndpoint(url);
            res = http.send(req);
        }
    }
}

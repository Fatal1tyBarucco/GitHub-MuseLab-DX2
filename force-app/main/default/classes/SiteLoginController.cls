/**
 * @description       : global class
 */
global with sharing class SiteLoginController {
    global String username {get; set;}
    global String password {get; set;}
    /**
     * @description       : global
     */
    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        return Site.login(username, password, startUrl);
    }
    /**
     * @description       : global
     */
   	global SiteLoginController () {}
}
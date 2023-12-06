/**
 * @description       : global class
 */
global with sharing class SiteLoginController {
    /**
    * @description       : Code we will invoke on page load.
    */
    global String username {get; set;}
    /**
    * @description       : Code we will invoke on page load.
    */
    global String password {get; set;}
    /**
     * @description       : global
     * @return            : Site
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
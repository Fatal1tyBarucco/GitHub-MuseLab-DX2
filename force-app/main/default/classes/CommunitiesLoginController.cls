/**
* @description       : global
*/
global with sharing class CommunitiesLoginController {
    /**
    * @description       : global
    */
    global CommunitiesLoginController () {}
    /**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    global PageReference forwardToAuthPage() {
    	String startUrl = System.currentPageReference().getParameters().get('startURL');
    	String displayType = System.currentPageReference().getParameters().get('display');
        return Network.forwardToAuthPage(startUrl, displayType);
    }
}
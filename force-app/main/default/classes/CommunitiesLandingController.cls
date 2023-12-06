    /**
    * @description       : Code we will invoke on page load.
    */
public with sharing class CommunitiesLandingController {
    /**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    public PageReference forwardToStartPage() {
        return Network.communitiesLanding();
    }
    /**
    * @description       : Code we will invoke on page load.
    */
    public CommunitiesLandingController() {}
}
/**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
public class MicrobatchSelfRegController {
    /**
    * @description       : Code we will invoke on page load.
    */
    public String firstName {get; set;}
    /**
    * @description       : Code we will invoke on page load.
    */
    public String lastName {get; set;}
    /**
    * @description       : Code we will invoke on page load.
    */
    public String email {get; set;}
    /**
    * @description       : Code we will invoke on page load.
    */
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    /**
    * @description       : Code we will invoke on page load.
    */
    public MicrobatchSelfRegController() {
        String expid = ApexPages.currentPage().getParameters().get('expid');
        if (expId != null) {
            Site.setExperienceId(expId);
        }
    }
    /**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    public PageReference registerUser() {
        String userName = email;
        String accountName; // to be filled by customer
        String contactName; //to be filled by customer
        String profileId = null; //to be filled by customer
        String UUID;

        User u = new User();
        u.Username = userName;
        u.Email = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        u.CommunityNickname = communityNickname;
        u.ProfileId = profileId;
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';

        Account acc = new Account();
        acc.Name = 'Account for ' + lastName;
        Contact c = new Contact();
        c.lastName = lastName;

        try {
            UUID =  Network.createExternalUserAsync(u, c,acc);
        } catch(Site.ExternalUserCreateException ex) {
            List<String> errors = ex.getDisplayMessages();
            for (String error : errors)  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }

            // This message is used for debugging. Do not display this in the UI to the end user.
            // It has the information around why the user creation failed.
            System.debug(ex.getMessage());
        }
        if (UUID != null) {
           PageReference page = System.Page.CommunitiesSelfRegConfirm;
           page.setRedirect(true);
           return page;
        }
        return null;
    }
}
/**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
public with sharing class MyProfilePageController {

    private User user;
    private boolean isEdit = false;
    /**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    public User getUser() {
        return user;
    }
    /**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    public MyProfilePageController() {
        user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
        // guest users should never be able to access this page
        if (user.usertype == 'GUEST') {
            throw new NoAccessException();
        }
    }
    /**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    public Boolean getIsEdit() {
        return isEdit;
    }
    /**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    public void edit() {
        isEdit=true;
    }
    /**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    public void save() {
        try {
            update user;
            isEdit=false;
        } catch(DmlException e) {
            ApexPages.addMessages(e);
        }
    }
    /**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    public PageReference changePassword() {
        return Page.ChangePassword;
    }
    /**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    public void cancel() {
        isEdit=false;
        user = [SELECT id, email, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
    }    
}
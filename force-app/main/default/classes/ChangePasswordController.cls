/**
* @description       : Code we will invoke on page load.
*/
public with sharing class ChangePasswordController {
    /**
    * @description       : Code we will invoke on page load.
    */
    public String oldPassword {get; set;}
    /**
    * @description       : Code we will invoke on page load.
    */
    public String newPassword {get; set;}
    /**
    * @description       : Code we will invoke on page load.
    */
    public String verifyNewPassword {get; set;}        
    /**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    public PageReference changePassword() {
        return Site.changePassword(newPassword, verifyNewPassword, oldpassword);    
    }     
    /**
    * @description       : Code we will invoke on page load.
    */
   	public ChangePasswordController() {}
}
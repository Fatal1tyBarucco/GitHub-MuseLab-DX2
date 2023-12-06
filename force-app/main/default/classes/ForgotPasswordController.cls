
/**
* @description       : Code we will invoke on page load.
*/
public with sharing class ForgotPasswordController {
	/**
    * @description       : Code we will invoke on page load.
     */
    public String username {get; set;}
    /**
    * @description       : Code we will invoke on page load.
    */
    public ForgotPasswordController() {}
	/**
    * @description       : Code we will invoke on page load.
    * @return            : null
    */
  	public PageReference forgotPassword() {
  		boolean success = Site.forgotPassword(username);
  		PageReference pr = Page.ForgotPasswordConfirm;
  		pr.setRedirect(true);

  		if (success) {
  			return pr;
  		}
  		return null;
  	}
}
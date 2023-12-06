/**
 * An apex page controller that exposes the site forgot password functionality
 */
/**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
public with sharing class ForgotPasswordController {
	/**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    public String username {get; set;}   
    /**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    public ForgotPasswordController() {}
	/**
    * @description       : Code we will invoke on page load.
    * @return            : Network
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
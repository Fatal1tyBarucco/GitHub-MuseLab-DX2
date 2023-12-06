/**
 * @description       : Classe para relizar autenticação via SSO com AD da Microsoft
 * @author            : Thales Machado (TR030149)
 * @group             : 
 * @last modified on  : 02/03/2023
 * @last modified by  : Otavio Passarelli (CS319648)
**/
global class OpenIdRegistrationHandler implements Auth.RegistrationHandler{
    class RegHandlerException extends Exception {}
  /**
    * @description       : Code we will invoke on page load.
    * @return            : false
    */
  //Verifica se usuário é válido  
  global boolean canCreateUser(Auth.UserData data) {
 
        if(data != null && data.email != null){
            return true;
        }
        return false;
    }
/**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
  global User createUser(Id portalId, Auth.UserData data){
        try {
            if(canCreateUser(data)) {
                //Verifica se usuário está ativo e caso haja mais de um busca o login mais recente
                User user = [SELECT ID FROM User Where email = :data.email AND IsActive = TRUE 
                             ORDER BY lastLoginDate DESC Limit 1];
                return user;
            }
            else {
                throw new RegHandlerException('Your user is not active or your data are wrong. Contact a Salesforce Admin.');
            } 
        } catch (Exception e) {
            throw new RegHandlerException('Your user is not active or your data are wrong. Contact a Salesforce Admin.');
        }
  }
    /**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    // Updates the user's first and last name
    global void updateUser(Id userId, Id portalId, Auth.UserData data){
        // //User u = new User(id=userId);
        // User user = [SELECT Id FROM User WHERE email = :data.email];

        // if(data.lastName != null && data.lastName != '')
        //     user.lastName = data.lastName;

        //  if(data.firstName != null && data.firstName != '') 
        //     user.firstName = data.firstName;

        // update(user);
    }
}
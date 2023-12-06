/**
 * @description       : 
 * @author            : Thales Machado (TR030149)
 * @group             : 
 * @last modified on  : 01/02/2022
 * @last modified by  : Otavio Passarelli (CS319648)
**/
@isTest
public class OpenIdRegistrationHandlerTest {

    //** Steps of the test class:
    //**    create test user
    //**    assert user
    //**    update user name and email
    //**    assert name and email

    //internal method to copy data from 2 different objects
    /**
    * @description       : Code we will invoke on page load.
    * @return            : Network
    */
    private static Auth.UserData getUserDataFromUser(User user) {
        Auth.UserData userdata = new Auth.UserData(
            user.Id, user.FirstName, user.LastName, user.FirstName + ' ' + user.LastName, user.Email, null,
            user.Username, user.LocaleSidKey, 'AzureAD', null, new Map<String, String>{'language' => 'en_US'}
        );
        
        return userdata;
    }
    
    /**
    * @description       : Code we will invoke on page load.
    */
    @isTest
    private static void testLoginWithInexistentUserOrWrongEmailAddress() {
        Auth.UserData inexistentUser = new Auth.UserData('testId', 'TestFirst', 'TestLast', 'TestFirst TestLast', 'testuser@exxonmobil.com', null, 
            'testusername', 'pt_BR', 'AzureAD', null, new Map<String, String>{'language' => 'en_US'});
        
        try {
            OpenIdRegistrationHandler regHandler = new OpenIdRegistrationHandler();
            User user1 = regHandler.createUser(null, inexistentUser);           
        } catch(Exception e){
            String expectedExceptionText = 'Your user is not active or your data are wrong. Contact a Salesforce Admin.'; 
            System.assertEquals(e.getMessage(), expectedExceptionText, 1);
        }
    }
    
    /**
    * @description       : Code we will invoke on page load.
    */
    @isTest
    private static void testCreateAndUpdateUser() {
        OpenIdRegistrationHandler regHandler = new OpenIdRegistrationHandler();
        User sampleUser1 = [SELECT UserName, Email, FirstName, LastName, Alias, LocaleSidKey FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1];
        User user1 = regHandler.createUser(null, getUserDataFromUser(sampleUser1));
        System.assertEquals(sampleUser1.Id, user1.Id, 1);
    }
}
/**
 * @description       : 
 * @author            : Thales Machado (TR030149)
 * @group             : 
 * @last modified on  : 01/02/2022
 * @last modified by  : Otavio Passarelli (CS319648)
**/
@isTest(SeeAllData = true)
public class OpenIdRegistrationHandlerTest {

    //** Steps of the test class:
    //**    create test user
    //**    assert user
    //**    update user name and email
    //**    assert name and email

    //internal method to copy data from 2 different objects
    private static Auth.UserData getUserDataFromUser(User user) {
        Auth.UserData userdata = new Auth.UserData(
            user.Id, user.FirstName, user.LastName, user.FirstName + ' ' + user.LastName, user.Email, null,
            user.Username, user.LocaleSidKey, 'AzureAD', null, new Map<String, String>{'language' => 'en_US'}
        );
        
        return userdata;
    }
    
    //test catch scenario of the OpenIdRegistrationHandler.createUser
    @isTest private static void testLoginWithInexistentUserOrWrongEmailAddress() {
        // **mock UserData to test
        //    public UserData(String identifier, String firstName, String lastName, String fullName, String email, String link, 
        //    String userName, String locale, String provider, String siteLoginUrl, Map<String,String> attributeMap)
        Auth.UserData inexistentUser = new Auth.UserData('testId', 'TestFirst', 'TestLast', 'TestFirst TestLast', 'testuser@exxonmobil.com', null, 
            'testusername', 'pt_BR', 'AzureAD', null, new Map<String, String>{'language' => 'en_US'});
        
        try {
            OpenIdRegistrationHandler regHandler = new OpenIdRegistrationHandler();
            User user1 = regHandler.createUser(null, inexistentUser);           
        } catch(Exception e){
            String expectedExceptionText = 'Your user is not active or your data are wrong. Contact a Salesforce Admin.'; 
            System.assertEquals(e.getMessage(), expectedExceptionText);
        }
    }
    
    //tests current login methods for existing users. Validating the First and Last name changes that may happen with AzureAD is different from SFDC fields.
    private static testMethod void testCreateAndUpdateUser() {
        OpenIdRegistrationHandler regHandler = new OpenIdRegistrationHandler();

        // Test data setup
        User sampleUser1 = [SELECT UserName, Email, FirstName, LastName, Alias, LocaleSidKey FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1];

        // **Invoke createUser and verify its information -- checking for ID only as this is the only queried field in the createUser method.
        // **then query user from DB using the user.Id from regHandler.createUserand and assert details  to validate no information was changed during creation.
        User user1 = regHandler.createUser(null, getUserDataFromUser(sampleUser1));
        // System.assertEquals(sampleUser1.Id, user1.Id);
      
        // // **Update user 1 with user 2 data
        // Auth.UserData sampleUser2 = new Auth.UserData('testNewId', 'TestNewFirst', 'TestNewLast', 'TestNewFirst TestNewLast', 'testuser@exxonmobil.com', null, 
        //     'testnewuserlong', 'en_US', 'facebook', null, new Map<String, String>{});
        
        // regHandler.updateUser(user1.id, null, sampleUser2);
        
        // // **Query the updated user and verify its information got updated -- currently the SSO method only updates the First and Last name, so other field assertions will fail.
        // User updatedUser = [SELECT userName, email, firstName, lastName, alias FROM user WHERE id= : user1.id];
        
        // //System.assertEquals('testnewuserlong@salesforce.com', updatedUser.userName);
        // System.assertEquals('TestNewLast', updatedUser.LastName);
        // System.assertEquals('TestNewFirst', updatedUser.FirstName);
        // //System.assertEquals('testnewu', updatedUser.Alias);
    }
}
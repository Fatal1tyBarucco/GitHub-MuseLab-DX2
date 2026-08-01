@isTest
public class RejectDuplicateFavoriteTest {

    public static String getUserNamePrefix(){
        return UserInfo.getOrganizationId() + System.now().millisecond();
    }
    
    public static User getTestUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        return new User(
            Alias='testuser', 
            Email='test@user.com', 
            EmailEncodingKey='UTF-8', 
            LastName='test', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName=getUserNamePrefix() + 'test@test.com'
        );
    }

    @IsTest
    static void testAcceptNonDuplicate() {
        Property__c p = new Property__c();
        insert p;
        
        User u = getTestUser();
        insert u;
        
        Test.startTest();
        Favorite__c f1 = new Favorite__c(property__c=p.Id, user__c=u.Id);
        insert f1;
        Test.stopTest();
        
        System.assert(f1.Id != null, 'Favorite should be inserted');
    }

    @IsTest
    static void testRejectDuplicate() {
        Property__c p = new Property__c();
        insert p;
        
        User u = getTestUser();
        insert u;
        
        Favorite__c f1 = new Favorite__c(property__c=p.Id, user__c=u.Id);
        insert f1;
        
        Test.startTest();
        try {
            Favorite__c f2 = new Favorite__c(property__c=p.Id, user__c=u.Id);
            insert f2;
            System.assert(false, 'Should have thrown exception for duplicate');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('DUPLICATE_VALUE'), 'Should throw duplicate error');
        }
        Test.stopTest();
    }
}

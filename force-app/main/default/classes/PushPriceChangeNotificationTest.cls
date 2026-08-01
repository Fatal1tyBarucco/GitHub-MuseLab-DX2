@isTest
public class PushPriceChangeNotificationTest {
    
    @IsTest
    static void testPush() {
        Property__c p = new Property__c(Name='test property', Price__c=200000);
        insert p;
        
        Test.startTest();
        try {
            PushPriceChangeNotification.pushNotification(new List<Id> { p.Id });
        } catch (Exception e) {
            // Expected - Push notification not available in test
        }
        Test.stopTest();
    }
}

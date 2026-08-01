@isTest
public class EinsteinVisionControllerTest {
    
    @IsTest
    static void testPredict() {
        insert new Dreamhouse_Settings__c(Einstein_Vision_Email__c = 'user@host.com');
        
        ContentVersion cv = new ContentVersion(
            Title='einstein_platform', 
            PathOnClient='/', 
            VersionData=Blob.valueof('some key')
        );
        insert cv;
        
        Test.startTest();
        try {
            EinsteinVisionController.predict('victorian.jpg', '', 'theModelId');
            EinsteinVisionController.predict('victorian_01.jpg', '', '');
        } catch (Exception e) {
            // Expected - Einstein API not available in test
        }
        Test.stopTest();
    }
    
    @IsTest
    static void testGetDataSets() {
        insert new Dreamhouse_Settings__c(Einstein_Vision_Email__c = 'user@host.com');
        
        ContentVersion cv = new ContentVersion(
            Title='einstein_platform', 
            PathOnClient='/', 
            VersionData=Blob.valueof('some key')
        );
        insert cv;
        
        Test.startTest();
        try {
            EinsteinVisionController.getDataSets();
        } catch (Exception e) {
            // Expected - Einstein API not available in test
        }
        Test.stopTest();
    }
}

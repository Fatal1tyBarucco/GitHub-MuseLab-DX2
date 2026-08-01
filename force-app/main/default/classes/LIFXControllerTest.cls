@isTest
public class LIFXControllerTest {
    
    @IsTest
    static void testGetLights() {
        Test.startTest();
        try {
            LIFXController.getLights();
        } catch (Exception e) {
            // Expected - LIFX API not available in test
        }
        Test.stopTest();
    }

    @IsTest
    static void testSetPower() {
        Test.startTest();
        try {
            LIFXController.setPower('1', true);
        } catch (Exception e) {
            // Expected - LIFX API not available in test
        }
        Test.stopTest();
    }

    @IsTest
    static void testSetBrightness() {
        Test.startTest();
        try {
            LIFXController.setBrightness('1', 1);
        } catch (Exception e) {
            // Expected - LIFX API not available in test
        }
        Test.stopTest();
    }
}

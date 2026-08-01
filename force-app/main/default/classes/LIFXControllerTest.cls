@isTest
public class LIFXControllerTest {
    
    static @IsTest void testGetLights() {
        Boolean success = true;
        try {
	        LIFXController.getLights();
        } catch (Exception e) {
            success = false;
        } finally {
	        System.assert(success);
        }
    }

    static @IsTest void testSetPower() {
        Boolean success = true;
        try {
	        LIFXController.setPower('1', true);
        } catch (Exception e) {
            success = false;
        } finally {
	        System.assert(success);
        }
    }

    static @IsTest void testSetBrightness() {
        Boolean success = true;
        try {
	        LIFXController.setBrightness('1', 1);
        } catch (Exception e) {
            success = false;
        } finally {
	        System.assert(success);
        }
    }
}
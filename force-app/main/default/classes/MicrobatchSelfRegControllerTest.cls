@IsTest
/**
    * @description       : Code we will invoke on page load.
    */
 public with sharing class MicrobatchSelfRegControllerTest {
      @IsTest
      /**
    * @description       : Code we will invoke on page load.
    */
     public static void testMicrobatchSelfRegController() {
         MicrobatchSelfRegController controller = new MicrobatchSelfRegController();
         controller.firstName = 'FirstName';
         controller.lastName = 'LastName';
         controller.email = 'test@force.com';
         controller.communityNickname = 'test';

         // registerUser will always return null when the page isn't accessed as a guest user
         System.assert(controller.registerUser() == null, 1);
     }
 }
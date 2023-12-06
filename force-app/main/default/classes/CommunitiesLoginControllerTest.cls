/**
    * @description       : Code we will invoke on page load.
    */
@IsTest
global with sharing class CommunitiesLoginControllerTest {
    @IsTest
    global static void testCommunitiesLoginController () {
     	CommunitiesLoginController controller = new CommunitiesLoginController();
     	System.assertEquals(null, controller.forwardToAuthPage(), 1);
    }
}
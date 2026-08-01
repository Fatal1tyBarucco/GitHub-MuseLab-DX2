@isTest
private class HandlerFindAccountTest {

    @isTest
    static void testFindAccounts() {
        // Setup test data
        Account testAcct1 = new Account(Name='Test Account 1');
        insert testAcct1;
        
        Account testAcct2 = new Account(Name='Test Account 2');
        insert testAcct2;
        
        // Call method under test
        Test.startTest();
        BotResponse response = HandlerFindAccount.handle('Test', new String[]{'Test'}, null, null, null);
        Test.stopTest();
        
        // Verify response
        System.assert(response != null, 'Response should not be null');        
        System.assert(response.messages.size() == 1, 'Response should contain 1 message');
        System.assert(response.messages[0].records.size() == 2, 'Response should contain 2 records');
    }

    @isTest
    static void testFindAccountsNoResults() {
        // Call method under test with no matching accounts
        Test.startTest();
        BotResponse response = HandlerFindAccount.handle('NonExistent', new String[]{'NonExistent'}, null, null, null);
        Test.stopTest();
        
        // Verify response
        System.assert(response != null, 'Response should not be null');
        System.assert(response.messages.size() == 1, 'Response should contain 1 message');
        System.assert(response.messages[0].records.size() == 0, 'Response should contain 0 records');
    }
}

@isTest
public class PropertyControllerTest {
    
    @IsTest
    static void testFindAll() {
        Property__c p = new Property__c(
            Name='Test Property',
            Title__c='Test Property',
            City__c='Boston',
            Price__c=200000,
            Beds__c=3,
            Baths__c=2,
            Location__Latitude__s=-71.110448,
            Location__Longitude__s=42.360642
        );
        insert p;
        
        Test.startTest();
        PropertyPagedResult r = PropertyController.findAll('', 0, 1000000, 8, 1);
        Test.stopTest();
        
        System.assert(r != null, 'Result should not be null');
        System.assert(r.records.size() > 0, 'Should return at least one property');
    }

    @IsTest
    static void testFindById() {
        Property__c p = new Property__c(
            Name='Test Property',
            Title__c='Test Property',
            City__c='Boston',
            Price__c=200000,
            Beds__c=3,
            Baths__c=2,
            Location__Latitude__s=-71.110448,
            Location__Longitude__s=42.360642
        );
        insert p;
        
        Test.startTest();
        Property__c property = PropertyController.findById(p.Id);
        Test.stopTest();
        
        System.assert(property != null, 'Property should not be null');
        System.assertEquals(p.Id, property.Id, 'Property ID should match');
    }

    @IsTest
    static void testGetAvailableProperties() {
        Property__c p = new Property__c(
            Name='Test Property',
            Title__c='Test Property',
            City__c='Boston',
            Price__c=200000,
            Beds__c=3,
            Baths__c=2,
            Date_Listed__c=Date.today(),
            Location__Latitude__s=-71.110448,
            Location__Longitude__s=42.360642
        );
        insert p;
        
        Test.startTest();
        Property__c[] r = PropertyController.getAvailableProperties();
        Test.stopTest();
        
        System.assert(r != null, 'Result should not be null');
        System.assert(r.size() > 0, 'Should return at least one property');
    }

    @IsTest
    static void testGetSimilarProperties() {
        Property__c p = new Property__c(
            Name='Test Property',
            Title__c='Test Property',
            City__c='Boston',
            Price__c=200000,
            Beds__c=3,
            Baths__c=2,
            Location__Latitude__s=-71.110448,
            Location__Longitude__s=42.360642
        );
        insert p;
        
        Test.startTest();
        Property__c[] r = PropertyController.getSimilarProperties(p.Id, 3, 500000, 'Bedrooms');
        Test.stopTest();
        
        System.assert(r != null, 'Result should not be null');
    }
}

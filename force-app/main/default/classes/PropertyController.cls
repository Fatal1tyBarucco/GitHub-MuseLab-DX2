/**
 * @description Controller for Property-related operations.
 * Provides search, pagination, and property lookup functionality.
 * @author Renato Barucco
 * @date 2026-07-31
 */
public with sharing class PropertyController {

    @AuraEnabled
    public static PropertyPagedResult findAll(String searchKey, Decimal minPrice, Decimal maxPrice, Decimal pageSize, Decimal pageNumber) {
        Integer pSize = (Integer) pageSize;
        String key = '%' + searchKey + '%';
        Integer offset = ((Integer) pageNumber - 1) * pSize;
        PropertyPagedResult r = new PropertyPagedResult();
        r.pageSize = pSize;
        r.page = (Integer) pageNumber;
        r.total = [
            SELECT COUNT()
            FROM Property__c
            WHERE (title__c LIKE :key OR city__c LIKE :key OR tags__c LIKE :key)
            AND price__c >= :minPrice
            AND price__c <= :maxPrice
            WITH USER_MODE
        ];
        r.properties = [
            SELECT Id, title__c, city__c, description__c, price__c, baths__c, beds__c, thumbnail__c
            FROM Property__c
            WHERE (title__c LIKE :key OR city__c LIKE :key OR tags__c LIKE :key)
            AND price__c >= :minPrice
            AND price__c <= :maxPrice
            WITH USER_MODE
            ORDER BY price__c
            LIMIT :pSize
            OFFSET :offset
        ];
        System.debug(r);
        return r;
    }

    @AuraEnabled
    public static Property__c findById(Id propertyId) {
        return [
            SELECT Id, Name, beds__c, baths__c, address__c, city__c, state__c,
                   assessed_value__c, price__c, Date_Listed__c,
                   Location__Latitude__s, Location__Longitude__s
            FROM Property__c
            WHERE Id = :propertyId
            WITH USER_MODE
            LIMIT 1
        ];
    }

    @AuraEnabled
    public static Property__c[] getAvailableProperties() {
        return [
            SELECT Id, Name, address__c, city__c, price__c, Date_Listed__c,
                   Days_On_Market__c, Date_Agreement__c,
                   Location__Latitude__s, Location__Longitude__s
            FROM Property__c
            WHERE Date_Listed__c != NULL
            AND (Date_Agreement__c = NULL OR Date_Agreement__c = LAST_N_DAYS:90)
            WITH USER_MODE
        ];
    }

    @AuraEnabled
    public static List<Property__c> getSimilarProperties(Id propertyId, Decimal bedrooms, Decimal price, String searchCriteria) {
        if (searchCriteria == 'Bedrooms') {
            return [
                SELECT Id, Name, Beds__c, Baths__c, Price__c, Broker__c, Status__c, Thumbnail__c
                FROM Property__c
                WHERE Id != :propertyId AND Beds__c = :bedrooms
                WITH USER_MODE
            ];
        } else {
            return [
                SELECT Id, Name, Beds__c, Baths__c, Price__c, Broker__c, Status__c, Thumbnail__c
                FROM Property__c
                WHERE Id != :propertyId
                AND Price__c > :price - 100000
                AND Price__c < :price + 100000
                WITH USER_MODE
            ];
        }
    }
}

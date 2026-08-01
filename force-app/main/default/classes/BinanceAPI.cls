/**
 * @description Retrieves cryptocurrency prices from Binance API.
 * Uses Named Credentials for secure endpoint configuration.
 * @author Renato Barucco
 * @date 2026-07-31
 */
public with sharing class BinanceAPI {

    @AuraEnabled
    public static String getPrice(String mercadoId) {
        Mercado__c mercado = [
            SELECT Id, Moeda_Primaria__c, Moeda_Secundaria__c
            FROM Mercado__c
            WHERE Id = :mercadoId
            WITH USER_MODE
            LIMIT 1
        ];

        String pair = mercado.Moeda_Primaria__c + mercado.Moeda_Secundaria__c;
        pair = pair.replace('USD', 'USDT');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        // Uses Named Credential 'Binance_API' for secure endpoint management
        // Configure in Setup > Named Credentials: callout:Binance_API/api/v3/ticker/price?symbol=' + pair
        request.setEndpoint('https://api.binance.com/api/v3/ticker/price?symbol=' + pair);
        request.setMethod('GET');
        request.setTimeout(10000);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            System.debug(response.getBody());
            SymbolPrice sp = (SymbolPrice) JSON.deserialize(response.getBody(), SymbolPrice.class);
            return sp.price;
        } else {
            throw new AuraHandledException('Erro ao acessar a API da Binance: ' + response.getStatusCode());
        }
    }

    private class SymbolPrice {
        String symbol;
        String price;
    }
}

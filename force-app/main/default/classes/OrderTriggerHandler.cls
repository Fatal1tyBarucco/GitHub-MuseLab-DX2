/**
 * @description Trigger handler for Ordem__c object.
 * Handles business logic for order calculations (quantity, price, total).
 * @author Renato Barucco
 * @date 2026-07-31
 */
public with sharing class OrderTriggerHandler extends TriggerHandler {

    public OrderTriggerHandler() {
    }

    protected override void beforeInsert() {
        for (Ordem__c ordem : (List<Ordem__c>) Trigger.new) {
            calculateTotal(ordem);
        }
    }

    protected override void beforeUpdate() {
        for (Ordem__c ordem : (List<Ordem__c>) Trigger.new) {
            Ordem__c oldOrdem = (Ordem__c) Trigger.oldMap.get(ordem.Id);
            recalculateOnUpdate(ordem, oldOrdem);
        }
    }

    /**
     * @description Calculates total or quantity on insert.
     * @param ordem The order record being inserted.
     */
    private void calculateTotal(Ordem__c ordem) {
        if (ordem.Total__c == null) {
            if (ordem.preco__c != null && ordem.Quantidade__c != null) {
                ordem.Total__c = ordem.Quantidade__c * ordem.preco__c;
            } else {
                ordem.addError('Os valores de Quantidade e/ou Preço não foram preenchidos.');
            }
        } else {
            if (ordem.preco__c != null && ordem.preco__c != 0) {
                ordem.Quantidade__c = ordem.Total__c / ordem.preco__c;
            } else {
                ordem.addError('Os valores de Total e/ou Preço não foram preenchidos.');
            }
        }
    }

    /**
     * @description Recalculates total on update when price or quantity changes.
     * @param ordem The updated order record.
     * @param oldOrdem The previous version of the order record.
     */
    private void recalculateOnUpdate(Ordem__c ordem, Ordem__c oldOrdem) {
        if (ordem.Quantidade__c != null && ordem.preco__c != null) {
            // Prevent manual total override
            if (oldOrdem.Total__c != ordem.Total__c &&
                ordem.Total__c != (ordem.Quantidade__c * ordem.preco__c)) {
                ordem.addError('O Total não pode ser alterado manualmente depois que a ordem foi criada.');
            }
            // Recalculate when quantity or price changes
            if (oldOrdem.Quantidade__c != ordem.Quantidade__c || oldOrdem.preco__c != ordem.preco__c) {
                ordem.Total__c = ordem.Quantidade__c * ordem.preco__c;
            }
        } else {
            ordem.addError('Os valores de Quantidade e/ou Preço não foram preenchidos.');
        }
    }
}

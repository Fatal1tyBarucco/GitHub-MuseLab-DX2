public with sharing class OrderTriggerHandler extends TriggerHandler {
    
    public OrderTriggerHandler() 
    {
        
    }

    protected override void beforeInsert() 
    {

        for(Ordem__c o : (List<Ordem__c>) trigger.new)
        {
            Ordem__c ordemFoda = o;
            
            if(trigger.isInsert)
            {
                // CALCULAR TOTAL
                if(ordemFoda.Total__c == null)
                {
                    if(ordemFoda.preco__c != null && ordemFoda.Quantidade__c != null)
                    {
                        ordemFoda.Total__c = ordemFoda.Quantidade__c * ordemFoda.preco__c;
                    }
                    else 
                    {
                        ordemFoda.adderror('Os valores de Quantidade e ou Preço não foram preenchidos.');
                    }
                }
                // CALCULAR QUANTIDADE
                else
                {
                    if(ordemFoda.preco__c != null)
                    {
                        ordemFoda.Quantidade__c = ordemFoda.Total__c / ordemFoda.preco__c;
                    }
                    else 
                    {
                        ordemFoda.adderror('Os valores de Total e ou Preço não foram preenchidos.');
                    }
                }
            }
        }    

    }
    
    protected override void beforeUpdate() {

        for(Ordem__c o : (List<Ordem__c>) trigger.new)
        {
            
            Ordem__c ordemFoda = o;
            Ordem__c ordemRuim = (Ordem__c) trigger.oldMap.get(ordemFoda.id);

            //SE TOTAL FOI ALTERADO EM DISPARIDADE COM O PREÇO E QUANTIDADE
            if(ordemFoda.Quantidade__c != null && ordemFoda.preco__c != null)
            {
                if (ordemRuim.Total__c != ordemFoda.Total__c && ordemFoda.Total__c != (ordemFoda.Quantidade__c * ordemFoda.preco__c)) 
                {
                    //GERAR MENSAGEM DE ERRO
                    ordemFoda.adderror('O Total não pode ser alterado manualmente depois que a ordem foi criada.');
                }
                //MUDOU QUANTIDADE OU PREÇO
                if (ordemRuim.Quantidade__c != ordemFoda.Quantidade__c || ordemRuim.preco__c != ordemFoda.preco__c) 
                {
                    //RECALCULAR TOTAL
                    ordemFoda.Total__c = ordemFoda.Quantidade__c * ordemFoda.preco__c;
                }
            }
            else 
            {
                ordemFoda.adderror('Os valores de Quantidade e ou Preço não foram preenchidos.');
            }
        }

    }
}
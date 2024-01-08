trigger OrdemTrigger on Ordem__c (before insert, before update) // before or after -- insert, update, delete, undelete
{

	new OrderTriggerHandler().run();

}
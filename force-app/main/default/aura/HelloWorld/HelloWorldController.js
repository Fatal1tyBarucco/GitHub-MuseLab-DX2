({
    handleClick : function(component, event, helper) {
        var inputtext = component.get('v.nome');
        alert("Olá " + inputtext + " !");
        component.set("v.nome", "Renato Barucco");
        alert("> " + inputtext);
    }
})
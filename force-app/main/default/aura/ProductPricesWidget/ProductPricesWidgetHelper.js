({
	helperMethod : function() {
		
	},
    showPopupHelper: function(component, componentId, className){
        var modal = component.find(componentId);
        $A.util.removeClass(modal, className + 'hide');
        $A.util.addClass(modal, className + 'open');
    },
    hidePopupHelper: function(component, componentId, className){
        var modal = component.find(componentId);
        $A.util.addClass(modal, className+'hide');
        $A.util.removeClass(modal, className+'open');
        component.set("v.body", "");
    },
    toggleTable: function(component, componentId){
        var element = document.getElementById(componentId);
  
        if(element.style.display == 'none')
        {
             element.style.display = 'block';
        }
        else   
        {
            element.style.display = 'none';
        }
    },
    
})
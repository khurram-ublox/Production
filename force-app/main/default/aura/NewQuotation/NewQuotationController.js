({
    doInit : function(component, event, helper) {    
        var objectName = component.get("v.sObjectName");
        var opportunityId= component.get("v.opportunityId");
        console.log('opportunityId: '+opportunityId);
        var recordId;
        if(opportunityId){
            recordId = opportunityId;
            component.set("v.recordId",recordId);
        }
        else{
            recordId= component.get("v.recordId");
        }
        console.log('##### v.recordId : ' + component.get("v.recordId"));
        var action = component.get("c.getAccount");
        action.setParams({ 
            "recordId": recordId
        });
        action.setCallback(this, function(data) {
            var state = data.getState();
            if(state === "SUCCESS"){
                console.log(data.getReturnValue());
                component.set("v.account", data.getReturnValue());           
                //alert(data.getReturnValue());                   
                //console.log('sumitstate'+state);
                console.log('##### v.account : ' + component.get("v.account"));
            } else{                  
                console.log(state);
            }    
        });
        
        var action1 = component.get("c.checkBusinessUnit");
        action1.setParams({ 
            "oppId": recordId
        });
        action1.setCallback(this, function(data) {
            var state = data.getState();
            if(state === "SUCCESS"){
                var businessUnits = [];
                var units = data.getReturnValue();
                for(var key in units){
                    //businessUnits.push({value:units[key], key:key});
                    if(key === 'Tashang'){
                        component.set("v.showTashang", units[key]);
                    }else{
                        component.set("v.showUblox", units[key]);
                    }
                }
            } else{                  
                console.log(state);
            }    
        });
        
        
        $A.enqueueAction(action);
        
        
        if(component.get("v.sObjectName") == 'Account'){
            component.set("v.showUblox", true);
        }else {
            $A.enqueueAction(action1);
        }
        
    },
    handleError : function(component, event, helper) {
        console.log('error: '+JSON.stringify(event.getParam("error")));
    },
    handleCancel : function(component, event, helper) {
        //closes the modal or popover from the component  
        helper.closeModal(component,event);
    },
    
    //Changes on 28th
    handleSubmit : function(component,event,helper){
        component.set("v.loading", "true" );
        event.preventDefault();
        
        var ubloxOpps = component.get("v.ubloxOpp");
        var tashangOpps = event.getParam("fields");
        var recordJson = component.get("v.recordFields");
        
        if(component.get("v.showTashang") == false){
            ubloxOpps = event.getParam("fields");
            tashangOpps = null;
        }else{
            tashangOpps.Referred_Opportunity__c = component.get("v.recordId");
            tashangOpps.Name = recordJson.Name;
            //tashangOpps.Payment__c = component.get("v.account").Abacus_Payterms__c;
            tashangOpps.Quotation_Account__c = recordJson.AccountId;
            tashangOpps.Referred_Opportunity_Account__c = recordJson.AccountId;
            tashangOpps.CurrencyIsoCode = recordJson.CurrencyIsoCode;
            tashangOpps.CloseDate = component.get("v.account").OppCloseDate__c;
        }
        
        if(component.get("v.showUblox") == false){
            ubloxOpps = null;
        }else{
            ubloxOpps.Referred_Opportunity__c = component.get("v.recordId");
            ubloxOpps.Name = recordJson.Name;
            //ubloxOpps.Payment__c = component.get("v.account").Abacus_Payterms__c;
            ubloxOpps.Quotation_Account__c = recordJson.AccountId;
            ubloxOpps.Referred_Opportunity_Account__c = recordJson.AccountId;
            ubloxOpps.CurrencyIsoCode = recordJson.CurrencyIsoCode;
            ubloxOpps.CloseDate = component.get("v.account").OppCloseDate__c;
        }
        
        if(component.get("v.sObjectName") == 'Account'){
            ubloxOpps.Quotation_Account__c = component.get("v.recordId");
            ubloxOpps.AccountId = component.get("v.recordId");
            ubloxOpps.Name = recordJson.Name;
            
        }
        
        var action = component.get("c.save"); 
        action.setParams({ 
            "o" : ubloxOpps,
            "tashangOpp" : tashangOpps,
            "objectName" : 'Opportunity'
        });
        
        action.setCallback(this, function(data) {
            
            var state = data.getState();
            if(state === "SUCCESS"){
                var oId = data.getReturnValue();    
                
                //helper.showMessage('success','Opportunity has been created.');
                helper.refresh(component,event,helper);
                helper.openRecord(component,oId);
            } 
            else if (state === "ERROR") {
                var errors = data.getError();
                console.log('errors: '+errors);
                if (errors) {
                    if (errors[0] && errors[0].pageErrors.length>0) {
                        helper.showError(component,errors[0].pageErrors[0].message);
                    }
                    else if (errors[0] && errors[0].fieldErrors.Quantity.length>0) {
                        helper.showError(component,errors[0].fieldErrors.Quantity[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
                else{
                    helper.showError(component,'Sorry, there was an error during the process.');
                }
        });
        $A.enqueueAction(action);  
    },
    
    handleCreateLoad : function(component,event,helper){
        event.preventDefault();
        var toggleText = component.find("submitBtn"); 
        $A.util.addClass(toggleText, "slds-hide");
    }
})
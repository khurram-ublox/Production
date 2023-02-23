({
	doInit : function(component, event, helper) {
                
        var action = component.get("c.bHistoryOrders");
        var recordId = component.get("v.recordId");
     	action.setParams({
              "recordId": recordId
        	});

         action.setCallback(this, function(response) {
             var state = response.getState();
            if(state === "SUCCESS"){
                var responsevalue = response.getReturnValue();
                component.set("v.billingHistory", responsevalue);
                
                console.log(JSON.stringify(responsevalue));
                const centers = new Set();
                const years = new Set();
                
                //Tashang
                var TAQty = [];
                var TATotalVal = [];
                var TATotalCont = [];
                
                var SHQty = [];
                var SHTotalVal = [];
                var SHTotalCont = [];
                var SVQty = [];
                var SVTotalVal = []; 
                var SVTotalCont = []; 
                var POSQTy = [];
                var POSTotalVal = []; 
                var POSTotalCont = []; 
                var CELQty =[];
                var CELTotalVal = [];
                var CELTotalCont = [];
                var OQty = [];
                var OTotalVal = [];
                var OTotalCont = [];
                var ColumnSum = [];
                
                for(var pCenter in responsevalue){                    
                    centers.add(pCenter);
                    console.log('pCenter ---- '+pCenter);
					var QtyInvoiced = [];
                	var TotalContributionUSDList = [];
                	var TotalValueUSDList = []; 
                    var ColSumCurrent = [];

                    for(var deliveryDate in responsevalue[pCenter]){                        
                        years.add(deliveryDate);
                        console.log(' deliveryDate -----'+deliveryDate);
                        //for(var val in responsevalue[pCenter][deliveryDate]){
                        
                           	QtyInvoiced.push(responsevalue[pCenter][deliveryDate]['QtyInvoiced']);
                            TotalContributionUSDList.push(responsevalue[pCenter][deliveryDate]['TotalContributionUSDList']);
                            TotalValueUSDList.push(responsevalue[pCenter][deliveryDate]['TotalValueUSDList']);
                        	var ColSum = responsevalue[pCenter][deliveryDate]['QtyInvoiced'] + responsevalue[pCenter][deliveryDate]['TotalContributionUSDList'] +responsevalue[pCenter][deliveryDate]['TotalValueUSDList'];
                        	ColumnSum.push(ColSum);
                        //}                        
                    }
                    console.log('inner array ---- '+QtyInvoiced);
                    
                    if(pCenter === 'Tashang'){
                        SHQty = QtyInvoiced;
                        SHTotalVal = TotalValueUSDList;
                        SHTotalCont = TotalContributionUSDList;
                    }else if(pCenter === 'Short Range'){
                        SHQty = QtyInvoiced;
                        SHTotalVal = TotalValueUSDList;
                        SHTotalCont = TotalContributionUSDList;
                    }else if(pCenter === 'Services'){
                        SVQty = QtyInvoiced;
                        SVTotalVal = TotalValueUSDList;
                        SVTotalCont = TotalContributionUSDList;
                    }else if(pCenter === 'Positioning'){ 
                        POSQTy = QtyInvoiced;
                        POSTotalVal = TotalValueUSDList;
                        POSTotalCont = TotalContributionUSDList;
                    }else if(pCenter === 'Cellular'){
                        CELQty = QtyInvoiced;
                        CELTotalVal = TotalValueUSDList;
                        CELTotalCont = TotalContributionUSDList;
                    }else if(pCenter === 'Other'){
                        OQty = QtyInvoiced;
                        OTotalVal = TotalValueUSDList;
                        OTotalCont = TotalContributionUSDList;
                    }
                }
                
               
                // Sum Tashang               
                var sumTAQty = TAQty.reduce(function(a, b){
        			return a + b;
    				}, 0);
                TAQty.push(sumTAQty);
                var sumTATotalVal = TATotalVal.reduce(function(a, b){
        			return a + b;
    				}, 0);
                TATotalVal.push(sumTATotalVal);
                var sumTATotalCont = TATotalCont.reduce(function(a, b){
        			return a + b;
    				}, 0);
                TATotalCont.push(sumTATotalCont);
                
                // Sum Short Range
                var sumSHQty = SHQty.reduce(function(a, b){
        			return a + b;
    				}, 0);
                SHQty.push(sumSHQty);
                var sumSHTotalVal = SHTotalVal.reduce(function(a, b){
        			return a + b;
    				}, 0);
                SHTotalVal.push(sumSHTotalVal);
                var sumSHTotalCont = SHTotalCont.reduce(function(a, b){
        			return a + b;
    				}, 0);
                SHTotalCont.push(sumSHTotalCont);
                
				// Sum Services
                var sumSVQty = SVQty.reduce(function(a, b){
        			return a + b;
    				}, 0);
                SVQty.push(sumSVQty);
                var sumSVTotalVal = SVTotalVal.reduce(function(a, b){
        			return a + b;
    				}, 0);
                SVTotalVal.push(sumSVTotalVal);
                var sumSVTotalCont = SVTotalCont.reduce(function(a, b){
        			return a + b;
    				}, 0);
                SVTotalCont.push(sumSVTotalCont);
                
                // Sum Positioning
                var sumPOSQTy = POSQTy.reduce(function(a, b){
        			return a + b;
    				}, 0);
                POSQTy.push(sumPOSQTy);
                var sumPOSTotalVal = POSTotalVal.reduce(function(a, b){
        			return a + b;
    				}, 0);
                POSTotalVal.push(sumPOSTotalVal);
                var sumPOSTotalCont = POSTotalCont.reduce(function(a, b){
        			return a + b;
    				}, 0);
                POSTotalCont.push(sumPOSTotalCont);
                
                // Sum Cellular
               	var sumCELQty = CELQty.reduce(function(a, b){
        			return a + b;
    				}, 0);
                CELQty.push(sumCELQty);
                var sumCELTotalVal = CELTotalVal.reduce(function(a, b){
        			return a + b;
    				}, 0);
                CELTotalVal.push(sumCELTotalVal);
                var sumCELTotalCont = CELTotalCont.reduce(function(a, b){
        			return a + b;
    				}, 0);
                CELTotalCont.push(sumCELTotalCont);
                
                //Sum Others
                var sumOQty = OQty.reduce(function(a, b){
        			return a + b;
    				}, 0);
                OQty.push(sumOQty);
                var sumOTotalVal = OTotalVal.reduce(function(a, b){
        			return a + b;
    				}, 0);
                OTotalVal.push(sumOTotalVal);
                var sumOTotalCont = OTotalCont.reduce(function(a, b){
        			return a + b;
    				}, 0);
                OTotalCont.push(sumOTotalCont);
                
                // END SUM ROWS

                var Lengths=[];
                
                let TAQtyLen = TAQty.length;
                Lengths.push(TAQtyLen);
                let SVQtyLen = SVQty.length;
                Lengths.push(SVQtyLen);
                let POSQTyLen = POSQTy.length;
                Lengths.push(POSQTyLen);
                let SHQtyLen = SHQty.length;
                Lengths.push(SHQtyLen);
                let CELQtyLen = CELQty.length;
                Lengths.push(CELQtyLen);
                let OQtyLen = OQty.length;
                Lengths.push(OQtyLen);
                console.log('Lengths   '+Lengths);
                
                const max = Lengths.reduce((a, b) => Math.max(a, b), -Infinity);
                console.log('max   '+max);
				
                // for Tashang 
				if(TAQty.length<max){
                    for(var i=1; i<max; i++){
                       TAQty.push(0); 
                    }
                }if(TATotalVal.length<max){
                    for(var i=1; i<max; i++){
                       TATotalVal.push(0); 
                    }
                }if(TATotalCont.length<max){
                    for(var i=1; i<max; i++){
                       TATotalCont.push(0); 
                    }
                }
                
                // for Serv   
                if(SVQty.length<max){
                    for(var i=1; i<max; i++){
                       SVQty.push(0); 
                    }
                }if(SVTotalVal.length<max){
                    for(var i=1; i<max; i++){
                       SVTotalVal.push(0); 
                    }
                }if(SVTotalCont.length<max){
                    for(var i=1; i<max; i++){
                       SVTotalCont.push(0); 
                    }
                }
                
                // for Posit  
                if(POSQTy.length<max){
                    for(var i=1; i<max; i++){
                       POSQTy.push(0); 
                    }
                }if(POSTotalVal.length<max){
                    for(var i=1; i<max; i++){
                       POSTotalVal.push(0); 
                    }
                }if(POSTotalCont.length<max){
                    for(var i=1; i<max; i++){
                       POSTotalCont.push(0); 
                    }
                }
                
                // for short range    
                if(SHQty.length<max){
                    for(var i=1; i<max; i++){
                       SHQty.push(0); 
                    }
                }if(SHTotalVal.length<max){
                    for(var i=1; i<max; i++){
                       SHTotalVal.push(0); 
                    }
                }if(SHTotalCont.length<max){
                    for(var i=1; i<max; i++){
                       SHTotalCont.push(0); 
                    }
                }
                
                // for  Cellul   
                if(CELQty.length<max){
                    for(var i=1; i<max; i++){
                       CELQty.push(0); 
                    }
                }if(CELTotalVal.length<max){
                    for(var i=1; i<max; i++){
                       CELTotalVal.push(0); 
                    }
                }
                if(CELTotalCont.length<max){
                    for(var i=1; i<max; i++){
                       CELTotalCont.push(0); 
                    }
                }
                
                // for Others
              	if(OQty.length<max){
                    for(var i=1; i<max; i++){
                       OQty.push(0); 
                    }
                }if(OTotalVal.length<max){  
                    for(var i=1; i<max; i++){
                       OTotalVal.push(0); 
                    }
                }if(OTotalCont.length<max){
                    for(var i=1; i<max; i++){
                       OTotalCont.push(0); 
                    }
                }
                
               	console.log('SVQty -- '+SVQty);
                console.log('POSQTy -- '+POSQTy);
                console.log('SHQty -- '+SHQty);
                console.log('CELQty -- '+CELQty);
                console.log('OQty -- '+OQty);
                console.log('TAQty -- '+TAQty);
                
                var sumColumnQty = SHQty.map(function (num, idx) {
  					return num + parseFloat(TAQty[idx]) + parseFloat(SVQty[idx]) + parseFloat(POSQTy[idx]) + parseFloat(CELQty[idx]) + parseFloat(OQty[idx]); 
                });
                var sumColumnTotalVal = SHTotalVal.map(function (num, idx) {
  					return num + parseFloat(TATotalCont[idx]) + parseFloat(SVTotalVal[idx]) + parseFloat(POSTotalVal[idx]) + parseFloat(CELTotalVal[idx]) + parseFloat(OTotalVal[idx]);    
                });
              	var sumColumnTotalCont = SHTotalCont.map(function (num, idx) {
  					return num + parseFloat(TATotalCont[idx]) + parseFloat(SVTotalCont[idx]) + parseFloat(POSTotalCont[idx]) + parseFloat(CELTotalCont[idx]) + parseFloat(OTotalCont[idx]); 
                });
                console.log('sumColumnQty ----  '+sumColumnQty);
                console.log('sumColumnTotalVal ----  '+sumColumnTotalVal);
                console.log('sumColumnTotalCont ----  '+sumColumnTotalCont);

                console.log(years);
                console.log(centers);
                component.set("v.yearsSet", Array.from(years));
                component.set("v.productCenter", Array.from(centers));
                component.set("v.SHQty",SHQty);
                component.set("v.SHTotalVal",SHTotalVal);
                component.set("v.SHTotalCont",SHTotalCont);
                component.set("v.SVQty",SVQty);
                component.set("v.SVTotalVal",SVTotalVal);
                component.set("v.SVTotalCont",SVTotalCont);
                component.set("v.POSQTy",POSQTy);
                component.set("v.POSTotalVal",POSTotalVal);
                component.set("v.POSTotalCont",POSTotalCont);
                component.set("v.CELQty",CELQty);
                component.set("v.CELTotalVal",CELTotalVal);
                component.set("v.CELTotalCont",CELTotalCont);
                component.set("v.OQty",OQty);
                component.set("v.OTotalVal",OTotalVal);
                component.set("v.OTotalCont",OTotalCont);
                
                component.set("v.sumColumnQty",sumColumnQty);
                component.set("v.sumColumnTotalVal",sumColumnTotalVal);
                component.set("v.sumColumnTotalCont",sumColumnTotalCont);

            } else{                  
                console.log(state);
                console.log(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    }
})
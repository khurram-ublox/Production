({
    sortData: function (component, fieldName, sortDirection) {
        var fname = fieldName;
        var data = component.get("v.Orders");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortByfield(fieldName, reverse))
        component.set("v.Orders", data);
    },
    
    sortByfield: function (field, reverse) {
        var key = function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    convertTableDataToCSVString : function(component){
        var data = component.get("v.Orders");
        var columnData = component.get("v.Columns");
        var columnDivider=',';
        var lineDivider='\n';
        var csvStringResult = '';
        
        var columnCSVRowArr=[];
        for(var i=0; i < columnData.length; i++){ 
            columnCSVRowArr.push(columnData[i].label);
        }
        csvStringResult +=columnCSVRowArr.join(columnDivider);
        csvStringResult +=lineDivider;
        for(var j=0; j < data.length; j++){ 
            var dataRowArr = [];
            for(var k=0; k < columnData.length; k++){ 
                if(columnData[k].fieldName == 'AccountName')
                {
                    dataRowArr.push('\"'+data[j].accName+'\"');
                }else if(columnData[k].fieldName == 'OrderName'){
                    dataRowArr.push('\"'+data[j].Name+'\"'); 
                }else if(columnData[k].fieldName == 'End_Customer_Account__c'){
                    dataRowArr.push('\"'+data[j].endCustomer+'\"');
                }else if(columnData[k].fieldName == 'Project_Owner_Account__c'){
                    dataRowArr.push('\"'+data[j].projOwnerAcc+'\"');
                }
                else
                {
                    var colValue = data[j][columnData[k].fieldName] ? data[j][columnData[k].fieldName] : '';
            			dataRowArr.push('\"'+colValue+'\"');
        	    }
            }
            csvStringResult +=dataRowArr.join(columnDivider);
            csvStringResult +=lineDivider;
        } 
        
        return csvStringResult;
    }
 })
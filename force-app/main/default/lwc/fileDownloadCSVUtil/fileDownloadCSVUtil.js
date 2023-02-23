export function exportCSVFile(headers, totalData, fileTitle){
    if(!totalData || !totalData.length){
        return null;
    }
    const result = convertToCSVWithHeaderArray(totalData, headers);
    downloadCSVData(result,fileTitle);    
}
export function exportCSVFileFromHTMLTable(tableElement, fileTitle){
    if(!tableElement){
        return null;
    }
    let csvData = getCSVDataFromTable(tableElement);
    downloadCSVData(csvData,fileTitle);    
}

function getCSVDataFromTable(tableElement){
    var rows = tableElement.querySelectorAll("tr");
    let data = [];        
    for (var i = 0; i < rows.length; i++) {
        var row = [], cols = rows[i].querySelectorAll("td, th");
                
        for (var j = 0; j < cols.length; j++) {
                row.push(cols[j].innerText);
        }                    
        data.push(row.join(",")); 		
    }

    return data.join("\n");
}

function downloadCSVData(csvData,fileTitle)
{
    if(csvData === null) return;
    const blob = new Blob([csvData]);
    const exportedFilename = fileTitle ? fileTitle+'.csv' :'export.csv';
    if(navigator.msSaveBlob){
        navigator.msSaveBlob(blob, exportedFilename);
    } else if (navigator.userAgent.match(/iPhone|iPad|iPod/i)){
        const link = window.document.createElement('a');
        link.href='data:text/csv;charset=utf-8,' + encodeURI(csvData);
        link.target="_blank";
        link.download=exportedFilename;
        link.click();
    } else {
        const link = document.createElement("a");
        if(link.download !== undefined){
            const url = URL.createObjectURL(blob);
            link.setAttribute("href", url);
            link.setAttribute("download", exportedFilename);
            link.style.visibility='hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    }
}

function convertToCSV(objArray, headers){
    const columnDelimiter = ',';
    const lineDelimiter = '\r\n';
    const actualHeaderKey = Object.keys(headers);
    const headerToShow = Object.values(headers) ;
    let str = '';
    str+=headerToShow.join(columnDelimiter) ;
    str+=lineDelimiter;
    const data = typeof objArray !=='object' ? JSON.parse(objArray):objArray;

    data.forEach(obj=>{
        let line = '';
        actualHeaderKey.forEach(key=>{
            if(line !=''){
                line+=columnDelimiter;
            }
            let strItem = obj[key]+'';
            line+=strItem? strItem.replace(/,/g, ''):strItem;
        })
        str+=line+lineDelimiter;
    })
    return str;
}

function convertToCSVWithHeaderArray(objArray, headers){
    const columnDelimiter = ',';
    const lineDelimiter = '\r\n';
    const actualHeaderKey = headers.split(",").map(item => item.trim());
    const headerToShow = actualHeaderKey;
    let str = '';
    str+=headerToShow.join(columnDelimiter) ;
    str+=lineDelimiter;
    const data = typeof objArray !=='object' ? JSON.parse(objArray):objArray;

    data.forEach(obj=>{
        let line = '';
        actualHeaderKey.forEach(key=>{
            if(line !=''){
                line+=columnDelimiter;
            }
            
            let strItem = (obj[key] == undefined?'':obj[key])+'';
            line+=strItem? strItem.replace(/,/g, ''):strItem;
        })
        str+=line+lineDelimiter;
    })
    return str;
}
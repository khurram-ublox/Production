trigger alignCurrencyOnForecastUnitPeriod on Forecast_Unit__c (after update) {


    List<Forecast_Unit_Period__c> periodsToCheck = [SELECT Id, CurrencyIsoCode,Forecast_Unit__r.CurrencyIsoCode FROM Forecast_Unit_Period__c WHERE Forecast_Unit__c IN :Trigger.newMap.keySet()];
    List<Forecast_Unit_Period__c> periodsToUpdate = new List<Forecast_Unit_Period__c>{};
    
    for(Forecast_Unit_Period__c a: periodsToCheck ){
        if (a.CurrencyIsoCode <> a.Forecast_Unit__r.CurrencyIsoCode) {
            a.CurrencyIsoCode = a.Forecast_Unit__r.CurrencyIsoCode;
            periodsToUpdate .add(a);
        }
        
    }
    update periodsToUpdate ;
}
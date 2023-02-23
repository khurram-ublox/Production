@isTest
public class alignCurrencyOnForecastUnitPeriodTest {
        public static testMethod void testFUPCurrency()
        {
                    // Create new Forecast Unit
                    Forecast_Unit__c a = new Forecast_Unit__c(Name='Test FU', CurrencyIsoCode='USD');
                    insert a;
                    
                    // Create new Forecast Period
                    Forecast_Unit_Period__c testFUP = new Forecast_Unit_Period__c(Name = 'Test FUP', Forecast_Unit__c = a.Id, CurrencyIsoCode = 'USD', FCUPReference_ext_ID__c = 'Test FUP');
                    insert testFUP;
                  
                    // Change Currency in Forecast Unit
                    a.CurrencyIsoCode = 'EUR';
                    update a;
                                                      
                    // Verify that the inserted FUP has the same Currency as the related FU                    
                    Forecast_Unit_Period__c updatedFUP = [SELECT CurrencyIsoCode FROM Forecast_Unit_Period__c WHERE Forecast_Unit__c = :a.Id];
                    System.assertEquals(a.CurrencyIsoCode, updatedFUP.CurrencyIsoCode);                                                

        } 
  
}
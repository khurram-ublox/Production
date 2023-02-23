public class OrdersWithFullContribution implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, 
                                                Calculate_Total_COGS_CHF__c,
                                                Update_CS__c, 
                                                CM_Pct__c 
                                                FROM Billings__c 
                                                WHERE CM_Pct__c = 100
                                                AND Order_Status__c = 'Closed']);
    }

    public void execute(Database.BatchableContext bc, list<Billings__c> Orders){
        list<Billings__c> updateOrders = new list<Billings__c>();
        for(Billings__c order : Orders){
            updateOrders.add(new Billings__c(
                Id = order.Id,
                Calculate_Total_COGS_CHF__c = true
            ));
        }
        if(updateOrders.size() > 0){
            Database.update(updateOrders, false);
        }
    }
    public void finish(Database.BatchableContext bc){}
}
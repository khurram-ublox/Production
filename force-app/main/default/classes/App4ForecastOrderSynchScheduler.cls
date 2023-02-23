global class App4ForecastOrderSynchScheduler implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        
        Database.executeBatch(new App4ForecastOrderSynchBatchable(),10);
        
    }
}
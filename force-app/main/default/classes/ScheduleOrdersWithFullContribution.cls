public class ScheduleOrdersWithFullContribution implements Schedulable{
    public void execute(SchedulableContext sc) {
        OrdersWithFullContribution fullContributionOrders = new OrdersWithFullContribution(); 
        database.executebatch(fullContributionOrders,100);
    }
}
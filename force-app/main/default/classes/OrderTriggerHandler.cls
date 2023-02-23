/****
Process 1 : update Order with matching Customer Part Number
Process 2 : update Order with matching contribution share

***/
public Class OrderTriggerHandler implements ITrigger
{
    //process 1 data : Update Order with Customer Part Number
    list<String> oProductIds = new list<String>();
    list<String> oAccountIds = new list<String>();
    
    //process 2 data : Update Order with Contribution Share
    Set<Id> accounts = new Set<Id>();
    
    // Prepare the data for catering to--- Before Trigger events
    public void prepareBefore(){
        list<Billings__c> newOrderLst = (list<Billings__c>)Trigger.New;
        map<Id, Billings__c> oldOrders = (map<Id, Billings__c>)Trigger.oldMap;
        if(!Trigger.isDelete){
            for(Billings__c tempOrder : newOrderLst){
                if(Trigger.isUpdate){
                    Billings__c OldOrder = oldOrders.get(tempOrder.Id);
                    
                    //process to update CPN
                    if (tempOrder.Customer_Part_Number_ID__c == null 
                        || OldOrder.Account__c != tempOrder.Account__c 
                        || OldOrder.Product__c != tempOrder.Product__c){
                            
                            oProductIds.add(tempOrder.product__c);
                            oAccountIds.add(tempOrder.account__c);                   
                        }
                    
                    //process to update order with match contribution share
                    
                    if ( (tempOrder.Order_Status__c == 'Closed' 
                        && OldOrder.Order_Status__c != tempOrder.Order_Status__c) 
                            || tempOrder.Update_CS__c 
                            || tempOrder.Calculate_Total_COGS_CHF__c
                           ){
                               // Add related account id to set
                               accounts.add(tempOrder.Account__c);                    
                               // Reset update CS flag
                               //tempOrder.Update_CS__c = false; This check moved to Order : After Record Crete/Update Process Flow
                               // Set flag to calculate contribution split
                               //order.Calculate_Contribution_Split__c = true;
                           }                
                    
                }else if(Trigger.isInsert){
                    oProductIds.add(tempOrder.product__c);
                    oAccountIds.add(tempOrder.account__c);
                    
                    if(tempOrder.Order_Status__c == 'Closed' || tempOrder.Update_CS__c || tempOrder.Calculate_Total_COGS_CHF__c){
                        // Add related account id to set
                        accounts.add(tempOrder.Account__c);                    
                        // Reset update CS flag
                        //tempOrder.Update_CS__c = false; This check moved to Order : After Record Crete/Update Process Flow
                        // Set flag to calculate contribution split
                        //order.Calculate_Contribution_Split__c = true;
                    }
                }    
            }
        }
    }
    
    // Prepare the data for catering to After Trigger events 
    public void prepareAfter(){
    }
    
    // Process logic/functioanlities in other classes for before Insert event  
    public void beforeInsert(){        
        // disabled by Khurram 3/3/22 moved the CPN assignment to Order Interface Mapping
        //orderObjectHelper.setCPN((list<Billings__c>)Trigger.new, oAccountIds, oProductIds);
        // Update Order with Contribution Share by maching the 
        // Order Project Owner Account, End Customer Account and Product
        // with similar fields of Contribution Share 
        // Order Account and Contribution Share Account must be same
        if(accounts.size()>0){
            orderObjectHelper.updateCS((list<Billings__c>)Trigger.new, accounts);
        }
    }
    
    // Process logic/functioanlities in other classes for before Update  event
    public void beforeUpdate(){
        // disabled by Khurram 3/3/22 moved the CPN assignment to Order Interface Mapping
        //orderObjectHelper.setCPN((list<Billings__c>)Trigger.new,oAccountIds, oProductIds);
        if(accounts.size()>0){
            orderObjectHelper.updateCS((list<Billings__c>)Trigger.new, accounts);
        }
    }
    
    // Process logic/functioanlities in other classes for before Delete event
    public void beforeDelete(){}
    
    // Process logic/functioanlities in other classes for after Update  event
    public void afterInsert(){
        //   AccountObjectHelper.updateOwnerEmailFields(Trigger.New,accIdUserIds);        
    }
    
    // Process logic/functioanlities in other classes for after Update  event 
    public void afterUpdate(){}
    
    // Process logic/functioanlities in other classes for after Delete  event
    public void afterDelete(){} 
    
    //Finally do operations to Commit 
    public void finish(){}
}
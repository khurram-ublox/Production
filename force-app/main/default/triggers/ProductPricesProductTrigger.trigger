trigger ProductPricesProductTrigger on Product2 (after insert, after update, after delete) {
       
    if (Trigger.isInsert) {
        Set<String> productCodes = ProductPricesTriggerHelper.afterInsertOrDeleteProductHandler(Trigger.new, Trigger.newMap);
        ProductPricesTriggerHelper.insertupdatedeleteProducthandler(productCodes);             
    }
    else
    {
        if (Trigger.isUpdate) {
            Set<String> productCodes = ProductPricesTriggerHelper.afterUpdateProductHandler(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
            ProductPricesTriggerHelper.insertupdatedeleteProducthandler(productCodes);
        }
        else if (Trigger.isDelete) {
            Set<String> productCodes = ProductPricesTriggerHelper.afterInsertOrDeleteProductHandler(Trigger.old, Trigger.oldMap);
            ProductPricesTriggerHelper.insertupdatedeleteProducthandler(productCodes);
        }
    }
}
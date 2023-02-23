public with sharing class productTriggerHelper {
	/**
	* @description: Force update of related Opp_Product__c records
	**/
	public static void updateOppProducts(Map<Id, Product2> products){
		
		if (products==null) return;

		List<Id> productIds = new List<Id>();

		if (Trigger.isAfter && Trigger.isDelete){
			List<Product2> delProducts = [SELECT ID 
										FROM Product2
										WHERE Id IN :products.keySet()];	
			for (Product2 delProduct:delProducts){
				productIds.add(delProduct.Id);
			}
		} else {
			productIds.addAll(products.keySet());
		}

		// Get all related Opp_Product__ records.
		List<Opp_Product__c> oppProducts = [SELECT Id 
											FROM Opp_Product__c
											WHERE Product__c IN :productIds];
		update oppProducts;
	}
}
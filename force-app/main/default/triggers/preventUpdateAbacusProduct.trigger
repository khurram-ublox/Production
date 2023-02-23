trigger preventUpdateAbacusProduct on Product2 (before update,After Insert,After Update) {
/*
2017.12.19 khir: Added logistics to allow them to change Products linked to Abacus
*/

    Set<String> setProfile=new Set<String>{'system administrator','automatic process','logistics'};

    System.debug('======setProfile: '+setProfile);
    System.debug('======BeforeUpdateAbacusProduct.profileName:'+BeforeUpdateAbacusProduct.profileName);        

    if(!setProfile.contains(BeforeUpdateAbacusProduct.profileName.toLowerCase())){
        BeforeUpdateAbacusProduct.beforeUpdateAbacusProduct(Trigger.new,Trigger.old);//Trigger.old->Null when after Insert
    }
    
    //Changes made on 29th Jan,2020
    // Commenting out this(upsertCustomProduct) method calls. It is for the removal of custom Product obj. By ufar, 12-6-22.
	/*  
    if(trigger.isAfter){
        if(trigger.isInsert){
            BeforeUpdateAbacusProduct.upsertCustomProduct(Trigger.newMap);
        }
        if(trigger.isUpdate){
            BeforeUpdateAbacusProduct.upsertCustomProduct(Trigger.newMap);
        }
    }
	*/
}
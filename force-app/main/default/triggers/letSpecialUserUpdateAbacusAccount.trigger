trigger letSpecialUserUpdateAbacusAccount on Account (before update) {

    System.debug('======BeforeUpdateAbacusAccount.fromAbacus:'+BeforeUpdateAbacusAccount.fromAbacus);
    System.debug('======BeforeUpdateAbacusAccount.profileName:'+BeforeUpdateAbacusAccount.profileName);
    System.debug('======BeforeUpdateAbacusAccount.specialUser:'+BeforeUpdateAbacusAccount.specialUser);


    if( !BeforeUpdateAbacusAccount.fromAbacus && BeforeUpdateAbacusAccount.specialUser ){
        System.debug('I\'m in : '+BeforeUpdateAbacusAccount.fromAbacus+'-'+BeforeUpdateAbacusAccount.profileName+'-'+BeforeUpdateAbacusAccount.specialUser);
        System.debug('Trigger.new:'+Trigger.new);
        System.debug('Trigger.old:'+Trigger.old);
        BeforeUpdateAbacusAccount.beforeUpdateAbacusAccount(Trigger.new,Trigger.old);
    }
    

}
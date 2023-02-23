trigger preventUpdateAbacusAccount on Account (before update) {

    Set<String> setProfile=new Set<String>{'system administrator','automatic process'};
    Set<String> setOfSpecialUser=new Set<String>{'Lucia.Ranieri@u-blox.com'};
    
    System.debug('======setProfile:'+setProfile);
    System.debug('======BeforeUpdateAbacusAccount.profileName:'+BeforeUpdateAbacusAccount.profileName);        

    if((!BeforeUpdateAbacusAccount.fromAbacus && !setProfile.contains(BeforeUpdateAbacusAccount.profileName.toLowerCase()))){
        BeforeUpdateAbacusAccount.beforeUpdateAbacusAccount(Trigger.new,Trigger.old);
    }
}
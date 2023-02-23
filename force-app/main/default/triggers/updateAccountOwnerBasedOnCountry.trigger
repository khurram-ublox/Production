trigger updateAccountOwnerBasedOnCountry on Account (before insert) {

    UpdateAccount.beforUpdateAccount(Trigger.new);

}
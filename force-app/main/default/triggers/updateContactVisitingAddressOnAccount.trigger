trigger updateContactVisitingAddressOnAccount on Account (before update) {
    AccountVisitingAddress.updateContactVisitingAddress(Trigger.new);
}
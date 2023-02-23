trigger changeOwnerOnLeadBeforInsert on Lead (before insert) {
    UpdateLead.changeOwnerOnLead(Trigger.new);
}
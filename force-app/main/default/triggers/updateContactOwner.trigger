trigger updateContactOwner on Contact (before insert) {
    
    if(Trigger.isInsert)
    {
        updateContactOwner.execute(Trigger.new);
    }       
}
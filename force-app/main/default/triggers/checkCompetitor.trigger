/**
 * @description Trigger to check potential competitor
 *
 * @author ldra
 */
 
trigger checkCompetitor on Account (before insert) {
    for(Account a : Trigger.New) {
        String compName = a.Name;
        System.debug(compName);
        String compNameExt = compName+' %';
        String compNameSub = compName.split(' ')[0]+' %';
        Competitor__c[] competitors = [select Id from Competitor__c where Name = :compName OR Name LIKE :compNameExt OR Name LIKE :compNameSub];
        if (competitors.size() > 0) {
            a.Potential_Competitor__c = true;
        }
    }
}
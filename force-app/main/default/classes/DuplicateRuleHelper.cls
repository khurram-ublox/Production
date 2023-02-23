public class DuplicateRuleHelper{
    public static Map<string,duplicateRecord> getDuplicateRecords(List<sObject> records)
    {
        Map<string,duplicateRecord> duplicateResultMap = new Map<String,duplicateRecord>();
            
        Datacloud.FindDuplicatesResult[] results = Datacloud.FindDuplicates.findDuplicates(records);
            
        for (Datacloud.FindDuplicatesResult dupeResult : results) {
            for (Datacloud.DuplicateResult dupeRes : dupeResult.getDuplicateResults()) {
                for (Datacloud.MatchResult matchRes : dupeRes.getMatchResults()) {
                    for (Datacloud.MatchRecord matchRec : matchRes.getMatchRecords()) {
                        string keyValue = (String)matchRec.getRecord().get('ID');
                        duplicateRecord dRec = new duplicateRecord();
                        dRec.confidence = matchRec.getMatchConfidence();
                        duplicateResultMap.put(keyValue,dRec);                            
                    }
                }
            }
        }
        return duplicateResultMap;
    }
    
    public class duplicateRecord{
        public sObject record {get;set;}
        public Double confidence {get;set;}
    }
}
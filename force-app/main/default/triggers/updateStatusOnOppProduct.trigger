trigger updateStatusOnOppProduct on Opportunity (after update) {
    if (Trigger.isAfter){
        if (Trigger.isUpdate){

            List<Id> OppToUpdate = new List <Id>{};
            // list of opportunities that will be updated directly
            List<Id> oUpdDirect = new List <Id>{};
                
            for(Opportunity n : Trigger.new) {
                Opportunity o = Trigger.oldMap.get(n.Id);
                
                if(
                    (n.StageName != o.StageName) && 
                    (n.StageName == '1 Lost' ||
                     ((o.StageName != '5 Design-in' && o.StageName != '6 Prototypes' && o.StageName != '7 Pre-Production' && o.StageName != '8 Production' && o.StageName != '9 Closed EoL') && 
                      (n.StageName == '5 Design-in' || n.StageName == '6 Prototypes' || n.StageName == '7 Pre-Production' || n.StageName == '8 Production' || n.StageName == '9 Closed EoL'))
                    )
                ) {
                    OppToUpdate.add(n.Id);
                    if(n.StageName == '1 Lost') {
                        oUpdDirect.add(n.Id);
                    }
                } 
            }
            System.debug('OppToUpdate:'+OppToUpdate);            

            // List all Opp Products related to the Opportunities that have changed stage not from 5-8.
            List<Opp_Product__c> OppProdToCheck = [
                SELECT Id, Opportunity__c, Status__c, Loss_Reason__c, Opportunity__r.StageName, Opportunity__r.Reason__c, Loss_Reason_Remark__c, No_Opp_Update__c
                FROM Opp_Product__c
                WHERE Opportunity__c IN :OppToUpdate];
                //System.debug('OppProdToCheck:'+OppProdToCheck);
            List<Opp_Product__c> OppProdToUpdate = new List <Opp_Product__c>{};
                


            for(Opp_Product__c a: OppProdToCheck){
                
                // if opportunity changed to lost, don't update opportunities from their children.
                if (a.Opportunity__r.StageName == '1 Lost') {
                    if(a.No_Opp_Update__c == false) a.No_Opp_Update__c = true;
                    else a.No_Opp_Update__c = false;
                    if(!oUpdDirect.contains(a.Opportunity__c)) oUpdDirect.add(a.Opportunity__c);
                }
                
                if (a.Status__c == 'Evaluation') {
                    if (a.Opportunity__r.StageName == '1 Lost') {
                        a.Status__c = 'Lost';
                        if (a.Loss_Reason_Remark__c == null) {
                            a.Loss_Reason_Remark__c = '(Automatic update)';
                        }
                    } else {
                        a.Status__c = 'Won';
                    }
                    a.Loss_Reason__c = a.Opportunity__r.Reason__c;
                    OppProdToUpdate.add(a);
                } else if ((a.Status__c == 'Alternative Product') || (a.Status__c == 'Not applicable')) {
                    a.Status__c = 'Lost';
                    a.Loss_Reason__c = 'Alternative Product';
                    if (a.Loss_Reason_Remark__c == null) {
                        a.Loss_Reason_Remark__c = '(Automatic update)';
                    }
                    OppProdToUpdate.add(a);
                } else if (a.Status__c == 'Won') {
                    if (a.Opportunity__r.StageName == '1 Lost') {
                        a.Status__c = 'Lost';
                        a.Loss_Reason__c = a.Opportunity__r.Reason__c;
                        if (a.Loss_Reason_Remark__c == null) {
                            a.Loss_Reason_Remark__c = '(Automatic update)';
                        }
                        OppProdToUpdate.add(a);
                    }
                }
            }
            System.debug('OppProdToUpdate:'+OppProdToUpdate);
            if (!OppProdToUpdate.isEmpty()) update OppProdToUpdate;
            
            
            Opp_Product__c[] opps = [select Id, Opportunity__c, Product__c from Opp_Product__c where Opportunity__c in :oUpdDirect ORDER BY Revenue_Unweighted__c DESC ];

			Map<Id, List<Id>> mapM = new Map<Id, List<Id>>();
			List<Id> listM = new List<Id>();

			for(Opp_Product__c op : opps) {
				if(!mapM.containsKey(op.Opportunity__c)) {
					mapM.put(op.Opportunity__c, new List<Id>());
				}
				mapM.get(op.Opportunity__c).add(op.Product__c);
			}

			// for (Id oid : mapM.keySet()){
			// 	for (Id opid : mapM.get(oid)) {
			// 		system.debug(oid+' - '+opid);
			// 	}
			// }

			Opportunity[] oUpd = [SELECT Id, Product_1__c, Product_2__c, Product_3__c, Product_4__c, Product_5__c FROM Opportunity WHERE Id in :oUpdDirect];
            for(Opportunity oU : oUpd) {
                if(mapM.containsKey(oU.Id)) {
                    Id[] ids = mapM.get(oU.Id);
                    oU.Product_1__c = null;
                    oU.Product_2__c = null;
                    oU.Product_3__c = null;
                    oU.Product_4__c = null;
                    oU.Product_5__c = null;
                    for(integer i=0;i<ids.size();i++) {	
                        if(i==0) oU.Product_1__c = ids[i];
                        else if(i==1) oU.Product_2__c = ids[i];
                        else if(i==2) oU.Product_3__c = ids[i];
                        else if(i==3) oU.Product_4__c = ids[i];
                        else if(i==4) oU.Product_5__c = ids[i];
                    }
                }
            }
			if (!oUpd.isEmpty()) update oUpd;
            
        }
    }
}
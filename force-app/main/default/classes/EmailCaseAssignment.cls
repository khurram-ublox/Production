/*
* Title: EmailCaseAssignment
* Description: Apex used in process builder for Case assignment
* Author:  ldra
* Created:  2019-05-24
*/

public class EmailCaseAssignment {
    
    @InvocableMethod(label='Email Case Assignment')
    public static void assignUnassigned (List<String> emailIds) {

        List<Case> recordsToUpdate = new List <Case>{};

            for (EmailMessage em : [select Id, ToAddress, ParentId from EmailMessage where Id = :emailIds]) {
                String caseId = em.ParentId;
                
                //String addresses = 'isabelle.niollet@steliau-technology.com; fsdf@u-bloxbest.com; support@steliau-technology.com; u@u-blox.com; ; ; dfsdf; ';
                String addresses = em.ToAddress;
                String[] addressArray = addresses.split(';');

                String[] addressFinal = new String[]{};
                    for (String a: addressArray) {
                        if(!a.contains('@u-blox.com')) {
                            a = a.trim();
                            if(a.contains('@')) {
                                addressFinal.add(a);
                            }
                        }
                    }

                String newOwner = '';
                String aId = '';
                String cId = '';
                // 1. first have a look whether a contact exists;

                //if(!addressFinal.isEmpty()) 
                Contact[] c = [select Id, Name, Account.Id, Account.FAE__c from Contact where Email IN :addressFinal and Account.FAE__c != null LIMIT 1];
                if(!c.isEmpty()) {
                    newOwner = c[0].Account.FAE__c;
                    aId = c[0].Account.Id;
                    cId = c[0].Id;
                }
                else {
                    // 1. contact doesnt exists, search for domain names in Account;
                    for (String a: addressFinal) {
                        String domain = '%' + a.split('@')[1];
                        
                        Account[] acc = [select Id, Name, FAE__c from Account where Website LIKE :domain and FAE__c != null order by CreatedDate limit 1];
                        if(!acc.isEmpty()) {
                            newOwner = acc[0].FAE__c;
                            aId = acc[0].Id;
                            break;
                        }
                    }
                }

                Case caseSingle = [select Id, OwnerId, AccountId, ContactId from Case where Id = :caseId];
                if(newOwner=='') {
                    caseSingle.OwnerId = [select Id from Group where Type = 'Queue' AND NAME = 'Support EMEA'].Id;
                }
                else {
                    caseSingle.OwnerId = newOwner;
                    caseSingle.AccountId = aId;
                    if(cId != '') caseSingle.ContactId = cId;
                }
                // add updated case in array of updates
                recordsToUpdate.add(caseSingle);
            }

        
        update recordsToUpdate;
        return;
    }
}
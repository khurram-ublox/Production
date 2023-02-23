/*
 * Title: AssistNow
 * Description: Class that creates and updates temporary tokens for the AssistNow application 
 * Author:  ldra
 * Created:  2018-10-09
 */
 
public class AssistNow {
    @future (callout=true)
    public static void updateTokens(Set<ID> ids){
        List<Lead> leadsToUpdate = new List <Lead>();
        //Lead leads = [select Id, AssistNow_Temporary_Token__c, Lead_Source_Webform__c from Lead where Id in :ids ];
        // Get list of records to update
        for (Lead lead : [select Id, AssistNow_Temporary_Token__c, Lead_Source_Webform__c from Lead where Id in :ids ]){
            if (lead.Lead_Source_Webform__c == 'AssistNow Temporary') {
                // get token and update field
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setEndpoint('https://token-live1.services.u-blox.com/GetToken.ashx?key=28549d2b-be1a-4137-894d-e1d0ee93c1b6');
                request.setMethod('GET');
                request.setCompressed(true); // otherwise we hit a limit of 32000
                try {
                    response = http.send(request);
                    // If the request is successful, parse the JSON response.
                    if (response.getStatusCode() == 200) {
                        String token = response.getBody();
                        if(token!='') {
                            lead.AssistNow_Temporary_Token__c = token;
                            leadsToUpdate.add(lead);
                            System.debug('added: '+ lead.id);
                        }
                    }
                } catch(System.CalloutException e) {
                    System.debug('Callout error: '+ e);
                }
            }
        }
        // update all leads
        if(!leadsToUpdate.isEmpty()) update leadsToUpdate;
    }
}
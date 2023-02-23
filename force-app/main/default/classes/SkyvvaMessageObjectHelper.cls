public class SkyvvaMessageObjectHelper {
        public class FlowInputs {         
        @InvocableVariable public String skyvvaMsgId;
    }

    @future
    public static void updateErrorMessage(List<String> skyvvaIds){
        
        List<skyvvasolutions__IMessage__c> SkyvvaObjLst = new List<skyvvasolutions__IMessage__c>();
        if(skyvvaIds!= NULL){
            for(skyvvasolutions__IMessage__c tempMsgObj : [SELECT Id,skyvvasolutions__Comment__c,Error_Message__c FROM skyvvasolutions__IMessage__c WHERE Id=:skyvvaIds] ){
                if(!String.isEmpty(tempMsgObj.skyvvasolutions__Comment__c)){
                    //for account
                    if(!tempMsgObj.skyvvasolutions__Comment__c.contains('Billings__c')){
                        String accId = tempMsgObj.skyvvasolutions__Comment__c.mid(48, 18);
                        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
                        String URL = baseUrl + '/'+accId;
                        String accErrorMsg = System.Label.Skyvva_Account_Error_Message;
                        String ErrorMEssage = accErrorMsg+URL;
                        tempMsgObj.Error_Message__c=ErrorMEssage;
                    }
                    //for Order Error
                    else if(tempMsgObj.skyvvasolutions__Comment__c.contains('Billings__c')){
                        String orderId = tempMsgObj.skyvvasolutions__Comment__c.mid(89, 18);
                        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
                        String URL = baseUrl + '/'+orderId;
                        String orderErrorMsg = System.Label.Skyvva_Order_Error_Message;
                        String ErrorMEssage = orderErrorMsg+ URL;
                        tempMsgObj.Error_Message__c=ErrorMEssage;
                    }
                    SkyvvaObjLst.add(tempMsgObj);
                }
            }
        }
        if(SkyvvaObjLst!= NULL){
            update SkyvvaObjLst;
        }
    }
    @InvocableMethod(Label = 'Skyvva Message Object Process')
    public static void invocableMethd(List<FlowInputs> requests){
        List<Id> skyvvaMsgIdLst = new List<Id>();
        for (FlowInputs request : requests) {
            skyvvaMsgIdLst.add(request.skyvvaMsgId);
        }
        updateErrorMessage(skyvvaMsgIdLst);
    }
}
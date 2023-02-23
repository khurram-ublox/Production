@isTest
public class SkyvvaMessageObjectHelperTest {

    @testSetup static void setup(){
        List<skyvvasolutions__IMessage__c> messageList = new List<skyvvasolutions__IMessage__c>();
        skyvvasolutions__IMessage__c messageObj = new skyvvasolutions__IMessage__c();
        messageObj.skyvvasolutions__Status__c = 'Failed';
        messageObj.skyvvasolutions__Is_Alerted__c = TRUE;
        messageObj.skyvvasolutions__Comment__c = 'Failure:Billings__c: duplicate value found: ExtID__c duplicates value on record with id: a079E00000BxqpI';
        skyvvasolutions__IMessage__c messageObj2 = new skyvvasolutions__IMessage__c();
        messageObj2.skyvvasolutions__Status__c = 'Failed';
        messageObj2.skyvvasolutions__Is_Alerted__c = TRUE;
        messageObj2.skyvvasolutions__Comment__c = 'Update failed. First exception on row 0 with id 0017Z00001NJfDS ; first error: DUPLICATE_VALUE, duplicate value found: Customer_No__c duplicates value on record with id';
        messageList.add(messageObj);
        messageList.add(messageObj2);
        
        insert messageList;
        
    }
    @isTest  static void testupdateErrorMessage(){
       List<skyvvasolutions__IMessage__c> messageObj = new List<skyvvasolutions__IMessage__c>();
        messageObj = [SELECT Id FROM skyvvasolutions__IMessage__c WHERE skyvvasolutions__Comment__c LIKE  '%Failure:Billings__c: duplicate value%' LIMIT 1];
        List<String> SkyvvaMsgIds = new List<String>();
        for(skyvvasolutions__IMessage__c temp : messageObj){
            SkyvvaMsgIds.add(String.valueOf(temp.Id));
        }
        test.startTest();
        SkyvvaMessageObjectHelper.updateErrorMessage(SkyvvaMsgIds);
        test.stopTest();
    }
    
    @isTest  static void testupdateErrorMessage2(){
       List<skyvvasolutions__IMessage__c> messageObj = new List<skyvvasolutions__IMessage__c>();
        messageObj = [SELECT Id FROM skyvvasolutions__IMessage__c WHERE skyvvasolutions__Comment__c LIKE  '%Update failed. First exception on row 0 with id 0017Z00001NJfDS %' LIMIT 1];
        List<String> SkyvvaMsgIds = new List<String>();
        for(skyvvasolutions__IMessage__c temp : messageObj){
            SkyvvaMsgIds.add(String.valueOf(temp.Id));
        }
        test.startTest();
        SkyvvaMessageObjectHelper.updateErrorMessage(SkyvvaMsgIds);
        test.stopTest();
    }
}
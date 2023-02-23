/**
 * @description Test class for UBXRESTGenericObjectCreation - Generic Mass Creation in SF using REST.
 *
 * @author ldra
 */

@isTest
private class UBXRESTGenericObjectCreationTest {

  @isTest
    public static void testData(){
        
        UBXRESTGenericObjectCreation.ObjectsToCreate obj = new UBXRESTGenericObjectCreation.ObjectsToCreate();
        
        obj.objectName  = 'Campaign';

        List<String> fieldList = new List<String>{'Name','Description'};
        obj.fieldList  = fieldList;

        List<List<String>> listOfObjectValueList = new List<List<String>>{
            new List<String>{'Campaign Test 1','This is campaign 1 for test class.'},
            new List<String>{'Campaign Test 2','This is campaign 2 for test class.'}
        };
        obj.listOfObjectValueList  = listOfObjectValueList;
        
        Test.startTest();
        
        UBXRESTGenericObjectCreation.ReturnClass results = UBXRESTGenericObjectCreation.createObjects(obj);
        List<Campaign> selects = [SELECT Id, Name FROM Campaign];
        
        System.assertEquals('true', results.success);
        System.assertEquals(selects[0].Name, 'Campaign Test 1');
        System.assertEquals(selects[1].Id, results.createdIDs[1]);
        
        Test.stopTest();
    }
}
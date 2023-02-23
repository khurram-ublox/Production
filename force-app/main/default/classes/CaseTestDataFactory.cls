/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest
public class CaseTestDataFactory extends TestDataFactory{
    public CaseTestDataFactory() {
        super('Case');
    }
    public override sObject initializeRecord(){ 
        Account caseAccount = (Account)new AccountTestDataFactory().createRecord();
        Id caseInitior = createUserWithProfile('Dirk Martin','Dirk.Martin@u-blox.com.invalid','EMEA','Service FAE').Id;       
        Case portalCase = new Case(
            Accountid = caseAccount.Id,
            OwnerId = caseInitior,
            Type = 'Technical Question',
            Origin = 'u-blox Portal',
            Status = 'New',
            Technology__c = 'Cellular',
            Case_Initiator_Source__c = caseInitior,
            RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByName().get('Support Case').getRecordTypeId()
        );
        return portalCase;
    }

    public override sObject createRecord() {
        Case caseRec = (Case)initializeRecord();
        insert caseRec;
        return caseRec;
    }

    public override List<sObject> createBulkRecords() {
        for (Integer i = 0; i < numberOfRecords; i++) {
            recordsList.add((Case)initializeRecord());
        }
        Insert recordsList;
        return recordsList;
    }
}
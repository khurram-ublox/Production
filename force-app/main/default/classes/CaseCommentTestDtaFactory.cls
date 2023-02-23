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
public class CaseCommentTestDtaFactory extends TestDataFactory {
    
    public CaseCommentTestDtaFactory() {
        super('CaseComment');
    }
    
    public override sObject initializeRecord(){
        Case caseRec = (Case)new CaseTestDataFactory().createRecord();
		CaseComment cc = new CaseComment(
            CommentBody = 'My test Comments',
            ParentId = caseRec.Id
        );		
		return cc;
    }

    public override sObject createRecord(){
        CaseComment caseCommentObj = (CaseComment)initializeRecord();
        insert caseCommentObj;
        return caseCommentObj;
    }

    public override List<sObject> createBulkRecords(){
        for (Integer i = 0; i < numberOfRecords; i++){
            recordsList.add((CaseComment)initializeRecord());
        }
        Insert recordsList;
        return recordsList;
    }

    public User getContextUser(){
        return createUserWithProfile('Nabeel Khan','Nabeel.Khan@u-blox.com.invalid','Americas',' Service FAE');
    }
}
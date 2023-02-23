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
public class CaseCommentFlowTest {
    public static Case newCase;
    public static CaseCommentTestDtaFactory dataFactory = new CaseCommentTestDtaFactory();

    static{
        CaseTestDataFactory caseDataFac = new CaseTestDataFactory();
        newCase = (Case)caseDataFac.createRecord();
        newCase.Status = 'Closed';        
        Database.update(newCase);
    }

    static testMethod void testUpdateCaseStatus(){        
        CaseComment caseCommentObj = (CaseComment)dataFactory.initializeRecord();
        caseCommentObj.ParentId = newCase.Id;
        Database.insert(caseCommentObj);
        //Status won't change becuse of the delay of 5 seconds added in the Flow criteria      
        system.assertEquals('Closed', newCase.Status);      
    }

    static testMethod void testCaseCommentAndLastCommentBy(){        
        CaseComment caseCommentObj = (CaseComment)dataFactory.initializeRecord();
        caseCommentObj.ParentId = newCase.Id;
        caseCommentObj.CommentBody = 'Test Comment';
        Database.insert(caseCommentObj);
        list<Case> updatedCase = [Select Case_Comment__c,Last_Comment_By__c from Case where Id =:newCase.Id];
        system.assert(updatedCase[0].Last_Comment_By__c != null);
    }
}
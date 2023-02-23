/**
 * @description Test class for Case Service class
 *
 * @author eru
 * @copyright PARX
 */
@isTest
private class Test_CaseService
{

	@testSetup
	public static void setupData()
	{
		Case testCase = new Case(Status = 'New', Priority = '3 - Low');
		insert testCase;

		EmailMessage testEmail = new EmailMessage(Subject = 'TestEmail [' + CaseService.getThreadId(testCase.Id) + ' ]');
		testEmail.ToAddress = 'test@test.com';
		testEmail.TextBody = 'Test\n> ' + CaseService.getThreadId(testCase.Id);
		testEmail.ParentId = testCase.Id;
		insert testEmail;

		CaseComment testComment = new CaseComment(CommentBody = 'Test', ParentId = testCase.Id);
		insert testComment;

		Attachment att = new Attachment();
		att.Name = 'testAttachments';
		att.Body = Blob.valueOf('test123');
		att.ParentId = testCase.Id;
		insert att;
        
        Account testAccount = new Account(Name = 'TestAccount');
        insert testAccount;
        
        RMA__c testRMA = new RMA__c(Account_Name__c=testAccount.Id,Related_Case__c = testCase.Id, Email_Account_Owner__c = 'test@test.com', Distributor_Name__c = 'DistributorName0', Approval_available__c = true);
        insert testRMA;
        
        	ContentVersion contentVersion = new ContentVersion(
			Title          = 'a picture',
			PathOnClient   = 'Pic.jpg',
			VersionData    = Blob.valueOf('Test Content'),
			IsMajorVersion = true);
	insert contentVersion;

	List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

	//create ContentDocumentLink  record
		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.LinkedEntityId = testRMA.Id;
		cdl.ContentDocumentId = documents[0].Id;
		cdl.ShareType = 'V';
		cdl.Visibility = 'AllUsers';
		insert cdl;
	}

	@isTest
	public static void splitCaseTest() {
		List<Case> testCases = [SELECT Id FROM Case];
        RMA__C testRMA = [SELECT Id FROM RMA__c WHERE Email_Account_Owner__c = 'test@test.com' LIMIT 1];
        List<ContentDocumentLink> TestcontentDocLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId in ( SELECT Id FROM RMA__c WHERE Id = :testRMA.Id) ];

		Case originalCase = CaseService.getOriginalCase(testCases[0].Id);
		List<CaseComment> testComments = CaseService.getCaseComments(testCases[0].Id);
		List<EmailMessage> testEmails = CaseService.getCaseEmails(testCases[0].Id);
		List<Attachment> testAttachments = CaseService.getCaseAttachments(testCases[0].Id);
        List<ContentDocument> attachedFiles = CaseService.getRMAfiles(testRMA.Id);
		CaseService.saveFilesToSubCase(testCases[0].Id, TestcontentDocLinks[0].ContentDocumentId);
		User currentUser = CaseService.getCurrentUser();

		System.assertEquals(false, testComments.isEmpty());
		System.assertEquals(false, testEmails.isEmpty());
		System.assertEquals(false, testAttachments.isEmpty());
		System.assertEquals(true, currentUser.Id == UserInfo.getUserId());

		Map<Id, CaseComment> caseCommentsMap = new Map<Id, CaseComment>(testComments);
		Map<Id, EmailMessage> caseEmailsMap = new Map<Id, EmailMessage>(testEmails);
		Map<Id, Attachment> caseAttachmentsMap = new Map<Id, Attachment>(testAttachments);
		List<Id> caseCommentsId = new List<Id>(caseCommentsMap.keySet());
		List<Id> caseEmailsIds = new List<Id>(caseEmailsMap.keySet());
		List<Id> caseAttachmentsIds = new List<Id>(caseAttachmentsMap.keySet());
		Case newCase = testCases[0].clone();

		Id newCaseId = CaseService.splitCase(testCases[0].Id, newCase, String.join(caseCommentsId, ','), String.join(caseEmailsIds, ','), String.join(caseAttachmentsIds, ','));
		System.assertNotEquals(true, newCaseId == null);
	}

	@isTest
	public static void newSubCaseTest() {
		List<Case> testCases = [SELECT Id FROM Case];
		Case originalCase = CaseService.getOriginalCaseForNewSubCase(testCases[0].Id);
		String recordType = CaseService.getOriginalCaseRecordType(testCases[0].Id);
		List<Attachment> testAttachments = CaseService.getCaseAttachments(testCases[0].Id);

		System.assertEquals(false, testAttachments.isEmpty());

		Map<Id, Attachment> caseAttachmentsMap = new Map<Id, Attachment>(testAttachments);

		List<Id> caseAttachmentsIds = new List<Id>(caseAttachmentsMap.keySet());
		Case newCase = testCases[0].clone();

		Id newCaseId = CaseService.newSubCase(testCases[0].Id, newCase, String.join(caseAttachmentsIds, ','));
	}
}
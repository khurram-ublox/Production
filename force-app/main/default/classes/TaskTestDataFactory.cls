@isTest
public with sharing class TaskTestDataFactory  extends TestDataFactory{

     //AccountTestDataFactory accountDataFactory = new AccountTestDataFactory();
     OpportunityTestDataFactory oppDataFactory = new OpportunityTestDataFactory();
     ContactTestDataFactory contactDataFactory = new ContactTestDataFactory();
     UserTestDataFactory userDataFactory = new UserTestDataFactory();
     User currentUser = createUserWithProfile('Alex Candela','alex.candela@u-blox.com.invalid','EMEA','Sales');

    public TaskTestDataFactory() {
        super('Task');
    }
    
    public override sObject initializeRecord(){
        //Account acc1 = (Account)accountDataFactory.createRecord();
        Opportunity newOpp1 = (Opportunity)oppDataFactory.createRecord();        
        Contact newContact = (Contact)contactDataFactory.createRecord();
        
        Task taskForTest = new Task();
        taskForTest.Subject = 'Stage 2';
        taskForTest.Status = 'In Progress';
        taskForTest.Priority = 'C';
        taskForTest.Type = 'Chip Project';
        taskForTest.OwnerId = currentUser.Id;
        taskForTest.WhatId = newOpp1.Id;
        taskForTest.WhoId = newContact.Id;

        return taskForTest;
    }

    public override sObject createRecord() {
        Task task = (Task)initializeRecord();
        Insert task;
        return task;
    }

    public Task createNewCaseFromTaskRecord(){
        //Account acc1 = (Account)accountDataFactory.createRecord();
        Opportunity newOpp1 = (Opportunity)oppDataFactory.createRecord();      
        Contact newContact = (Contact)contactDataFactory.createRecord();
        

        Task taskForTest = new Task();
        taskForTest.Subject = 'Stage 2';
        taskForTest.Status = 'Not Started';
        taskForTest.Priority = 'C';
        taskForTest.Type = 'Chip Project';
        taskForTest.OwnerId = currentUser.Id;
        taskForTest.WhatId = newOpp1.Id;
        taskForTest.WhoId = newContact.Id;

        insert taskForTest;

        return taskForTest;
    }

    public Task createRecordForFlows() {
        Opportunity newOpp1 = (Opportunity)oppDataFactory.createRecord();        
        Contact newContact = (Contact)contactDataFactory.createRecord();

        Task taskForTest = new Task();
        taskForTest.Subject = 'TestRecord';
        taskForTest.Status = 'In Progress';
        taskForTest.Priority = 'C';
        taskForTest.Type = 'Chip Project';
        taskForTest.OwnerId = currentUser.Id;
        taskForTest.WhatId = newOpp1.Id;
        taskForTest.WhoId = newContact.Id;

        insert taskForTest;

        return taskForTest;
    }

    public Task createTaskForUpdateComments() {
        Opportunity newOpp1 = (Opportunity)oppDataFactory.createRecord();        
        Contact newContact = (Contact)contactDataFactory.createRecord();

        Task taskForTest = new Task();
        taskForTest.Type = 'Quotation';
        taskForTest.Subject = 'Test  for checking comment';
        taskForTest.Status = 'In Progress';
        taskForTest.Priority = 'C';
        taskForTest.OwnerId = currentUser.Id;
        taskForTest.WhatId = newOpp1.Id;
        taskForTest.WhoId = newContact.Id;

        insert taskForTest;

        return taskForTest;
    }

    public Task createTaskForClosedFlag() {
        Opportunity newOpp1 = (Opportunity)oppDataFactory.createRecord();        
        Contact newContact = (Contact)contactDataFactory.createRecord();

        Task taskForTest = new Task();
        taskForTest.Type = 'Quotation';
        taskForTest.Subject = 'Test Subject';
        taskForTest.Close_Task__c = false;
        taskForTest.Status = 'In Progress';
        taskForTest.Priority = 'C';
        taskForTest.OwnerId = currentUser.Id;
        taskForTest.WhatId = newOpp1.Id;
        taskForTest.WhoId = newContact.Id;

        insert taskForTest;

        return taskForTest;
    }

    public override List<sObject> createBulkRecords() {
        for (Integer i = 0; i < numberOfRecords; i++) {
            recordsList.add((Task)initializeRecord());
        }
        Insert recordsList;
        return recordsList;
    }
 
    public Task updateCreateNewStage4TaskTest(Task taskToUpdate) {
        taskToUpdate.Status = 'Completed';
        update taskToUpdate;
        return taskToUpdate;
    } 

    public Task updateCreateNewCaseFromTest(Task taskToUpdate) {
        taskToUpdate.Status = 'In Progress';
        update taskToUpdate;
        return taskToUpdate;
    } 

    public Task updateTaskIsPublicTest(Task taskToUpdate) {
        taskToUpdate.Subject = 'Test Subject';
        update taskToUpdate;
        return taskToUpdate;
    }
    
    public Task updateCommentsonTaskTest(Task taskToUpdate) {
        taskToUpdate.Type = 'Quotation';
        taskToUpdate.Subject = 'Test  for checking comment';
        update taskToUpdate;
        return taskToUpdate;
    }
    
    public Task updateTaskIsClosedTest(Task taskToUpdate) {
        taskToUpdate.Close_Task__c = true;
        update taskToUpdate;
        return taskToUpdate;
    } 

}
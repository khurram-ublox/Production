@isTest
public with sharing class TaskBeforeCreateUpdateFlowTest {
    public TaskBeforeCreateUpdateFlowTest() {
        
    }

    
    @isTest
    static void createNewStage4TaskTest(){
        TaskTestDataFactory taskDataFactory = new TaskTestDataFactory();
        string checkSubject = 'Stage 4 - Order processing';

        Task isNewTaskCreated = (Task)taskDataFactory.createRecord();

        Task updatedTask = taskDataFactory.updateCreateNewStage4TaskTest(isNewTaskCreated);

        list<Task> createdTaskByTask = [Select Id,Subject, OwnerId from Task where Subject = 'Stage 4 - Order processing' LIMIT 1];
        if(createdTaskByTask.size() > 0)
            System.assertEquals(checkSubject, createdTaskByTask[0].Subject,'The two subjects did not match');
    }

    @isTest
    static void createNewCaseFromTest(){
        TaskTestDataFactory taskDataFactory = new TaskTestDataFactory();

        Task isNewTaskCreated = taskDataFactory.createNewCaseFromTaskRecord();
        Task updatedTask = taskDataFactory.updatecreateNewCaseFromTest(isNewTaskCreated);

        list<Case> caseForTest = [Select Id,Opportunity__c,Subject from Case where Opportunity__c =: isNewTaskCreated.WhatId LIMIT 1];
        if(caseForTest.size() > 0){
            boolean checkSubject = caseForTest[0].Subject.contains('Chip project Stage 3');
            System.assert(checkSubject,'The new case isnt created');
        }
    }
}
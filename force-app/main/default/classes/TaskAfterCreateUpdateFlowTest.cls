@isTest
public with sharing class TaskAfterCreateUpdateFlowTest {
    public TaskAfterCreateUpdateFlowTest() {

    }
    @isTest
    static void taskIsPublicTest(){

        TaskTestDataFactory taskDataFactory = new TaskTestDataFactory();

        Task isNewTaskCreated = taskDataFactory.createRecordForFlows();


        Task taskForTest = [Select Id,Subject, IsVisibleInSelfService from Task where Subject = 'TestRecord' LIMIT 1];

        System.assert(taskForTest.IsVisibleInSelfService,'The task is not public');
    }

    @isTest
    static void updateCommentsonTaskTest(){


        TaskTestDataFactory taskDataFactory = new TaskTestDataFactory();

        Task isNewTaskCreated = taskDataFactory.createTaskForUpdateComments();


        Task taskForTest = [Select Id,Description from Task where Id =: isNewTaskCreated.Id LIMIT 1];
        boolean isDescBlank = String.isBlank(taskForTest.Description);
        System.assertEquals(false,isDescBlank,'The task description is not updated');
    }

    @isTest
    static void taskIsClosedTest(){


        TaskTestDataFactory taskDataFactory = new TaskTestDataFactory();

        Task isNewTaskCreated = (Task)taskDataFactory.createTaskForClosedFlag();

        Task updatedTask = taskDataFactory.updateTaskIsClosedTest(isNewTaskCreated);

        Task taskForTest = [Select Id,Status from Task where Id =:updatedTask.Id LIMIT 1];

        System.assertEquals('Completed',taskForTest.Status,'The task status is not updated to Closed');
    }

}
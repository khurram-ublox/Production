"use strict"
window.leaverConfig = [
    {
        objectName :'Users',
		objectDesc :'',
        objectAPI : 'User',
        fields : 'Id, Name, ManagerId, DelegatedApproverId',
        userFields : 'ManagerId,DelegatedApproverId',
        filter : "where (ManagerId = '{uid}' OR DelegatedApproverId = '{uid}') and IsActive = true",
        type : 'SOQL'
    },
    {
        objectName :'Accounts',
		objectDesc :'Query checks Owner, Channel Manager, Global Manager in Account object.',
        objectAPI : 'Account',
        fields : 'Id, Name, OwnerId, BillingCountry, New_Channel_Manager__c, Global_Account_Manager__c',
		userFields : 'New_Channel_Manager__c, Global_Account_Manager__c, OwnerId',	
        filter : "where OwnerId = '{uid}' OR New_Channel_Manager__c='{uid}' OR Global_Account_Manager__c ='{uid}'",
        type : 'SOQL'
    },
	{
        objectName :'Countries',
        objectDesc :'',
        objectAPI : 'Country__c',
        fields : 'Id, Name, ISO_Code__c, OwnerId, Owner.Name',
		userFields : 'OwnerId',	
        filter : "where OwnerId = '{uid}'",
        type : 'SOQL'
    },
    {
        objectName :'Reports',
		objectDesc :'',
        objectAPI : 'Report',
        fields : 'Id,CreatedById,LastRunDate,Name',
		userFields : '',
        //filter : "where CreatedById = '{uid}' AND LastRunDate != LAST_N_DAYS:180",
        filter : "where CreatedById = '{uid}'",
        type : 'SOQL'
    },
    {
        objectName :'Dashboards',
		objectDesc :'Dashboards need to be reassigned before user account deactivation. Otherwise filter criteria stops working.',
        objectAPI : 'Dashboard',
        fields : 'Id, Title, RunningUserId',
		userFields : 'RunningUserId',
        filter : "where RunningUserId = '{uid}'",
        type : 'SOQL'
    },
    {
        objectName :'Scheduled Jobs',
		objectDesc :'Scheduled Process - like reports',
        objectAPI : 'CronTrigger',
        fields : 'Id, OwnerId,PreviousFireTime',
		userFields : '',
        filter : "where OwnerId = '{uid}'",
        type : 'SOQL'
    },
    {
        objectName :'Opportunities',
        objectDesc :'Opportunities with Owner not same as Account Owner',
        objectAPI : 'Opportunity',
        fields : 'Id,Name,OwnerId,Account.OwnerId',
		userFields : 'OwnerId',
        filter : "where (OwnerId = '{uid}' AND Account.OwnerId != '{uid}')",
        type : 'SOQL'
    },
    {
        objectName :'Chatter Groups',
        objectDesc :'Chatter Groups with Owner',
        objectAPI : 'CollaborationGroup',
        fields : 'Id,Name,OwnerId',
		userFields : 'OwnerId',
        filter : "where OwnerId = '{uid}'",
        type : 'SOQL'
    },
    {
        objectName :'Folders',
        objectDesc :'Folders with Owner',
        objectAPI : 'Folder',
        fields : 'Id,Name,CreatedById',
		userFields : '',
        filter : "where CreatedById = '{uid}'",
        type : 'SOQL'
    } 
    ,
    {
        objectName :'WorkFlowAlerts',
		objectDesc :'',
        objectAPI : 'WorkflowAlert',
        fields : 'Id,DeveloperName,EntityDefinitionId,sendertype,CcEmails',
		userFields : '',
        filter : '',
        type : 'TOOLING',
        metaObject:'WorkflowAlert'
    }
    
]; 
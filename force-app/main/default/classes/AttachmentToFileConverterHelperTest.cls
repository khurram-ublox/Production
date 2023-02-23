@IsTest
private class AttachmentToFileConverterHelperTest{
    
    @testSetup
    private static void createTestData() {
        ContentWorkspace testWorkspace = new ContentWorkspace(Name='SalesToolFiles1', DeveloperName='SalesToolFiles1');
        insert testWorkspace;
    }
    
    private static SalesToolFolder__c createSalesToolFolder(){
        SalesToolFolder__c stFolder = new SalesToolFolder__c(Name = 'Default');
        insert stFolder;
        return stFolder;
    }
    
    private static Attachment createAttachment(String parentId){
        Attachment attach=new Attachment();       
        attach.Name='Attach1.txt';
        Blob bodyBlob=Blob.valueOf('Test Attachment');
        attach.body=bodyBlob;
        attach.parentId=parentId;
        insert attach;
        return attach;
    }
    
    static testMethod void createAttachmentToSalesToolFolder()
    {
        SalesToolFiles__c salesToolSetting = SalesToolFiles__c.getInstance();
        salesToolSetting.Library_Folder_Name__c = 'SalesToolFiles1';
        upsert salesToolSetting;
        
        SalesToolFolder__c stFolder = createSalesToolFolder();
        Attachment attStFolder = createAttachment(stFolder.Id);        
    }
    
    static testMethod void createAttachmentToFolderNotPresent()
    {
        SalesToolFiles__c salesToolSetting = SalesToolFiles__c.getInstance();
        salesToolSetting.Library_Folder_Name__c = 'SalesToolFiles2';
        upsert salesToolSetting;
        try{
            SalesToolFolder__c stFolder = createSalesToolFolder();
            Attachment attStFolder = createAttachment(stFolder.Id); 
        }catch(Exception ex){     
        }       
    }
    
    static testMethod void createAttachmentToFolderWithSameName()
    {
        SalesToolFiles__c salesToolSetting = SalesToolFiles__c.getInstance();
        salesToolSetting.Library_Folder_Name__c = 'SalesToolFiles1';
        upsert salesToolSetting;
        
        SalesToolFolder__c stFolder = createSalesToolFolder();
        Attachment attStFolder = createAttachment(stFolder.Id);
        Attachment attStFolder1 = createAttachment(stFolder.Id);        
    }
    
    
}
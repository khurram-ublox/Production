/*
 * Title: AttachmentTrigger
 * Description: One liner trigger that perform record updates/inserts
 * Author:  ldra/saaz
 */

trigger AttachmentTrigger on Attachment (after insert, after delete, after undelete) {
    TriggerFactory.createAndExecuteHandler(AttachmentTriggerHandler.Class);    
}
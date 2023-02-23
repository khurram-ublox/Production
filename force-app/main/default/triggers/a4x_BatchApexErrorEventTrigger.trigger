trigger a4x_BatchApexErrorEventTrigger on BatchApexErrorEvent (after insert) {
    
    a4x_BatchApexErrorEventHelper.batchApexErrorEventProcessing(Trigger.New);
  
}
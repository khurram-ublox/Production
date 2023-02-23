trigger updateTaskNameLegalCase on Case (after update) {
// Only for debug, to be commented before uploading for deployment once the test passed.
//    System.debug(Logginglevel.INFO, '+ updateTaskNameLegalCase'); 

    if (Trigger.isAfter){
// Only for debug, to be commented before uploading for deployment once the test passed.
//        System.debug(Logginglevel.INFO, '> Its a trigger after, newMap.size is ' + Trigger.newMap.values ().size ()); 

        for (Case i: Trigger.newMap.values ()) {
// Only for debug, to be commented before uploading for deployment once the test passed.
//            System.debug(Logginglevel.INFO, '> i.ContactId                        = ' + i.ContactId); 
//            System.debug(Logginglevel.INFO, '> i.RecordTypeId                     = ' + i.RecordTypeId); 
//            System.debug(Logginglevel.INFO, '> i.RecordType                       = ' + i.RecordType); 
//            System.debug(Logginglevel.INFO, '> i.Contact                          = ' + i.Contact); 
//            System.debug(Logginglevel.INFO, '> Trigger.oldMap.get(i.Id).ContactId = ' + Trigger.oldMap.get(i.Id).ContactId); 
//            System.debug(Logginglevel.INFO, '> Trigger.oldMap.get(i.Id).Contact   = ' + Trigger.oldMap.get(i.Id).Contact); 

            // Run only if Contact in Case (Record Type: Legal Case) record has been changed.
            //
            if ((i.ContactId != Trigger.oldMap.get(i.Id).ContactId) && (i.RecordTypeId == '012D0000000BarTIAS')) { 
// Only for debug, to be commented before uploading for deployment once the test passed.
//                System.debug(Logginglevel.INFO, '> i.Id                             = ' + i.Id); 

                // Select only tasks with Subject Email ... (there should actually be only 1 task)
                // 
                List<Task> TaskToCheck = [
                    SELECT Id, Subject, WhoId, WhatId
                    FROM Task
                    WHERE WhatId=:i.Id
                    AND ((Subject = 'Email: NDA sent to the customer')
                    OR (Subject = 'Email: NDA Americas sent to the customer')
                    OR (Subject = 'Email: LULA-M sent to the customer'))];

// Only for debug, to be commented before uploading for deployment once the test passed.
//                System.debug(Logginglevel.INFO, '> TaskToCheck.size                 = ' + TaskToCheck.size ()); 

                List<Task> TaskToUpdate = new List <Task>{};

                for(Task a : TaskToCheck) {
                    a.WhoId = i.ContactId;
                    TaskToUpdate.add(a);
                }
                update TaskToUpdate;
            } // if                
        } // for                
    }
// Only for debug, to be commented before uploading for deployment once the test passed.
//    System.debug(Logginglevel.INFO, '- updateTaskNameLegalCase'); 
}
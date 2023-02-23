/****
Description : Trigger Factory Class will create associated TriggerHandler class for Objects

****/
public with sharing class TriggerFactory
{
    public static void createAndExecuteHandler(Type t)
    {
        ITrigger handler = getHandler(t);
         
        if (handler == null)
        {
            throw new TriggerException('No Trigger Handler found with name : ' + t.getName());
        }
         
        execute(handler);
    }
 
    private static void execute(ITrigger handler)
    {
        if (Trigger.isBefore)
        {
            handler.prepareBefore();
 
            if (Trigger.isDelete)
            {
            	handler.beforeDelete();
            }
            else if (Trigger.isInsert)
            {
                handler.beforeInsert();
            }
            else if (Trigger.isUpdate)
            {
                handler.beforeUpdate();
            }
        }
        else
        {
            handler.prepareAfter();
 
            if (Trigger.isDelete)
            {
                handler.afterDelete();                
            }
            else if (Trigger.isInsert)
            {
                handler.afterInsert();
            }
            else if (Trigger.isUpdate)
            {
                handler.afterUpdate();
            }
        }
 
        handler.finish();
    }
 
    private static ITrigger getHandler(Type t)
    {
        Object o = t.newInstance();
 
        if (!(o instanceOf ITrigger))
        {
            return null;
        }
 
        return (ITrigger)o;
    }
 
    public class TriggerException extends Exception {}
}
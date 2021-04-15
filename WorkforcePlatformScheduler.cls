global class WorkforcePlatformScheduler implements schedulable
{
    global void execute(SchedulableContext objSC)
    {
      WorkforcePlatformSyncBatch objWPB = new WorkforcePlatformSyncBatch(); 
      database.executebatch(objWPB,90);
    }
}
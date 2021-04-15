@isTest
private class WorkforcePlatformSchedulerTest {
     @isTest static void testCallout() {
         Profile objProf = [Select Id,Name from Profile Where Name = 'System Administrator' LIMIT 1];
         User userToCreate = new User();
         userToCreate.FirstName = 'David';
         userToCreate.LastName  = 'Liu';
         userToCreate.Email     = 'dvdkliu+sfdc99@gmail.com';
         userToCreate.Username  = 'sfdc-dreamer@gmail.com';
         userToCreate.Alias     = 'fatty';
         userToCreate.ProfileId = objProf.Id;
         userToCreate.TimeZoneSidKey    = 'America/Denver';
         userToCreate.LocaleSidKey      = 'en_US';
         userToCreate.EmailEncodingKey  = 'UTF-8';
         userToCreate.LanguageLocaleKey = 'en_US';
         insert userToCreate;
         
         Account objAcc = new Account(Name = 'Test Account');
         insert objAcc;
         
         Contact conObj = new Contact(FirstName ='Test', LastName = 'Contact', AccountId=objAcc.Id);
         insert conObj;
         
         Case casObj = new Case(Status ='New', Priority = 'Medium', Origin = 'Email',Agent_Name__c=userToCreate.id,ContactId = conObj.id,AccountId = objAcc.id); 
         insert casObj;
         casObj.Status = 'Closed';
         update casObj;
         
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.StartTest();
        WorkforcePlatformScheduler shObj = new WorkforcePlatformScheduler();
        String schObj = '0 0 23 * * ?';
        system.schedule('Case Workforce Batch', schObj, shObj); 
        Test.stopTest(); 
         
       

    }
}
global class WorkforcePlatformSyncBatch implements Database.Batchable<sObject>,   Database.AllowsCallouts {

 public String query = 'Select Id,Agent_Name__c,Secret_Key__c from Case where Status = \'Closed\' and Secret_Key__c == \'\'';
 public List<Case> lstUpdatedCase =  new List<Case>();
 
 global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(query);
 }

     global void execute(Database.BatchableContext objBatchCon, List<Case> records) {        
        String endpoint;
        string header;      

        for (Case csObj : records ){
         try {                  
          HttpRequest req = new HttpRequest();
          HttpResponse res = new HttpResponse();
          Http http = new Http();
         
         
          Map<String , Object> mapBody = new Map<String , Object>();
          mapBody.put('Id',csObj .id);
          mapBody.put('agentid', csObj.Agent_Name__c);
         
          string requestBody = JSON.serialize(mapBody);

          endpoint = 'https://nfapihub.herokuapp.com/';

          req.setHeader('Content-Type', 'application/json');
          req.setEndpoint(endpoint);
          req.setMethod('POST');
          req.setBody(requestBody);
         
          res = http.send(req);
          if(res.getStatusCode()  == 200){
             String sJson = res.getBody();
             System.debug('Str:' + res.getBody());
             map < string, object > mapResponseJson = (map <string, object> ) JSON.deserializeUntyped(sJson);
             csObj.Secret_Key__c =  (String) mapResponseJson.get('secretKey');
             lstUpdatedCase.add(csObj);
          }
         
                       
         }
         catch (Exception e) {        
           System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );          
         }
       }
    }  

    global void finish(Database.BatchableContext objBC){
          Database.insert(lstUpdatedCase);  
    }
}
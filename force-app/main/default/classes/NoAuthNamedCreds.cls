public class NoAuthNamedCreds {
	
    public static void NoAuthNamedCreds() {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:NoAuthNamedCreds/posts/1');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response != null && response?.getStatusCode() == 200) {
            
            System.debug(response?.getBody());
        }else {
            
            System.debug('No response received');
        }       
    }
}
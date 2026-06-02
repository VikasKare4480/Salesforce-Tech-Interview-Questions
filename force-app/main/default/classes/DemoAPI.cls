public class DemoAPI {

	@AuraEnabled(cacheable=true)
	public static void callloutWithNamedCreds() {

		Http http = new Http();
		HttpRequest request = new  HttpRequest();
		// request.setEndpoint('callout:DemoAPI/post/1');
		request.setEndpoint('callout:DemoAPI/posts/1');
		request.setMethod('GET');
		HttpResponse responce = http.send(request);
		System.debug(responce.getBody());
	}
}
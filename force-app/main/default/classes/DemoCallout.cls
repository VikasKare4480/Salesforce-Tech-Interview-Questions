public class DemoCallout {

    public static void getPosts() {

        Http http = new Http();

        HttpRequest req = new HttpRequest();

        req.setEndpoint('callout:DemoAPI/posts/1');

        req.setMethod('GET');

        HttpResponse res = http.send(req);

        System.debug(res.getBody());
    }
}
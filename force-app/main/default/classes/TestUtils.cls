/**
 * Utility methods for tests.
 * Builds REST requests, sets RestContext, and generates Case payloads.
 */
@isTest
public without sharing class TestUtils {

    // Build a RestRequest and initialize RestContext
    public static RestRequest buildRestRequest(String uri, String method, Map<String, Object> payload) {
        RestRequest req = new RestRequest();
        req.requestUri = uri;
        req.httpMethod = method;
        if (payload != null) {
            req.requestBody = Blob.valueOf(JSON.serialize(payload));
        }
        return req;
    }

    // Overload method for raw JSON
    public static RestRequest buildRestRequest(String uri, String method, String rawJson) {
        RestRequest req = new RestRequest();
        req.requestUri = uri;
        req.httpMethod = method;
        if (rawJson != null) {
            req.requestBody = Blob.valueOf(rawJson);
        }
        return req;
    }

    public static RestResponse initRestContext(RestRequest req) {
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        return res;
    }

    // Build a standard Case API payload
    public static Map<String, Object> buildCasePayload(
        String subject,
        String description,
        String status,
        String origin,
        String name,
        String phone,
        String email
    ) {
        return new Map<String, Object>{
            'subject' => subject,
            'description' => description,
            'status' => status,
            'origin' => origin,
            'name' => name,
            'phone' => phone,
            'email' => email
        };
    }

    // Overload with defaults for quick use
    public static Map<String, Object> buildCasePayload(String subject, String description) {
        return buildCasePayload(
            subject,
            description,
            ApexConstants.CASE_STATUS_NEW,
            ApexConstants.CASE_ORIGIN_WEB,
            'Test User',
            '1234567890',
            'test@example.com'
        );
    }
}

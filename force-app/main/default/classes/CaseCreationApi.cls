/**
 * REST API for creating Case records.
 * Handles JSON payloads, applies defaults, and returns success/failure details.
 */
@RestResource(urlMapping='/v1/caseCreation/*')
global with sharing class CaseCreationApi {
    private static final String CLASS_NAME = 'CaseCreationApi';

    // Wrapper to map incoming JSON
    global class CaseRequest {
        public String subject;
        public String description;
        public String status;
        public String origin;
        public String name;
        public String phone;
        public String email;
    }

    // Wrapper to send as a reponse to the API call. 
    global class CaseResponse {
        global Boolean isSuccess;
        global String message;
        global String stackTrace;
        global Case caseRecord;

        global void processSuccess(Case caseRecord) {
            this.isSuccess = true;
            this.caseRecord = caseRecord;
            this.message = 'This case was successfully created!';
        }

        global void processErrors(String stackTrace, String message) {
            this.isSuccess = false;
            this.stackTrace = stackTrace;
            this.message = message;
        }
    }

    @HttpPost
    global static CaseResponse createCase() {
        CaseResponse caseResponse = new CaseResponse();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            // Deserialize incoming JSON into wrapper
            CaseRequest input = (CaseRequest) JSON.deserialize(req.requestBody.toString(), CaseRequest.class);

            // Map to Case fields
            Case newCase = new Case(
                Subject = input.subject,
                Description = input.description,
                Status = String.isBlank(input.status) ? ApexConstants.CASE_STATUS_NEW : input.status,
                Origin = String.isBlank(input.origin) ? ApexConstants.CASE_ORIGIN_WEB : input.origin,
                SuppliedName = input.name,
                SuppliedPhone = input.phone,
                SuppliedEmail = input.email
            );

            insert newCase;

            res.statusCode = 201; // Created

            caseResponse.processSuccess(newCase);
        } catch (Exception ex) {
            String payload = req?.requestBody == null ? null : req?.requestBody.toString();
            ErrorLogger.logException(ex, ApexConstants.ERROR_TYPE_API, CLASS_NAME, payload);

            res.statusCode = 400; // Bad request
            res.responseBody = Blob.valueOf(
                JSON.serialize(new Map<String, Object>{ 'error' => ex.getMessage(), 'errorLocation' => ex.getStackTraceString() })
            );

            caseResponse.processErrors(ex.getStackTraceString(), ex.getMessage());
        }

        return caseResponse;
    }
}

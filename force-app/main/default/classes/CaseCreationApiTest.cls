@isTest
public class CaseCreationApiTest {
    @isTest
    static void testCaseCreation() {
        Map<String, Object> payload = TestUtils.buildCasePayload('Test Case Creation API', 'Default value for testing');
        RestRequest req = TestUtils.buildRestRequest('/services/apexrest/v1/caseCreation/', 'POST', payload);
        RestResponse res = TestUtils.initRestContext(req);

        Test.startTest();
        CaseCreationApi.CaseResponse response = CaseCreationApi.createCase();
        Test.stopTest();

        Case createdCase = response.caseRecord;

        Assert.areNotEqual(null, createdCase, 'Expected createdCase record to return a value and to not return null');
        Assert.areEqual('Test Case Creation API', createdCase.Subject, 'Expected the Case Name to return the value of APU Test Case');
        Assert.areEqual(201, res.statusCode, 'Expected the statusCode to return 201 meaning the API call was fulfilled');
        Assert.areEqual(true, response.isSuccess, 'Expected the response.isSuccess to return TRUE ');

    }

    @isTest
    static void testCaseCreationSettingDefaults() {
        Map<String, Object> payload = TestUtils.buildCasePayload(
            'Test Case Creation API',
            'Default value for testing',
            null,
            null,
            'Test User',
            '1234567890',
            'test@example.com'
        );
        RestRequest req = TestUtils.buildRestRequest('/services/apexrest/v1/caseCreation/', 'POST', payload);
        RestResponse res = TestUtils.initRestContext(req);

        Test.startTest();
        CaseCreationApi.CaseResponse response = CaseCreationApi.createCase();
        Test.stopTest();
    
        Case createdCase = response.caseRecord;

        Assert.areNotEqual(null, createdCase, 'Expected createdCase record to return a value and to not return null');
        Assert.areEqual(
            ApexConstants.CASE_STATUS_NEW,
            createdCase.Status,
            'Expected the Case Status to return the value of ' + ApexConstants.CASE_STATUS_NEW
        );
        Assert.areEqual(
            ApexConstants.CASE_ORIGIN_WEB,
            createdCase.Origin,
            'Expected the Case Origin to return the value of ' + ApexConstants.CASE_ORIGIN_WEB
        );
        Assert.areEqual(201, res.statusCode, 'Expected the statusCode to return 201 meaning the API call was fulfilled');
        Assert.areEqual(true, response.isSuccess, 'Expected the response.isSuccess to return TRUE ');

    }

    @isTest
    static void testCaseCreationNegative() {
        String payload = '{ "subject": "Test API", "description": "Missing closing quote }'; // malformed JSON
        RestRequest req = TestUtils.buildRestRequest('/services/apexrest/v1/caseCreation/', 'POST', payload);
        RestResponse res = TestUtils.initRestContext(req);

        Test.startTest();
        CaseCreationApi.CaseResponse response = CaseCreationApi.createCase();
        Test.stopTest();
    
        Case createdCase = response.caseRecord;

        Assert.areEqual(null, createdCase, 'Expected createdCase record to return a value and to not return null');
        Assert.areEqual(
            400,
            res.statusCode,
            'Expected the statusCode to return 400 meaning the API call was not fulfilled and failed when executed.'
        );
        Assert.areEqual(false, response.isSuccess, 'Expected the response.isSuccess to return false ');

    }
}
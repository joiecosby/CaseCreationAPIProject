@isTest
public class ErrorLoggerTest {
    public virtual class TestException extends Exception {}

    @isTest
    static void testLogExceptionWithPayload() {
        String context = 'ErrorLoggerTest.testLogExceptionWithPayload';
        String payload = JSON.serialize(TestUtils.buildCasePayload('Test Subject', 'Test Description'));
        TestException testFailure = new TestException('Simulated exception');

        Test.startTest();
        ErrorLogger.logException(testFailure, ApexConstants.ERROR_TYPE_API, context, payload);
        Test.stopTest();

        List<Error_Logger__c> logs = [
            SELECT Context__c, Message__c, Payload__c, Error_Type__c
            FROM Error_Logger__c
            WHERE Context__c = :context
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];

        Assert.areEqual(1, logs.size(), 'Expected one log record to be created');
        Assert.areEqual(testFailure.getMessage(), logs[0].Message__c, 'Message should match exception the value ' + testFailure.getMessage());
        Assert.areEqual(context, logs[0].Context__c, 'Context should match the value ' + context);
        Assert.areEqual(ApexConstants.ERROR_TYPE_API, logs[0].Error_Type__c, 'Context should match the value ' + ApexConstants.ERROR_TYPE_API);
        Assert.areEqual(payload, logs[0].Payload__c, 'Payload should match provided string value of ' + payload);
    }

    @isTest
    static void testLogExceptionWithoutPayload() {
        String context = 'ErrorLoggerTest.testLogExceptionWithoutPayload';
        TestException testFailure = new TestException('Simulated exception');

        Test.startTest();
        ErrorLogger.logException(testFailure, ApexConstants.ERROR_TYPE_APEX_TRIGGER, context);
        Test.stopTest();

        List<Error_Logger__c> logs = [
            SELECT Context__c, Message__c, Payload__c, Error_Type__c
            FROM Error_Logger__c
            WHERE Context__c = :context
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];

        Assert.areEqual(1, logs.size(), 'Expected one log record to be created');
        Assert.areEqual(
            testFailure.getMessage(),
            logs[0].Message__c,
            'Message should match exception the value ' + testFailure.getMessage()
        );
        Assert.areEqual(context, logs[0].Context__c, 'Context should match the value ' + context);
        Assert.areEqual(
            ApexConstants.ERROR_TYPE_APEX_TRIGGER,
            logs[0].Error_Type__c,
            'Context should match the value ' + ApexConstants.ERROR_TYPE_APEX_TRIGGER
        );
        Assert.areEqual(null, logs[0].Payload__c, 'Payload should match provided string value of null');
    }

    @isTest
    static void testLogExceptionNegative() {

        Test.startTest();
        ErrorLogger.logException(null, null, null);
        Test.stopTest();

        List<Error_Logger__c> logs = [
            SELECT Context__c, Message__c, Payload__c, Error_Type__c
            FROM Error_Logger__c
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];

        Assert.areEqual(0, logs.size(), 'Expected zero logs record to be created');
    }
}

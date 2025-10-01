/**
 * ErrorLogger class that current creates Error_Logger__c records so that these issues and be logged and addressed in Salesforce.
 * 
 * Currently does not handle bulification but this is something to be built out in the future.
 */
public without sharing class ErrorLogger {

    public static void logException(Exception exceptionObject, String errorType, String context) {
        logException(exceptionObject, errorType, context, null);
    }

    public static void logException(Exception exceptionObject, String errorType, String context, String payload) {
        try {
            Error_Logger__c log = new Error_Logger__c(
                Context__c = context,
                Message__c = exceptionObject.getMessage(),
                Error_Type__c = errorType,
                Payload__c = payload
            );
            insert log;
        } catch (Exception ex) {
            // Fallback if logging fails
            System.debug('Logging failed: ' + ex.getMessage());
        }
    }
}
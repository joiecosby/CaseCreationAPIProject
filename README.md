# CaseCreationApi — Quick Postman Usage

This shows how to call the CaseCreationApi REST endpoint in Salesforce.

## API Endpoint
POST /services/apexrest/v1/caseCreation/

## Authentication

**Username/Password OAuth Flow:**

1. Request access token:
POST https://login.salesforce.com/services/oauth2/token
Content-Type: application/x-www-form-urlencoded

Body parameters (x-www-form-urlencoded):
- grant_type = `password`
- client_id = `<Connected App Consumer Key>`
- client_secret = `<Connected App Consumer Secret>`
- username = `<Salesforce username>`
- password = `<Salesforce password + security token>`

2. Copy `access_token` from the response.

3. Include in Postman **Headers**:
- Authorization: Bearer <ACCESS_TOKEN>
- Content-Type: application/json

## Example JSON Body

```json
{
    "subject": "Test Case",
    "description": "This case was created via the API for testing purposes. Use this for validating API integration.",
    "status": "New",
    "origin": "Web",
    "name": "Jack Dolittle",
    "phone": "555 123-4567",
    "email": "jack.dolittle@example.com"
}
```

## Steps in Postman

1. Create a new **POST** request.
2. Set the URL: https://orgfarm-54d3776a26-dev-ed.develop.my.salesforce.com/services/apexrest/v1/caseCreation/
3. Add headers as shown above.
4. Select **Body → raw → JSON**, paste the payload.
5. Click **Send** to create a Case.

## Response

- **201 Created**: Case successfully created. Returns JSON with the Case record.
- **400 Bad Request**: Invalid payload or error (logged in `ErrorLogger`).

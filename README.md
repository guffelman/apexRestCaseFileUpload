# CaseFileUploadEndpoint

This is a Salesforce Apex class that provides a REST endpoint for file uploads related to a specific case.

## Endpoint

The endpoint is accessible at `/caseFileUpload/*`.

## Methods

### `handleFileUpload(String caseId)`

This method handles the file upload process. It takes a `caseId` as a parameter.

#### Parameters

- `caseId`: The ID of the case to which the file will be linked.

#### Request Headers

- `Content-Disposition`: This should contain the filename of the uploaded file.

#### Request Body

The request body should contain the binary data of the file to be uploaded.

#### Responses

- `400`: If the `caseId` is not provided or the request body is empty, the method will return a 400 status code with a corresponding error message.
- `500`: If there's an error processing the file or linking the file to the case, the method will return a 500 status code with a corresponding error message.
- `200`: If the file is processed and linked to the case successfully, the method will return a 200 status code with a success message.

## Usage

To use this endpoint, make a POST request to `/caseFileUpload/*` with the `caseId` as a parameter, the filename in the `Content-Disposition` header, and the file data in the request body.

```
curl https://your-instance.salesforce.com/services/apexrest/caseFileUpload \
  -H "Authorization: Bearer your-session-id" \
  -H "Content-Type: multipart/form-data" \
  -H "Content-Disposition: form-data; name=\"file\"; filename=\"test.pdf\"" \
  -X POST \
  -d @test.pdf
```

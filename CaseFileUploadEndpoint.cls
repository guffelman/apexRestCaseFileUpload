@RestResource(urlMapping='/caseFileUpload/*')
global with sharing class CaseFileUploadEndpoint {

    @HttpPost
    global static String handleFileUpload(String caseId) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        // Validate CaseId
        if (String.isBlank(caseId)) {
            res.statusCode = 400;
            return 'CaseId is required.';
        }

        // Validate requestBody
        if (req.requestBody.size() == 0) {
            res.statusCode = 400;
            return 'File content is required.';
        }

        Blob fileBlob;
        List<ContentVersion> contentVersionsToInsert = new List<ContentVersion>();
        List<ContentDocumentLink> contentDocumentLinksToInsert = new List<ContentDocumentLink>();

        try {
            // Get file content from request body
            fileBlob = req.requestBody;

            // get the file name from the request
            String fileName = req.headers.get('Content-Disposition');
            fileName = fileName.substring(fileName.indexOf('filename=') + 10, fileName.length() - 1);

            // Create ContentVersion record
            ContentVersion contentVersion = new ContentVersion(
                VersionData = fileBlob,
                Title = fileName,
                PathOnClient = fileName
            );
            contentVersionsToInsert.add(contentVersion);

            // Create ContentDocumentLink record
            ContentDocumentLink contentDocumentLink = new ContentDocumentLink(
                ContentDocumentId = contentVersion.ContentDocumentId,
                LinkedEntityId = caseId,
                ShareType = 'I'
            );
            contentDocumentLinksToInsert.add(contentDocumentLink);
        } catch (Exception e) {
            res.statusCode = 500;
            return 'Error processing file: ' + e.getMessage();
        }

        try {
            // Insert ContentVersion and ContentDocumentLink records to the database
            insert contentVersionsToInsert;
            insert contentDocumentLinksToInsert;
        } catch (Exception e) {
            res.statusCode = 500;
            return 'Error linking file to Case: ' + e.getMessage();
        }

        res.statusCode = 200;
        return 'File uploaded and linked to Case successfully.';
    }
}

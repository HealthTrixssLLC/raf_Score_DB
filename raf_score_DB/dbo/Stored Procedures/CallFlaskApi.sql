CREATE   PROCEDURE [dbo].[CallFlaskApi]
    @Response NVARCHAR(MAX) OUTPUT
AS
BEGIN
    DECLARE @Object INT;
    DECLARE @ResponseText NVARCHAR(MAX);
    DECLARE @URL NVARCHAR(4000) = 'http://10.10.1.5:6025/process_data';
    DECLARE @JsonBody NVARCHAR(MAX) = '
        {
            "payment_year": 2025,
            "memberships": [
                {
                    "MemberID": "M00912",
                    "FirstName": "John",
                    "MiddleName": "",
                    "LastName": "Doe",
                    "DOB": "1985-10-13",
                    "Gender": "M",
                    "RAType": "C",
                    "ESRD": "N",
                    "Hospice": "N",
                    "Medicaid": "N",
                    "Disabled": "N",
                    "OREC": "0"
                }
            ],
            "diagnoses": [
                {
                    "MemberID": "M00912",
                    "FromDOS": "2024-08-18",
                    "ThruDOS": "2024-08-21",
                    "DxCode": "F13229"
                }
            ]
        }';
    DECLARE @ErrorMsg NVARCHAR(MAX);
    DECLARE @Status INT;
    DECLARE @StatusText NVARCHAR(1000);
    DECLARE @hr INT;
    DECLARE @readyState INT;

    BEGIN TRY
        PRINT 'JSON Body: ' + @JsonBody; -- Debug: print the JSON Body
        
        -- Create the XMLHTTP object
        EXEC @hr = sp_OACreate 'MSXML2.XMLHTTP', @Object OUTPUT;
        IF @hr <> 0
        BEGIN
            EXEC sp_OAGetErrorInfo @Object, @ErrorMsg OUTPUT;
            RAISERROR('Failed to create MSXML2.XMLHTTP object. Error: %s', 16, 1, @ErrorMsg);
        END

        -- Open the connection using POST method; pass 0 for synchronous (false)
        EXEC @hr = sp_OAMethod @Object, 'Open', NULL, 'POST', @URL, 0;
        IF @hr <> 0
        BEGIN
            EXEC sp_OAGetErrorInfo @Object, @ErrorMsg OUTPUT;
            RAISERROR('Failed to open connection. Error: %s', 16, 1, @ErrorMsg);
        END

        -- Set the Content-Type header
        EXEC @hr = sp_OAMethod @Object, 'setRequestHeader', NULL, 'Content-Type', 'application/json';
        IF @hr <> 0
        BEGIN
            EXEC sp_OAGetErrorInfo @Object, @ErrorMsg OUTPUT;
            RAISERROR('Failed to set request header. Error: %s', 16, 1, @ErrorMsg);
        END

        PRINT 'Sending Request...';
        EXEC @hr = sp_OAMethod @Object, 'Send', NULL, @JsonBody;
        IF @hr <> 0
        BEGIN
            EXEC sp_OAGetErrorInfo @Object, @ErrorMsg OUTPUT;
            RAISERROR('Failed to send request. Error: %s', 16, 1, @ErrorMsg);
        END

        -- Wait until the response is fully received (readyState = 4)
        SET @readyState = 0;
        EXEC @hr = sp_OAGetProperty @Object, 'readyState', @readyState OUTPUT;
        WHILE @readyState <> 4
        BEGIN
            WAITFOR DELAY '00:00:01';
            EXEC @hr = sp_OAGetProperty @Object, 'readyState', @readyState OUTPUT;
        END

        -- Retrieve status and status text
        EXEC @hr = sp_OAGetProperty @Object, 'Status', @Status OUTPUT;
        IF @hr <> 0
        BEGIN
            EXEC sp_OAGetErrorInfo @Object, @ErrorMsg OUTPUT;
            RAISERROR('Failed to get status. Error: %s', 16, 1, @ErrorMsg);
        END

        EXEC @hr = sp_OAGetProperty @Object, 'StatusText', @StatusText OUTPUT;
        IF @hr <> 0
        BEGIN
            EXEC sp_OAGetErrorInfo @Object, @ErrorMsg OUTPUT;
            RAISERROR('Failed to get status text. Error: %s', 16, 1, @ErrorMsg);
        END

        -- Retrieve the responseText property
        EXEC @hr = sp_OAGetProperty @Object, 'responseText', @ResponseText OUTPUT;
        IF @hr <> 0
        BEGIN
            EXEC sp_OAGetErrorInfo @Object, @ErrorMsg OUTPUT;
            RAISERROR('Failed to get response text. Error: %s', 16, 1, @ErrorMsg);
        END

        IF @ResponseText IS NULL
        BEGIN
            SET @ResponseText = 'No response text';
        END

        SET @Response = 'Status: ' + CAST(@Status AS NVARCHAR(10)) + ' - ' + @StatusText 
                        + CHAR(13) + CHAR(10) + 'Response: ' + @ResponseText;
        PRINT 'Response: ' + @Response;
    END TRY
    BEGIN CATCH
        SET @ErrorMsg = ERROR_MESSAGE();
        SET @Response = 'Error: ' + @ErrorMsg;
    END CATCH

    IF @Object IS NOT NULL
    BEGIN
        EXEC sp_OADestroy @Object;
    END
END;

USE [13Software]

SET QUOTED_IDENTIFIER ON 
GO 
-- Declare Table Variable @EmailTableVar which will be used to store the email content.
DECLARE @EmailTableVar TABLE(	EmailID INT IDENTITY(1,1),
								EmailSubject NVARCHAR(500),
								EmailBody NVARCHAR(MAX),
								EmailRecipient NVARCHAR(500),
								EmailSent BIT)

-- Populate table with email content, pulled from various 13Software tables. 
INSERT INTO @EmailTableVar (EmailSubject, EmailBody, EmailRecipient, EmailSent)
SELECT 'Cutoff Starting - ' + ' ' + CONVERT(VARCHAR, GETDATE()), 
'We are beginning cutoff. Please log out of TNG. You can log back in using the inquiry password: asdsdlisdnsl',
  'itnotifications@chapter13tacoma.org'
,0 

-- Declare variables that the sp_send_dbmail stored procedure will use.
DECLARE @id INT 
DECLARE @EmailSubject NVARCHAR(500) 
DECLARE @EmailBody NVARCHAR(MAX) 
DECLARE @EmailRecipient NVARCHAR(500) 

-- All rows in @EmailTableVar start with field EmailSent equal to zero. 
-- Loop through the rows in @EmailTableVar and Execute sp_send_dbmail, then 
-- update EmailSent. Keep looping until all rows have been updated. 
WHILE (SELECT COUNT(*) FROM @EmailTableVar WHERE EmailSent=0 AND EmailBody IS NOT NULL) > 0 
BEGIN 
SELECT TOP 1 
    @id = EmailID, 
	@EmailSubject = EmailSubject, 
	@EmailBody = EmailBody, 
	@EmailRecipient = EmailRecipient 
FROM @EmailTableVar 
WHERE EmailSent = 0 

    -- Send the email 
    EXEC msdb.dbo.sp_send_dbmail 
        @profile_name = 'TestProfile', 
        @recipients = @EmailRecipient, 
        @subject = @EmailSubject, 
        @body = @EmailBody, 
        @body_format = 'HTML' 

    -- Update EmailSent 
    UPDATE @EmailTableVar 
	SET EmailSent = 1 
	WHERE EmailID = @Id 
END 

GO
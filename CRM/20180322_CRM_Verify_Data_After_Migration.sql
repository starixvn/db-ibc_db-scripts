
/*
	Created by Patrick
	Date: 2018-03-21	
	DB: DBCRM.bodb_CRM
	Verify data after migration
*/
SET NOCOUNT ON

CREATE TABLE #__tempDataCheck (RowId INT IDENTITY(1,1), FeedbackId INT, Description NVARCHAR(MAX), IsFinished BIT DEFAULT (0))
CREATE CLUSTERED INDEX cix_#__tempDataCheck ON #__tempDataCheck(RowId)

INSERT INTO #__tempDataCheck(FeedbackId, Description)
SELECT FeedbackId, Description
FROM dbo.crmFeedback WITH(NOLOCK)

CREATE TABLE #Error(FeedbackID INT)

DECLARE @RowId INT = 1, @Description VARCHAR(MAX), @FeedbackId INT
WHILE (1=1)
BEGIN
	UPDATE TOP (1) #__tempDataCheck 
	SET @FeedbackID = FeedbackID
		, @Description = Description
		, IsFinished = 1 
	WHERE RowId = @RowId

	IF @@ROWCOUNT = 0 BREAK
	SET @RowId += 1
	PRINT @FeedbackID

	BEGIN TRY
		INSERT INTO #__tempDataCheck
		SELECT @FeedbackID, CAST(@Description AS XML) AS Description                		
	END TRY
	BEGIN CATCH
		INSERT INTO #Error
		SELECT @FeedbackID
	END CATCH 
END

SELECT * FROM #Error
GO

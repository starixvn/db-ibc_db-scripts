/*<info serverAlias="DBPTCS-bodb_PlaytechCS"></info>*/
/*
	Created: 20241010@Kelvin
	DB: DBPTCS-bodb_PlaytechCS
	Task: AG Casino Win Loss - Enhance consistency check [RedmineID: #211837]
*/

USE bodb_PlaytechCS
GO

DECLARE @BatchSize INT = 3000
, @rowcnt INT
, @QueueID bigint

SELECT @QueueID = MAX(QueueID) FROM Product3rd_ImportQueue(NOLOCK) WHERE FinishedTime < '2024-01-01'

SET @rowcnt = @BatchSize

WHILE @rowcnt = @BatchSize
BEGIN
	DELETE TOP (@BatchSize)
	FROM Product3rd_ImportQueue 
	WHERE QueueID < @QueueID AND FinishedTime IS NOT NULL

	SELECT @rowcnt = @@ROWCOUNT

	IF @rowcnt < @BatchSize
		RETURN
END



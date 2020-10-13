/*
	Created: 20201013@Helen
	Task: Script for recover single ticket - batch 1[Redmine:#143427]
	DB: DBTRANS/bodb02
*/
USE bodb02
GO
DECLARE @TransIds			VARCHAR(MAX)
		,@UserId			INT
		,@IP				VARCHAR (50)
		,@ErrCode			INT				= 0		
		,@ErrMsg			VARCHAR(1000)	= ''	
		,@transid_temp		VARCHAR(MAX) = ''
CREATE TABLE #tmpInputTransId (TransId BIGINT)

CREATE TABLE #tmpInputTransId_temp (TransId BIGINT)

SET @TransIds = '110091589876' --'112, 345, 66,77,88,99'

SET @IP = '125.227.140.97'
SET @UserId = 10278938

INSERT INTO #tmpInputTransId (TransId)
SELECT	DISTINCT val
FROM	dbo.f_SplitString(@TransIds, ',')
ORDER BY val
OPTION (maxrecursion 0)

IF @@ROWCOUNT = 0 RETURN
	
-- Deployer Info
DECLARE @ticket_cnt INT, @index INT = 0
SET @ticket_cnt = (SELECT COUNT(*) FROM #tmpInputTransId )
DECLARE @msg nvarchar(200) = 'Currently at batch %d, tickets: %s.'

WHILE (1 = 1)
BEGIN
	
	DELETE FROM #tmpInputTransId_temp

    DELETE TOP (1000)
    FROM #tmpInputTransId OUTPUT DELETED.TransId INTO #tmpInputTransId_temp
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @transid_temp = ''
	SET @transid_temp = STUFF((SELECT ',' + CONVERT(VARCHAR(50),transid) FROM #tmpInputTransId_temp FOR XML PATH ('')),1,1,'')
	
	SET @index = @index + 1
	
	RAISERROR (@msg, 0, 1,@index, @transid_temp) WITH NOWAIT
	
	EXEC dbo.TicketVoiding_RecoverHistorical_Single_Update @Transids = @transid_temp, @UserId = @UserId, @IP = @IP, @ErrCode = @ErrCode OUT, @ErrMsg = @ErrMsg OUT
	
	IF @ErrCode <> 0
	BEGIN
		SELECT @ErrCode, @ErrMsg, @transid_temp AS TransIDs
		RETURN
	END
		
	WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #tmpInputTransId
DROP TABLE #tmpInputTransId_temp
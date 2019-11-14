/*
	Created: 20190916@Helen
	Task: Script for recover Bet14 tickets - Single Ticket [Redmine:115376]
	DB: DBTRANS/bodb02
	
	Notes:
		Single Tickets: TicketVoiding_RecoverHistorical_Single_Update
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

SET @TransIds = '107825080835, 107825086312, 107825192840, 107825197461, 107825413661, 107825481101,107825504262,107825505058,107825506332,107825506468, 107825506780, 107825506882, 107825417284,107825484977,107825505931,107825506123,107837040246,107825939067,107826028820,107826028972,107837043976,107825421883,107825485917,107825986067,107825986851,107826029455,107826029605,107826030413,107826030612,107864904126,107825383461,107825383938,107825383750,107825386053' 

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
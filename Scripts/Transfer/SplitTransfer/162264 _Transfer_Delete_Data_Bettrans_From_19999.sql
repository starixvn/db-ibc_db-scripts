/*<info serverAlias="DBTRANS-bodb02"></info>*/
/*
	Create: 20211206@Sol
	DB : DBTRANS-bodb02
	Task: copy data to new table transfer and transferinfo - [Redmine: #162264]
*/

USE bodb02;

GO

DECLARE 
	@TotalRowDel INT = 0,
	@RowInBatch INT = 10000,
	@CurWinlostDate SMALLDATETIME,
	@Msg VARCHAR(MAX) = ''
	
---get all winlostdate
SELECT DISTINCT winlostdate INTO #WinlostDateList
FROM dbo.bettrans b WITH(NOLOCK) 
WHERE b.bettype >= 19999

WHILE EXISTS (SELECT TOP 1 1 FROM #WinlostDateList)
BEGIN
	
	--- get winlostdate to run
	SELECT @CurWinlostDate = MIN(winlostdate) FROM #WinlostDateList

	---insert transId to temp table
	SELECT b.TransID INTO #TransIdList
	FROM dbo.bettrans b WITH(NOLOCK)
	WHERE b.bettype >= 19999
		AND b.winlostdate = @CurWinlostDate

	SELECT @Msg = CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows affected in current winlostdate: ' + CONVERT(VARCHAR(50), @CurWinlostDate, 112)
    RAISERROR (@Msg, 0, 1) WITH NOWAIT

	---create temp table by batch
	CREATE TABLE #BatchTrans (TransactionId BIGINT PRIMARY KEY)

	---Loop
	WHILE EXISTS (SELECT TOP 1 1 FROM #TransIdList)
	BEGIN

		---reset table #BatchTrans
		DELETE FROM #BatchTrans

		---detele trans list
		DELETE TOP (@RowInBatch) FROM #TransIdList OUTPUT DELETED.TransID INTO #BatchTrans(TransactionId)

		DELETE FROM dbo.bettrans WHERE transid IN (SELECT TransactionId FROM #BatchTrans)

		SELECT @Msg = CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows affected in current DELETE batch loop'
		RAISERROR (@Msg, 0, 1) WITH NOWAIT

	END

	---delete min(winlostdate) and move to the next winlostdate
	DELETE FROM #WinlostDateList WHERE winlostdate = @CurWinlostDate

	---drop table temp
	DROP TABLE #TransIdList
	DROP TABLE #BatchTrans

	SELECT @Msg = 'Winlostdate: ' + CONVERT(VARCHAR(50), @CurWinlostDate, 112) + ' - DONE'
	RAISERROR (@Msg, 0, 1) WITH NOWAIT

END

DROP TABLE #WinlostDateList

GO
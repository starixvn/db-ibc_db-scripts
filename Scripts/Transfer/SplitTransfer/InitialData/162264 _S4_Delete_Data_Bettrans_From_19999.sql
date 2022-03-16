/*<info serverAlias="DBTRANS-bodb02"></info>*/
/*
	Create: 20211206@Sol
	DB : DBTRANS-bodb02
	Task: delete data from bettrans - [Redmine: #162264]
*/

DECLARE 
	@RowInBatch INT = 2000,
	@Msg VARCHAR(MAX) = '',
	@TransIdList VARCHAR(MAX) = '',
	@TotalRow INT = 0
	
---truncate temp table before run
TRUNCATE TABLE TransIdList_Temp
	
---get all transid and insert into temp table
INSERT INTO TransIdList_Temp(TransId)
SELECT b.TransID
FROM dbo.bettrans b WITH(NOLOCK) 
WHERE 
	b.bettype >= 19999

SET @TotalRow = @@ROWCOUNT

SELECT @Msg = 'Insert to temp table completed: ' + CONVERT(VARCHAR(50), @TotalRow, 112)
RAISERROR (@Msg, 0, 1) WITH NOWAIT

---create temp table by batch
CREATE TABLE #BatchTrans (TransactionId BIGINT PRIMARY KEY)

---Loop
WHILE EXISTS (SELECT TOP 1 1 FROM TransIdList_Temp)
BEGIN

	---reset table #BatchTrans
	DELETE FROM #BatchTrans

	---detele trans list
	DELETE TOP (@RowInBatch) FROM TransIdList_Temp OUTPUT DELETED.TransID INTO #BatchTrans(TransactionId)

	---create string transid to pass into Transfer_ExecRep_01 sp
	SET @TransIdList = ''
	SELECT @TransIdList = @TransIdList + CAST(b.TransactionId AS VARCHAR(50)) + ','
	FROM #BatchTrans b

	BEGIN TRY

		---delete data
		EXEC dbo.ExecRep_12 @TransIdList = @TransIdList

		DECLARE @__delayTime VARCHAR(50)
		SELECT @__delayTime = dbo.f_DBA_GetDelayTime('Key1')
		WAITFOR DELAY @__delayTime

	END TRY
	BEGIN CATCH

		SET @Msg = ERROR_MESSAGE()
		RAISERROR(@Msg, 16, 1)

	END CATCH

	SELECT @Msg = 'Rows affected in current DELETE batch loop'
	RAISERROR (@Msg, 0, 1) WITH NOWAIT

END

---drop table temp
DROP TABLE #BatchTrans

SELECT @Msg = 'Total Rows affected: ' + CONVERT(VARCHAR(50), @TotalRow, 112)
RAISERROR (@Msg, 0, 1) WITH NOWAIT

GO